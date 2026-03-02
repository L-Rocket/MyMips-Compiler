#include "MyMipsMCTargetDesc.h"
#include "MyMipsInstPrinter.h"
#include "MyMipsMCAsmInfo.h"
// 确保包含这个头文件以找到 getTheMyMipsTarget
#include "TargetInfo/MyMipsTargetInfo.h" 

#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"


using namespace llvm;

// ... 后面的代码
using namespace llvm;

#define GET_INSTRINFO_MC_DESC
#include "MyMipsGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "MyMipsGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "MyMipsGenRegisterInfo.inc"

MCInstrInfo *llvm::createMyMipsMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitMyMipsMCInstrInfo(X);
  return X;
}

MCRegisterInfo *llvm::createMyMipsMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitMyMipsMCRegisterInfo(X, MyMips::RA);
  return X;
}

MCSubtargetInfo *llvm::createMyMipsMCSubtargetInfo(const Triple &TT,
                                                   StringRef CPU, StringRef FS) {
  return createMyMipsMCSubtargetInfoImpl(TT, CPU, /*TuneCPU*/ CPU, FS);
}

static MCInstPrinter *createMyMipsMCInstPrinter(const Triple &T,
                                                unsigned SyntaxVariant,
                                                const MCAsmInfo &MAI,
                                                const MCInstrInfo &MII,
                                                const MCRegisterInfo &MRI) {
  return new MyMipsInstPrinter(MAI, MII, MRI);
}

static MCAsmInfo *createMyMipsMCAsmInfo(const MCRegisterInfo &MRI,
                                        const Triple &TT,
                                        const MCTargetOptions &Options) {
  MCAsmInfo *MAI = new MyMipsMCAsmInfo(TT);
  return MAI;
}

// ✅ 确保只有一个 extern "C" ... 函数
extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMyMipsTargetMC() {
  Target &T = getTheMyMipsTarget();
  TargetRegistry::RegisterMCInstrInfo(T, createMyMipsMCInstrInfo);
  TargetRegistry::RegisterMCRegInfo(T, createMyMipsMCRegisterInfo);
  TargetRegistry::RegisterMCSubtargetInfo(T, createMyMipsMCSubtargetInfo);
  TargetRegistry::RegisterMCInstPrinter(T, createMyMipsMCInstPrinter);
  // 顺便把 AsmInfo 也注册了吧，反正马上要用
  TargetRegistry::RegisterMCAsmInfo(T, createMyMipsMCAsmInfo);
}