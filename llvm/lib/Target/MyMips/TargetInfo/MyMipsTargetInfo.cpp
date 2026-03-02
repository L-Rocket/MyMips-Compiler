#include "MyMipsTargetInfo.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

// ✅ 修复：将实现放在 namespace 内部
namespace llvm {
Target &getTheMyMipsTarget() {
  static Target TheMyMipsTarget;
  return TheMyMipsTarget;
}
} // end namespace llvm

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMyMipsTargetInfo() {
  RegisterTarget<Triple::mips, /*HasJIT=*/true> X(getTheMyMipsTarget(), "MyMips", "My Custom Mips", "MyMips");
}