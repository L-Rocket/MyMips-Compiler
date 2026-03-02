# MyMips 编译器（Duke ECE550 期末项目）

语言： [English (默认)](./README.md) | **中文**

本仓库是一个基于 LLVM 的自定义 C 编译器工具链，实现目标为 **MyMips** 处理器，属于 **Duke University ECE550** 课程期末项目。

## 项目定位

- 基础：LLVM 18（已按项目用途精简）
- 核心修改：`llvm/lib/Target/MyMips` 自定义后端
- 目标：将 C/LLVM IR 编译为 MyMips 汇编

## 后端目录

- `llvm/lib/Target/MyMips`

## 快速构建

```bash
cmake -S llvm -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS=clang \
  -DLLVM_TARGETS_TO_BUILD=X86 \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=MyMips

ninja -C build clang llc
```

## 快速使用

```bash
build/bin/clang -S -emit-llvm -O0 test.c -o test.ll
build/bin/llc -march=MyMips -filetype=asm test.ll -o test.s
```

## CI/CD 自动发布

仓库已包含 GitHub Actions 工作流：

- 工作流文件：`.github/workflows/mymips-release.yml`
- 触发方式：推送形如 `v1.0.0` 的 tag
- 产物：自动构建并在 Release 上传 `clang` / `llc` 二进制

## 文档

- English backend doc: [llvm/lib/Target/MyMips/README.md](./llvm/lib/Target/MyMips/README.md)
- 中文后端文档: [llvm/lib/Target/MyMips/README.zh-CN.md](./llvm/lib/Target/MyMips/README.zh-CN.md)
