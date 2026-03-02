# MyMips LLVM Backend 项目说明

本项目是基于 LLVM 二次开发的自定义后端，目标架构为 `MyMips`。  
核心目标是将 C/LLVM IR 编译为符合 MyMips ISA 的汇编代码。

## 1. 项目定位

- 基础：LLVM 18 源码树中的自定义 Target 后端。
- 范围：主要修改 LLVM 后端（`llvm/lib/Target/MyMips`）。
- 产物：可将 LLVM IR (`.ll`) 降低为 MyMips 汇编 (`.s`)。
- 特点：面向 32 位、字寻址（Word-Addressed）MyMips 处理器。

## 2. 目录结构（关键部分）

- `llvm/lib/Target/MyMips/`
- `llvm/lib/Target/MyMips/TargetInfo/`：Target 注册与对外标识
- `llvm/lib/Target/MyMips/MCTargetDesc/`：MC 层描述、汇编信息、InstPrinter
- `llvm/lib/Target/MyMips/*.td`：寄存器/指令/子目标 TableGen 定义
- `llvm/lib/Target/MyMips/MyMipsISelLowering.cpp`：调用约定与 SelectionDAG lowering
- `llvm/lib/Target/MyMips/MyMipsFrameLowering.cpp`：栈帧与序言/尾声
- `llvm/lib/Target/MyMips/MyMipsAsmPrinter.cpp`：汇编打印与伪指令展开
- `llvm/lib/Target/MyMips/dist/`：可直接使用的工具链与样例
- `llvm/lib/Target/MyMips/test/`：样例 C/IR/汇编文件

## 3. 快速使用（推荐）

如果你只是想快速编译 MyMips 汇编，可直接使用 `dist` 内置工具：

```bash
cd llvm/lib/Target/MyMips/dist
./clang -S -emit-llvm -O0 fib_stack.c -o fib_stack.ll
./llc -march=MyMips -filetype=asm fib_stack.ll -o fib_stack.s
```

建议 `clang` 使用 `-O0`，避免产生当前后端尚未覆盖的复杂 IR 形态。

## 4. 从 LLVM 源码构建并启用 MyMips

当前仓库中的 `MyMips` 目录是独立后端实现；如需通过主构建系统产出带 MyMips 的 `llc`，可用实验目标方式构建：

```bash
cmake -S llvm -B build-mymips -G Ninja \
  -DLLVM_ENABLE_PROJECTS=clang \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=MyMips \
  -DCMAKE_BUILD_TYPE=Release

ninja -C build-mymips llc clang
```

验证：

```bash
build-mymips/bin/llc --version | rg MyMips
```

编译流程：

```bash
build-mymips/bin/clang -S -emit-llvm -O0 test.c -o test.ll
build-mymips/bin/llc -march=MyMips -filetype=asm test.ll -o test.s
```

## 5. 后端已实现能力（概览）

- 32 个通用寄存器：`$r0`~`$r31`（`$r0` 恒为 0）
- 基本整数运算：`add/sub/and/or/sll/srl/addi`
- 访存：`lw/sw`
- 控制流：`beq/bgt/j/jal/jr/ret`
- I/O 指令：`input/output`
- 调用约定：参数寄存器 `r4-r7`，返回值寄存器 `r2`，返回地址寄存器 `r31`，栈指针寄存器 `r29`
- 支持递归与基本栈帧生成（含字寻址偏移处理）
- 支持内联汇编寄存器约束 `"r"`

## 6. 当前限制与注意事项

- 建议 `-O0`（优化级别提高后可能出现 `Cannot select`）。
- 调用参数当前仅完整支持前 4 个寄存器参数；栈上传参路径在 lowering 中未实现。
- 乘除/取模会走扩展路径，若无对应运行时支持需自行规避或软实现。
- 内存与栈偏移按“字寻址”处理（代码中对字节偏移存在 `/4` 逻辑）。
- 条件分支硬件原语以 `beq/bgt` 为主，其它关系由模式/伪指令转换。

## 7. 测试建议

- 先跑目录内样例：`test/fib.c`、`test/fib_stack.c`、`test/stress_test.c`
- 核对生成汇编中的关键点：函数序言/尾声栈调整、`jal/jr` 返回地址保存恢复、分支与立即数比较、`input/output` I/O 语义

## 8. 相关文档

- `llvm/lib/Target/MyMips/README_MyMips.md`：使用说明（历史版本）
- `llvm/lib/Target/MyMips/dist/README.md`：`dist` 工具链用法
- `llvm/lib/Target/MyMips/dist/spec/MyMips_C_Specification.md`：MyMips C 开发约束
- `llvm/lib/Target/MyMips/GEMINI.md`：ISA 与硬件行为说明
