#include "MyMipsRegisterInfo.h"
#include "MCTargetDesc/MyMipsMCTargetDesc.h"
#include "MyMipsSubtarget.h"
#include "MyMipsFrameLowering.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"

using namespace llvm;

#define GET_REGINFO_TARGET_DESC
#include "MyMipsGenRegisterInfo.inc"

MyMipsRegisterInfo::MyMipsRegisterInfo() : MyMipsGenRegisterInfo(MyMips::R31) {} 

const MCPhysReg *
MyMipsRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  return CSR_O32_SaveList;
}

const uint32_t *
MyMipsRegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                         CallingConv::ID CC) const {
  return CSR_O32_RegMask;
}

BitVector MyMipsRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());
  Reserved.set(MyMips::R29); // SP
  Reserved.set(MyMips::R31); // RA
  Reserved.set(MyMips::R0);  // ZERO
  return Reserved;
}

bool MyMipsRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                             int SPAdj, unsigned FIOperandNum,
                                             RegScavenger *RS) const {
  MachineInstr &MI = *II;
  MachineFunction &MF = *MI.getParent()->getParent();
  
  int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
  uint64_t StackSize = MF.getFrameInfo().getStackSize();
  int64_t Offset = MF.getFrameInfo().getObjectOffset(FrameIndex) + StackSize + SPAdj;

  // Replace FrameIndex with SP
  MI.getOperand(FIOperandNum).ChangeToRegister(MyMips::R29, false);
  
  // Add Offset to the immediate operand.
  // We assume the immediate operand follows the FrameIndex operand.
  int ImmOpIdx = FIOperandNum + 1;
  
  if (ImmOpIdx < MI.getNumOperands()) {
      if (MI.getOperand(ImmOpIdx).isImm()) {
          Offset += MI.getOperand(ImmOpIdx).getImm();
          
          // WORD ADDRESSING FIX: Divide offset by 4
          if (Offset % 4 != 0) {
              // In a real compiler, we should error or handle unaligned access.
              // For now, we assume it's fine or aligned enough.
          }
          MI.getOperand(ImmOpIdx).setImm(Offset / 4);
      }
  }
  
  return true;
}

Register MyMipsRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return MyMips::R29;
}