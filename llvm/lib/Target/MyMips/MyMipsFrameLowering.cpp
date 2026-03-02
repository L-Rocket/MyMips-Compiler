#include "MyMipsFrameLowering.h"
#include "MyMipsSubtarget.h"
#include "MyMipsInstrInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;

void MyMipsFrameLowering::emitPrologue(MachineFunction &MF,
                                       MachineBasicBlock &MBB) const {
  MachineBasicBlock::iterator MBBI = MBB.begin();
  const MyMipsInstrInfo &TII =
      *static_cast<const MyMipsInstrInfo *>(MF.getSubtarget().getInstrInfo());
  DebugLoc dl = MBBI != MBB.end() ? MBBI->getDebugLoc() : DebugLoc();

  uint64_t StackSize = MF.getFrameInfo().getStackSize();

  if (StackSize == 0)
    return;

  // WORD ADDRESSING FIX: Divide StackSize by 4
  int64_t WordStackSize = StackSize / 4;

  // Adjust SP: SP = SP - WordStackSize
  BuildMI(MBB, MBBI, dl, TII.get(MyMips::ADDI), MyMips::SP)
      .addReg(MyMips::SP)
      .addImm(-WordStackSize)
      .setMIFlag(MachineInstr::FrameSetup);
}

void MyMipsFrameLowering::emitEpilogue(MachineFunction &MF,
                                       MachineBasicBlock &MBB) const {
  MachineBasicBlock::iterator MBBI = MBB.getFirstTerminator();
  const MyMipsInstrInfo &TII =
      *static_cast<const MyMipsInstrInfo *>(MF.getSubtarget().getInstrInfo());
  DebugLoc dl = MBBI != MBB.end() ? MBBI->getDebugLoc() : DebugLoc();

  uint64_t StackSize = MF.getFrameInfo().getStackSize();

  if (StackSize == 0)
    return;

  // WORD ADDRESSING FIX: Divide StackSize by 4
  int64_t WordStackSize = StackSize / 4;

  // Restore SP: SP = SP + WordStackSize
  BuildMI(MBB, MBBI, dl, TII.get(MyMips::ADDI), MyMips::SP)
      .addReg(MyMips::SP)
      .addImm(WordStackSize)
      .setMIFlag(MachineInstr::FrameDestroy);
}
