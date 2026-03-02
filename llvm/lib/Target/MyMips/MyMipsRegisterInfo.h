#ifndef LLVM_LIB_TARGET_MYMIPS_MYMIPSREGISTERINFO_H
#define LLVM_LIB_TARGET_MYMIPS_MYMIPSREGISTERINFO_H

#include "llvm/CodeGen/TargetRegisterInfo.h"

#define GET_REGINFO_HEADER
#include "MyMipsGenRegisterInfo.inc"

namespace llvm {
class MyMipsSubtarget; // 前置声明

class MyMipsRegisterInfo : public MyMipsGenRegisterInfo {
public:
  MyMipsRegisterInfo();

  const MCPhysReg *getCalleeSavedRegs(const MachineFunction *MF) const override;
  
  // 声明 getCallPreservedMask
  const uint32_t *getCallPreservedMask(const MachineFunction &MF,
                                       CallingConv::ID CC) const override;

  BitVector getReservedRegs(const MachineFunction &MF) const override;
  bool eliminateFrameIndex(MachineBasicBlock::iterator II, int SPAdj,
                           unsigned FIOperandNum, RegScavenger *RS = nullptr) const override;
  Register getFrameRegister(const MachineFunction &MF) const override;
};
} // end namespace llvm

#endif