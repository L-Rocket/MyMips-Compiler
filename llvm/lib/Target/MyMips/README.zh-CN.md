# MyMips LLVM 后端

语言： [English (默认)](./README.md) | **中文**

这是一个面向 **MyMips** 处理器的 LLVM 自定义后端，实现用于 **Duke University ECE550** 期末项目。

## 范围

- 后端源码路径：`llvm/lib/Target/MyMips`
- 主要目标：将 LLVM IR 降低为 MyMips 汇编

## 关键组成

- `TargetInfo/`：目标注册
- `MCTargetDesc/`：MC 层、汇编信息、指令打印
- `*.td`：寄存器/指令/子目标 TableGen 定义
- `MyMipsISelLowering.cpp`：调用约定与 DAG lowering
- `MyMipsFrameLowering.cpp`：函数序言/尾声与栈处理
- `MyMipsAsmPrinter.cpp`：汇编输出与伪指令展开

## 构建

```bash
cmake -S llvm -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS=clang \
  -DLLVM_TARGETS_TO_BUILD=X86 \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=MyMips

ninja -C build clang llc
```

## 使用

```bash
build/bin/clang -S -emit-llvm -O0 test.c -o test.ll
build/bin/llc -march=MyMips -filetype=asm test.ll -o test.s
```

## 注意事项

- 当前后端建议使用 `-O0`，兼容性更好。
- 调用约定当前覆盖寄存器参数（`r4-r7`）和返回值寄存器 `r2`。
- 栈与内存偏移按 MyMips 字寻址模型处理。
