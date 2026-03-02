# MyMips 编译器工具链使用指南

本文档介绍了如何使用提供的工具将 C 语言代码编译为自定义的 MyMips 架构汇编代码。本工具链已针对 MyMips 的特定硬件约束（如仅支持 `beq`/`bgt` 分支指令）进行了优化。

## 文件夹内容

*   `clang`: C/C++ 语言的前端编译器。用于将 C 代码转换为 LLVM IR。
*   `llc`: **更新版** LLVM 后端编译器。用于将 LLVM IR 转换为 MyMips 汇编代码。包含了对条件分支、立即数比较和复杂控制流的关键修复。
*   `fib_stack.c`: 斐波那契数列计算示例（递归与栈操作）。
*   `stress_test.c`: **新增** 综合压力测试套件。包含寄存器压力测试、递归 GCD 算法、内存读写和参数传递测试，用于全面验证编译器的稳定性。

## 编译步骤

由于 MyMips 硬件不支持某些高级指令（如除法、复杂的条件设置指令），建议使用 `-O0`（无优化）进行编译，以避免生成无法处理的复杂 IR 结构。

### 1. 编译示例程序 (Fibonacci)

```bash
# 1. 将 C 代码编译为 LLVM IR
./clang -S -emit-llvm -O0 fib_stack.c -o fib_stack.ll

# 2. 将 LLVM IR 编译为 MyMips 汇编
./llc -march=MyMips -filetype=asm fib_stack.ll -o fib_stack.s
```

### 2. 编译压力测试 (Stress Test)

```bash
# 1. 将 C 代码编译为 LLVM IR
./clang -S -emit-llvm -O0 stress_test.c -o stress_test.ll

# 2. 将 LLVM IR 编译为 MyMips 汇编
./llc -march=MyMips -filetype=asm stress_test.ll -o stress_test.s
```

## 硬件适配说明 (重要)

本编译器针对 MyMips 架构做了以下特殊处理：

1.  **条件分支 (Branching)**:
    *   硬件仅支持 `beq` (相等) 和 `bgt` (大于)。
    *   编译器会自动将 `<` (小于) 转换为 `>` (大于) 的交换形式。
    *   对于 `!=` (不等于)、`<=` (小于等于) 和 `>=` (大于等于)，编译器会生成伪指令 (`BNE`, `BLE`, `BGE`)。**注意**：如果您的汇编器或模拟器不支持这些伪指令，您可能需要手动将它们展开为组合跳转（例如 `BLE` 可以展开为 `BGT target_skip; J target_dest; target_skip:`）。

2.  **立即数比较 (Immediate Comparisons)**:
    *   硬件分支指令不支持立即数操作数 (例如 `if (a > 10)`).
    *   编译器会自动检测这种情况，并插入 `addi` 指令将立即数加载到临时寄存器中，然后再进行比较。

3.  **乘除法**:
    *   硬件无乘除法指令。请在 C 代码中避免使用 `/` 和 `%`，或者使用软件实现的版本（如 `stress_test.c` 中所示）。