# MyMips LLVM Backend

Language: **English (default)** | [中文](./README.zh-CN.md)

This is a custom LLVM backend for the **MyMips** processor, built for the **Duke University ECE550 final project**.

## Scope

- Backend source path: `llvm/lib/Target/MyMips`
- Main purpose: lower LLVM IR to MyMips assembly

## Key Components

- `TargetInfo/`: target registration
- `MCTargetDesc/`: MC layer, asm info, instruction printer
- `*.td`: TableGen register/instruction/subtarget definitions
- `MyMipsISelLowering.cpp`: calling convention and DAG lowering
- `MyMipsFrameLowering.cpp`: prologue/epilogue and stack handling
- `MyMipsAsmPrinter.cpp`: assembly emission and pseudo expansion

## Build

```bash
cmake -S llvm -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS=clang \
  -DLLVM_TARGETS_TO_BUILD=X86 \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=MyMips

ninja -C build clang llc
```

## Usage

```bash
build/bin/clang -S -emit-llvm -O0 test.c -o test.ll
build/bin/llc -march=MyMips -filetype=asm test.ll -o test.s
```

## Notes

- Use `-O0` for better compatibility with the current backend.
- Calling convention currently covers register arguments (`r4-r7`) and return in `r2`.
- Stack/memory offsets are handled with the MyMips word-addressed model.
