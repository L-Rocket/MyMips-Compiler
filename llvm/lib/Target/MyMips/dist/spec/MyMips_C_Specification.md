# MyMips C 语言开发规范 (V1.0)

本文档定义了为 MyMips 自定义架构编写 C 语言程序时必须遵循的规范、限制和最佳实践。由于 MyMips 是一个精简指令集 (RISC) 架构，且当前的 LLVM 后端实现有特定约束，开发者必须严格遵守本指南以确保代码能正确编译和运行。

---

## 1. 编译环境与工具链

### 1.1 强制编译选项
所有 C 代码 **必须** 使用 `-O0` (零优化) 级别进行编译。

*   **原因**：MyMips 后端目前无法处理 LLVM 在 `-O1` 及以上级别生成的某些复杂 DAG 节点（如针对除法的整数优化、复杂的 `select_cc` 等）。
*   **命令示例**：
    ```bash
    clang -S -emit-llvm -O0 source.c -o source.ll
    llc -march=MyMips -filetype=asm source.ll -o source.s
    ```

### 1.2 目标三元组
虽不需要显式传递 target triple 给 clang，但请知悉我们生成的 LLVM IR 是平台无关的，最终由 `llc -march=MyMips` 负责绑定到特定架构。

---

## 2. 数据类型与内存

### 2.1 基本类型
MyMips 是 32 位架构。

| C 类型 | 大小 (Bytes) | 说明 |
| :--- | :--- | :--- |
| `int` | 4 | **推荐**。最原生的类型，效率最高。 |
| `long` | 4 | 等同于 `int`。 |
| `short` | 2 | **不推荐**。需做符号扩展或截断，增加指令开销。 |
| `char` | 1 | **不推荐**。用于字符串时请注意，硬件是字寻址，字节操作需要额外的移位和掩码逻辑。 |
| `ptr` | 4 | 指针大小为 32 位。 |

### 2.2 内存寻址 (Memory Model)
*   **字寻址 (Word-Addressed)**：硬件层面的地址 `N` 对应的是第 `N` 个 **32位字**。
*   **编译器映射**：LLVM 后端会自动处理字节偏移到字偏移的转换（通常是 `Offset / 4`）。
*   **MMIO (内存映射 IO)**：访问特定硬件地址时，建议使用 `volatile int*`。

**示例：**
```c
// 假设 1024 是某个硬件寄存器的字地址
// 在 C 语言中，需要将其视为地址 4096 (1024 * 4) 或者让编译器处理
#define HARDWARE_REG_BASE ((volatile int*) 0) 
// 实际访问逻辑需根据模拟器内存映射确定
```

---

## 3. 算术与逻辑操作限制

### 3.1 严禁使用的操作符
硬件不支持以下指令，且未链接标准库 (`libc`)，使用它们会导致链接错误或运行时未定义行为。

*   ❌ **除法 (`/`)**：硬件无 `div`。
*   ❌ **取模 (`%`)**：硬件无 `mod`。
*   ❌ **乘法 (`*`)**：硬件无 `mul`。

**解决方案**：
1.  对于常数乘除法，编译器在 `-O0` 下可能不会优化为移位，**建议手动使用移位 (`<<`, `>>`)**。
2.  对于变量乘除法，必须实现软件函数 (Soft Math)。

**软件除法示例**：
```c
int soft_div(int a, int b) {
    int q = 0;
    while (a >= b) {
        a -= b;
        q++;
    }
    return q;
}
```

### 3.2 逻辑运算
*   ✅ 支持：`&` (AND), `|` (OR), `~` (NOT - via NOR logic implied), `<<`, `>>`。
*   ⚠️ **受限**：`^` (XOR)。硬件没有 `xor` 指令。LLVM 会尝试用 `and/or/not` 组合展开，但建议尽量减少使用以减小代码体积。

---

## 4. 控制流 (Control Flow)

MyMips 硬件仅原生支持 `beq` (等于跳转) 和 `bgt` (大于跳转)。

### 4.1 条件判断
编译器支持所有标准 C 比较符，但效率不同：

*   **最高效**：`==`, `!=`, `>`
*   **次高效**：`<` (会被编译器转换为 `>`)
*   **较低效**：`>=`, `<=` (通过伪指令 `BGE`/`BLE` 实现，可能产生额外的指令序列)

**建议**：在性能敏感的代码中，优先使用 `==` 和 `>`。

### 4.2 立即数比较
编译器已支持立即数比较（如 `if (x > 10)`），它会自动生成加载指令。这很方便，但会消耗临时寄存器。

---

## 5. 输入/输出 (I/O) 接口

由于没有标准库，所有 I/O 必须通过**内联汇编**直接调用硬件指令 `input` (Op 0x0E) 和 `output` (Op 0x0F)。

### 5.1 标准 I/O 模板
请将以下函数复制到您的项目的头文件或源文件中：

```c
// 输出一个字符 (低 8 位有效)
void print_char(int c) {
    __asm__ volatile ("output %0" : : "r"(c));
}

// 输入一个字符
int input_char() {
    int res;
    __asm__ volatile ("input %0" : "=r"(res));
    return res;
}
```

### 5.2 打印整数工具
您需要自己实现 `itoa` (整数转字符串) 逻辑，因为没有 `printf`。

---

## 6. 函数调用约定

*   **参数传递**：前 4 个参数通过寄存器 (`$r4` - `$r7`) 传递。超过 4 个的参数通过栈传递。
*   **返回值**：通过 `$r2` 传递。
*   **递归**：支持递归调用（编译器会自动处理 `$ra` 保存），但请注意栈空间有限（取决于模拟器/硬件的内存大小）。

---

## 7. 代码示例：推荐风格

```c
// --- mymips_io.h ---
void print_char(int c) { __asm__ volatile ("output %0" : : "r"(c)); }
int input_char() { int res; __asm__ volatile ("input %0" : "=r"(res)); return res; }

// --- main.c ---
// 避免包含 <stdio.h> 等标准库
// #include "mymips_io.h"

// 推荐：使用 helper 函数处理不支持的算术
int safe_mul_2(int n) {
    return n << 1; // 优于 n * 2
}

int main() {
    int a = input_char() - '0'; // 简单的 ASCII 转换
    int b = 5;
    
    // 推荐：简单的比较逻辑
    if (a > b) {
        print_char('G'); // Greater
    } else if (a == b) {
        print_char('E'); // Equal
    } else {
        print_char('L'); // Less
    }
    
    // 警告：不要做 a / b
    int c = safe_mul_2(a);
    
    // 输出结果 (假设结果只有一位数)
    print_char(c + '0');
    
    return 0;
}
```

## 8. 常见错误 (Anti-Patterns)

1.  **错误**：`int a = b * c;`
    *   **后果**：链接错误 (`undefined reference to __mulsi3`) 或 运行时崩溃。
2.  **错误**：`printf("Hello");`
    *   **后果**：链接错误。必须使用 `print_char` 逐字打印。
3.  **错误**：使用 `float` 或 `double`。
    *   **后果**：极其低效或无法编译（MyMips 无 FPU）。
4.  **错误**：在 `clang` 编译时忘记加 `-O0`。
    *   **后果**：`llc` 报错 `Cannot select` 或生成错误的机器码。
