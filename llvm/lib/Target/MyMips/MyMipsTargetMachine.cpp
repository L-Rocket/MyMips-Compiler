#include "MyMipsTargetMachine.h"
#include "TargetInfo/MyMipsTargetInfo.h"
#include "MyMips.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMyMipsTarget() {
  RegisterTargetMachine<MyMipsTargetMachine> X(getTheMyMipsTarget());
}

MyMipsTargetMachine::MyMipsTargetMachine(const Target &T, const Triple &TT,
                                         StringRef CPU, StringRef FS,
                                         const TargetOptions &Options,
                                         std::optional<Reloc::Model> RM,
                                         std::optional<CodeModel::Model> CM,
                                         CodeGenOptLevel OL, bool JIT)
    : LLVMTargetMachine(T, "e-m:e-p:32:32-i8:8:32-i16:16:32-i64:64-n32", TT,
                        CPU, FS, Options, RM.value_or(Reloc::Static),
                        CM.value_or(CodeModel::Small), OL),
      TLOF(std::make_unique<TargetLoweringObjectFileELF>()),
      Subtarget(TT, std::string(CPU), std::string(FS), *this) {
  initAsmInfo();
}

namespace {
class MyMipsPassConfig : public TargetPassConfig {
public:
  MyMipsPassConfig(MyMipsTargetMachine &TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  MyMipsTargetMachine &getMyMipsTargetMachine() const {
    return getTM<MyMipsTargetMachine>();
  }

  bool addInstSelector() override {
    addPass(createMyMipsISelDag(getMyMipsTargetMachine()));
    return false;
  }
};
}

TargetPassConfig *MyMipsTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new MyMipsPassConfig(*this, PM);
}
