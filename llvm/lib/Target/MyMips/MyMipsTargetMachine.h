#ifndef LLVM_LIB_TARGET_MYMIPS_MYMIPSTARGETMACHINE_H
#define LLVM_LIB_TARGET_MYMIPS_MYMIPSTARGETMACHINE_H

#include "MyMipsSubtarget.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {

class MyMipsTargetMachine : public LLVMTargetMachine {
  std::unique_ptr<TargetLoweringObjectFile> TLOF;
  MyMipsSubtarget Subtarget;

public:
  MyMipsTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                      StringRef FS, const TargetOptions &Options,
                      std::optional<Reloc::Model> RM,
                      std::optional<CodeModel::Model> CM, CodeGenOptLevel OL,
                      bool JIT);

  const MyMipsSubtarget *getSubtargetImpl(const Function &) const override {
    return &Subtarget;
  }

  TargetLoweringObjectFile *getObjFileLowering() const override {
    return TLOF.get();
  }
  
  TargetPassConfig *createPassConfig(PassManagerBase &PM) override;
};

} // end namespace llvm

#endif