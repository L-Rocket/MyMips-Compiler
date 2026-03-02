# MyMips LLVM Backend 使用指南

本文档介绍了如何使用自定义的 `MyMips` LLVM 后端将代码编译为 MyMips 汇编指令。

## 1. 编译 LLVM 后端

在使用之前，请确保您已经在 `build` 目录下重新编译了 `llc` 工具，以应用最新的更改。

```bash
cd /home/lea/prj/llvm-project-18/build
ninja llc
```

## 2. 核心功能概览

*   **架构名称**: `MyMips`
*   **寻址方式**: **字寻址 (Word-Addressed)**。汇编中的内存偏移量 `offset(base)` 单位为 **字 (4字节)**。
    *   例如: `lw $r2, 1($r29)` 表示读取栈指针偏移 4 字节处的数据。
*   **寄存器命名**: `$r0` - `$r31`。
    *   `$r0`: 恒为 0
    *   `$r2`: 返回值
    *   `$r4 - $r7`: 函数参数
    *   `$r29`: 栈指针 (SP)
    *   `$r31`: 返回地址 (RA)
*   **特殊指令**:
    *   `input $rd`: 从 IO 读取一个字。
    *   `output $rs`: 向 IO 输出一个字。

## 3. 使用方法

目前推荐的流程是：**C 代码 -> LLVM IR -> MyMips 汇编**。

### 3.1 生成 LLVM IR (`.ll`)

您可以使用标准的 `clang` 生成通用的 LLVM IR。建议不指定特定架构，或者使用简单的 MIPS 配置，然后手动修正数据布局（如果需要）。

示例 C 代码 (`test.c`):
```c
void print_char(int c);

int main() {
    print_char(65); // 'A'
    return 0;
}
```

生成 IR:
```bash
# 生成可读的 .ll 文件
clang -S -emit-llvm -O1 -o test.ll test.c
```

### 3.2 编译为 MyMips 汇编 (`.s`)

使用编译好的 `llc` 工具，指定 `-march=MyMips`。

```bash
# 在 build 目录下运行
bin/llc -march=MyMips -filetype=asm test.ll -o test.s
```

生成的 `test.s` 将包含带有 `$` 前缀的寄存器和字寻址的内存指令。

## 4. 编写 C 代码的注意事项

由于没有链接标准库 (libc)，您需要使用 **内联汇编** 来实现输入输出功能。

### 4.1 输入输出辅助函数

建议在您的 C 代码中包含以下辅助函数：

```c
// 输出一个字符/字
void print_char(int c) {
    // volatile 防止编译器优化掉该指令
    __asm__ volatile ("output %0" : : "r"(c));
}

// 读取一个字符/字
int input_char() {
    int res;
    __asm__ volatile ("input %0" : "=r"(res));
    return res;
}
```

### 4.2 递归与栈溢出

编译器现在完全支持递归函数调用。
*   它会自动计算栈帧大小（除以 4 以适配字寻址）。
*   它会自动保存返回地址 (`$r31`)。
*   它会自动保存或溢出跨函数调用时被破坏的参数（Caller-Saved Registers）。

## 5. 示例：递归斐波那契数列

假设您有一个 `fib.ll` 文件（如项目中的 `fib_stack.ll`），编译命令如下：

```bash
bin/llc -march=MyMips -filetype=asm ../llvm/lib/Target/MyMips/fib_stack.ll -o fib.s
```

查看输出：
```bash
cat fib.s
```

**预期输出片段**:
```asm
fib:
    addi    $r29, $r29, -3      # 栈分配 (字单位)
    sw      $r31, 0($r29)       # 保存 RA
    sw      $r17, 1($r29)       # 保存 CSR
    ...
    jal     fib                 # 递归调用
    ...
    lw      $r31, 0($r29)       # 恢复 RA
    addi    $r29, $r29, 3       # 栈释放
    jr      $r31
```

## 6. 常见问题 (Troubleshooting)

*   **错误**: `Cannot select: ...`
    *   **原因**: 代码中使用了 MyMips 后端尚未支持的指令（如浮点数、复杂的位操作等）。
    *   **解决**: 简化 C 代码，或者在 `.td` 文件中添加相应的指令模式。

*   **错误**: 栈偏移量不对
    *   **检查**: 确保这是字寻址架构。编译器内部逻辑已将字节偏移量除以 4。如果模拟器需要字节寻址，请修改 `MyMipsFrameLowering.cpp` 去掉除法逻辑。
