#ifndef LLVM_LIB_TARGET_MYMIPS_MYMIPSINSTRINFO_H
#define LLVM_LIB_TARGET_MYMIPS_MYMIPSINSTRINFO_H

#include "MyMipsRegisterInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "MyMipsGenInstrInfo.inc"

namespace llvm {

class MyMipsInstrInfo : public MyMipsGenInstrInfo {
  const MyMipsRegisterInfo RI;

public:
  MyMipsInstrInfo();

  const MyMipsRegisterInfo &getRegisterInfo() const { return RI; }

  void copyPhysReg(MachineBasicBlock &MBB, MachineBasicBlock::iterator MI,
                   const DebugLoc &DL, MCRegister DestReg, MCRegister SrcReg,
                   bool KillSrc) const override;

  void storeRegToStackSlot(MachineBasicBlock &MBB,
                           MachineBasicBlock::iterator MI,
                           Register SrcReg, bool isKill, int FrameIndex,
                           const TargetRegisterClass *RC,
                           const TargetRegisterInfo *TRI,
                           Register VReg) const override;

  void loadRegFromStackSlot(MachineBasicBlock &MBB,
                            MachineBasicBlock::iterator MI,
                            Register DestReg, int FrameIndex,
                            const TargetRegisterClass *RC,
                            const TargetRegisterInfo *TRI,
                            Register VReg) const override;
};

} // end namespace llvm

#endif
