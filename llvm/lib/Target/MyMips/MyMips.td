// llvm/lib/Target/MyMips/MyMips.td

include "llvm/Target/Target.td"
include "MyMipsRegisterInfo.td"
include "MyMipsInstrInfo.td"
include "MyMipsSubtarget.td"

def MyMipsInstrInfo : InstrInfo;

// ✅ 修复：Processor 的第二个参数必须是 ProcessorItineraries 类型 (NoItineraries)
// 第三个参数是 Feature 列表
// 第四个参数才是 Scheduling Model (NoSchedModel)
def : Processor<"generic", NoItineraries, []>;

def MyMips : Target {
  let InstructionSet = MyMipsInstrInfo;
}