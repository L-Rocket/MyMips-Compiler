#ifndef LLVM_LIB_TARGET_MYMIPS_MYMIPSSUBTARGET_H
#define LLVM_LIB_TARGET_MYMIPS_MYMIPSSUBTARGET_H

#include "MyMipsInstrInfo.h"
#include "MyMipsFrameLowering.h"
#include "MyMipsISelLowering.h" // Added
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/DataLayout.h"

#define GET_SUBTARGETINFO_HEADER
#include "MyMipsGenSubtargetInfo.inc"

namespace llvm {
class TargetMachine;

class MyMipsSubtarget : public MyMipsGenSubtargetInfo {
  MyMipsFrameLowering FrameLowering;
  MyMipsInstrInfo InstrInfo;
  MyMipsTargetLowering TLInfo; // Added

public:
  MyMipsSubtarget(const Triple &TT, const std::string &CPU,
                  const std::string &FS, const MyMipsTargetMachine &TM);

  void ParseSubtargetFeatures(StringRef CPU, StringRef TuneCPU, StringRef FS);

  const MyMipsInstrInfo *getInstrInfo() const override { return &InstrInfo; }
  const MyMipsRegisterInfo *getRegisterInfo() const override {
    return &InstrInfo.getRegisterInfo();
  }
  const MyMipsFrameLowering *getFrameLowering() const override {
    return &FrameLowering;
  }
  const MyMipsTargetLowering *getTargetLowering() const override {
    return &TLInfo;
  }
};
} // end namespace llvm

#endif
