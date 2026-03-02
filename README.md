# MyMips Compiler (Duke ECE550 Final Project)

Language: **English (default)** | [中文](./README.zh-CN.md)

This repository contains a custom LLVM-based C compiler toolchain for the **MyMips** processor, implemented as a final project for **Duke University ECE550**.

## What This Project Is

- Base: LLVM 18 codebase (trimmed for this project)
- Core work: custom backend under `llvm/lib/Target/MyMips`
- Goal: compile C/LLVM IR into MyMips assembly

## Backend Path

- `llvm/lib/Target/MyMips`

## Quick Build

```bash
cmake -S llvm -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS=clang \
  -DLLVM_TARGETS_TO_BUILD=X86 \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=MyMips

ninja -C build clang llc
```

## Quick Usage

```bash
build/bin/clang -S -emit-llvm -O0 test.c -o test.ll
build/bin/llc -march=MyMips -filetype=asm test.ll -o test.s
```

## CI/CD Release

A GitHub Actions workflow is included:

- Workflow file: `.github/workflows/mymips-release.yml`
- Trigger: push a tag like `v1.0.0`
- Output: release assets containing compiled `clang` and `llc`

## Documentation

- English backend doc: [llvm/lib/Target/MyMips/README.md](./llvm/lib/Target/MyMips/README.md)
- 中文后端文档: [llvm/lib/Target/MyMips/README.zh-CN.md](./llvm/lib/Target/MyMips/README.zh-CN.md)
