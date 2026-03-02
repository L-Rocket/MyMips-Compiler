#include "MyMipsInstrInfo.h"
#include "MCTargetDesc/MyMipsMCTargetDesc.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/IR/DebugInfo.h"

using namespace llvm;

#define GET_INSTRINFO_CTOR_DTOR
#include "MyMipsGenInstrInfo.inc"

MyMipsInstrInfo::MyMipsInstrInfo()
  : MyMipsGenInstrInfo(),
    RI() {}

void MyMipsInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator MI,
                                  const DebugLoc &DL, MCRegister DestReg,
                                  MCRegister SrcReg, bool KillSrc) const {
  
  if (MyMips::GPRRegsRegClass.contains(DestReg, SrcReg)) {
      BuildMI(MBB, MI, DL, get(MyMips::ADDI), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc))
        .addImm(0);
      return;
  }
  
  llvm_unreachable("Cannot copy registers");
}

void MyMipsInstrInfo::storeRegToStackSlot(MachineBasicBlock &MBB,
                                          MachineBasicBlock::iterator I,
                                          Register SrcReg, bool isKill,
                                          int FrameIndex,
                                          const TargetRegisterClass *RC,
                                          const TargetRegisterInfo *TRI,
                                          Register VReg) const {
  DebugLoc DL;
  if (I != MBB.end()) DL = I->getDebugLoc();

  if (RC == &MyMips::GPRRegsRegClass) {
    BuildMI(MBB, I, DL, get(MyMips::SW))
      .addReg(SrcReg, getKillRegState(isKill))
      .addFrameIndex(FrameIndex)
      .addImm(0);
  } else {
    llvm_unreachable("Can't store this register to stack slot");
  }
}

void MyMipsInstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB,
                                           MachineBasicBlock::iterator I,
                                           Register DestReg, int FrameIndex,
                                           const TargetRegisterClass *RC,
                                           const TargetRegisterInfo *TRI,
                                           Register VReg) const {
  DebugLoc DL;
  if (I != MBB.end()) DL = I->getDebugLoc();

  if (RC == &MyMips::GPRRegsRegClass) {
    BuildMI(MBB, I, DL, get(MyMips::LW), DestReg)
      .addFrameIndex(FrameIndex)
      .addImm(0);
  } else {
    llvm_unreachable("Can't load this register from stack slot");
  }
}
