#include "MyMipsSubtarget.h"
#include "MyMipsTargetMachine.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "mymips-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#include "MyMipsGenSubtargetInfo.inc"

#define GET_SUBTARGETINFO_CTOR
#include "MyMipsGenSubtargetInfo.inc"

MyMipsSubtarget::MyMipsSubtarget(const Triple &TT, const std::string &CPU,
                                 const std::string &FS, const MyMipsTargetMachine &TM)
    : MyMipsGenSubtargetInfo(TT, CPU, /*TuneCPU*/ CPU, FS),
      FrameLowering(*this),
      InstrInfo(),
      TLInfo(TM, *this) {
        ParseSubtargetFeatures(CPU, CPU, FS);
      }