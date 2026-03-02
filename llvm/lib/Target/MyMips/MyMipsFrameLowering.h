#ifndef LLVM_LIB_TARGET_MYMIPS_MYMIPSFRAMELOWERING_H
#define LLVM_LIB_TARGET_MYMIPS_MYMIPSFRAMELOWERING_H

#include "llvm/CodeGen/TargetFrameLowering.h"

namespace llvm {
class MyMipsSubtarget;

class MyMipsFrameLowering : public TargetFrameLowering {
public:
  // 构造函数：栈向下增长，对齐为 4 字节，局部变量偏移为 0
  explicit MyMipsFrameLowering(const MyMipsSubtarget &sti)
      : TargetFrameLowering(StackGrowsDown, Align(4), 0) {}

  // 必须实现：发射函数序言 (Prologue) - 开辟栈帧
  void emitPrologue(MachineFunction &MF, MachineBasicBlock &MBB) const override;

  // 必须实现：发射函数尾声 (Epilogue) - 恢复栈帧
  void emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const override;

  // 必须实现：是否有保留的调用栈 (通常为 false)
  bool hasFP(const MachineFunction &MF) const override { return false; }
};
} // End llvm namespace

#endif