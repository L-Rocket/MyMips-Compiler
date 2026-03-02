#ifndef LLVM_LIB_TARGET_MYMIPS_MYMIPS_H
#define LLVM_LIB_TARGET_MYMIPS_MYMIPS_H

#include "MCTargetDesc/MyMipsMCTargetDesc.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
  class MyMipsTargetMachine;
  class FunctionPass;

  FunctionPass *createMyMipsISelDag(MyMipsTargetMachine &TM);
}

#endif
