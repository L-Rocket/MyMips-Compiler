#ifndef LLVM_LIB_TARGET_MYMIPS_MYMIPSISELLOWERING_H
#define LLVM_LIB_TARGET_MYMIPS_MYMIPSISELLOWERING_H

#include "MyMips.h"
#include "llvm/CodeGen/TargetLowering.h"

namespace llvm {
class MyMipsSubtarget;

namespace MyMipsISD {
enum NodeType : unsigned {
  FIRST_NUMBER = ISD::BUILTIN_OP_END,
  Ret,
  Call,
  Wrapper // For global address wrapping if needed, or just placeholder
};
}

class MyMipsTargetLowering : public TargetLowering {
  const MyMipsSubtarget &Subtarget;

public:
  explicit MyMipsTargetLowering(const MyMipsTargetMachine &TM,
                                const MyMipsSubtarget &STI);

  // Provide custom lowering hooks
  SDValue LowerOperation(SDValue Op, SelectionDAG &DAG) const override;

  // Implement calling convention
  SDValue LowerFormalArguments(SDValue Chain, CallingConv::ID CallConv,
                               bool IsVarArg,
                               const SmallVectorImpl<ISD::InputArg> &Ins,
                               const SDLoc &dl, SelectionDAG &DAG,
                               SmallVectorImpl<SDValue> &InVals) const override;

  SDValue LowerReturn(SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
                      const SmallVectorImpl<ISD::OutputArg> &Outs,
                      const SmallVectorImpl<SDValue> &OutVals, const SDLoc &dl,
                      SelectionDAG &DAG) const override;
  
  SDValue LowerCall(TargetLowering::CallLoweringInfo &CLI,
                    SmallVectorImpl<SDValue> &InVals) const override;

  const char *getTargetNodeName(unsigned Opcode) const override;

  std::pair<unsigned, const TargetRegisterClass *>
  getRegForInlineAsmConstraint(const TargetRegisterInfo *TRI,
                               StringRef Constraint, MVT VT) const override;

  bool isLegalICmpImmediate(int64_t Imm) const override;
};
}

#endif
