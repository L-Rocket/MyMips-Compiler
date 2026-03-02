#include "MyMipsISelLowering.h"
#include "MyMipsTargetMachine.h"
#include "MyMipsSubtarget.h"
#include "MyMipsRegisterInfo.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/TargetCallingConv.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "mymips-lower"

MyMipsTargetLowering::MyMipsTargetLowering(const MyMipsTargetMachine &TM,
                                           const MyMipsSubtarget &STI)
    : TargetLowering(TM), Subtarget(STI) {

  addRegisterClass(MVT::i32, &MyMips::GPRRegsRegClass);
  computeRegisterProperties(Subtarget.getRegisterInfo());

  setOperationAction(ISD::SDIV, MVT::i32, TargetLowering::Expand);
  setOperationAction(ISD::UDIV, MVT::i32, TargetLowering::Expand);
  setOperationAction(ISD::SREM, MVT::i32, TargetLowering::Expand);
  setOperationAction(ISD::UREM, MVT::i32, TargetLowering::Expand);
  setOperationAction(ISD::MULHU, MVT::i32, TargetLowering::Expand);
  setOperationAction(ISD::MULHS, MVT::i32, TargetLowering::Expand);

  setOperationAction(ISD::UMUL_LOHI, MVT::i32, TargetLowering::Expand);

  // MyMips cannot materialize comparison results into a register.
  // Expand SETCC and SELECT_CC into branches.
  setOperationAction(ISD::SETCC,     MVT::i32, TargetLowering::Expand);
  setOperationAction(ISD::SELECT_CC, MVT::i32, TargetLowering::Expand);

  // MyMips has conditional branches, so BR_CC is legal.
  setOperationAction(ISD::BR_CC,     MVT::i32, TargetLowering::Legal);
  setOperationAction(ISD::BRCOND, MVT::Other, TargetLowering::Legal);
  
  setOperationAction(ISD::GlobalAddress, MVT::i32, TargetLowering::Custom);
  setOperationAction(ISD::BlockAddress, MVT::i32, TargetLowering::Custom);
  setOperationAction(ISD::FrameIndex, MVT::i32, TargetLowering::Custom); // Set FrameIndex to Custom again

  setBooleanContents(ZeroOrOneBooleanContent);
}

const char *MyMipsTargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch ((MyMipsISD::NodeType)Opcode) {
  case MyMipsISD::Ret: return "MyMipsISD::Ret";
  case MyMipsISD::Call: return "MyMipsISD::Call";
  case MyMipsISD::Wrapper: return "MyMipsISD::Wrapper";
  default: return nullptr;
  }
}

SDValue MyMipsTargetLowering::LowerOperation(SDValue Op, SelectionDAG &DAG) const {
  switch (Op.getOpcode()) {
  case ISD::GlobalAddress: {
    const GlobalValue *GV = cast<GlobalAddressSDNode>(Op)->getGlobal();
    return DAG.getTargetGlobalAddress(GV, SDLoc(Op), MVT::i32);
  }
  case ISD::BlockAddress: {
    const BlockAddress *BA = cast<BlockAddressSDNode>(Op)->getBlockAddress();
    return DAG.getTargetBlockAddress(BA, MVT::i32);
  }
  case ISD::FrameIndex: { // Handle FrameIndex
    int FI = cast<FrameIndexSDNode>(Op)->getIndex();
    return DAG.getTargetFrameIndex(FI, Op.getValueType());
  }
  case ISD::BR_CC: {
    SDValue Chain = Op.getOperand(0);
    ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(1))->get();
    SDValue LHS = Op.getOperand(2);
    SDValue RHS = Op.getOperand(3);
    SDValue Dest = Op.getOperand(4);
    
    // If the RHS is an immediate, create an ADDI node to load it into a virtual reg.
    // The ADDI pattern (ADDI R0, imm) will then handle this.
    if (auto *C = dyn_cast<ConstantSDNode>(RHS)) {
      SDLoc DL(Op);
      SDValue Imm = DAG.getConstant(C->getSExtValue(), DL, MVT::i32);
      SDValue ZeroReg = DAG.getRegister(MyMips::R0, MVT::i32);
      SDValue NewRHS = DAG.getNode(ISD::ADD, DL, MVT::i32, ZeroReg, Imm);
      
      // Return a new BR_CC node with the new RHS
      return DAG.getNode(ISD::BR_CC, DL, Op.getValueType(), Chain,
                         Op.getOperand(1), LHS, NewRHS, Dest);
    }
    
    return Op; // Return original if not immediate
  }
  default: // No longer handling FrameIndex here
    return SDValue();
  }
}

static bool CC_MyMips(unsigned ValNo, MVT ValVT,
                      MVT LocVT, CCValAssign::LocInfo LocInfo,
                      ISD::ArgFlagsTy ArgFlags, CCState &State) {
  static const MCPhysReg ArgRegs[] = {
      MyMips::R4, MyMips::R5, MyMips::R6, MyMips::R7
  };
  
  if (unsigned Reg = State.AllocateReg(ArgRegs)) {
    State.addLoc(CCValAssign::getReg(ValNo, ValVT, Reg, LocVT, LocInfo));
    return false;
  }
  
  unsigned Offset = State.AllocateStack(4, Align(4));
  State.addLoc(CCValAssign::getMem(ValNo, ValVT, Offset, LocVT, LocInfo));
  return false;
}

static bool RetCC_MyMips(unsigned ValNo, MVT ValVT,
                         MVT LocVT, CCValAssign::LocInfo LocInfo,
                         ISD::ArgFlagsTy ArgFlags, CCState &State) {
  if (unsigned Reg = State.AllocateReg(MyMips::R2)) {
    State.addLoc(CCValAssign::getReg(ValNo, ValVT, Reg, LocVT, LocInfo));
    return false;
  }
  return true;
}

SDValue MyMipsTargetLowering::LowerFormalArguments(
    SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &dl,
    SelectionDAG &DAG, SmallVectorImpl<SDValue> &InVals) const {
  
  MachineFunction &MF = DAG.getMachineFunction();
  MachineRegisterInfo &RegInfo = MF.getRegInfo();
  
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());
  CCInfo.AnalyzeFormalArguments(Ins, CC_MyMips);
  
  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    if (VA.isRegLoc()) {
      EVT RegVT = VA.getLocVT();
      const TargetRegisterClass *RC = &MyMips::GPRRegsRegClass;
      Register VReg = RegInfo.createVirtualRegister(RC);
      RegInfo.addLiveIn(VA.getLocReg(), VReg);
      SDValue ArgValue = DAG.getCopyFromReg(Chain, dl, VReg, RegVT);
      InVals.push_back(ArgValue);
    } else {
      llvm_unreachable("Stack arguments not implemented yet");
    }
  }
  return Chain;
}

SDValue MyMipsTargetLowering::LowerReturn(
    SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::OutputArg> &Outs,
    const SmallVectorImpl<SDValue> &OutVals, const SDLoc &dl,
    SelectionDAG &DAG) const {

  SmallVector<CCValAssign, 16> RVLocs;
  CCState RetCCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), RVLocs,
                    *DAG.getContext());
  RetCCInfo.AnalyzeReturn(Outs, RetCC_MyMips);

  SDValue Flag;
  SmallVector<SDValue, 4> RetOps(1, Chain);

  for (unsigned i = 0; i != RVLocs.size(); ++i) {
    CCValAssign &VA = RVLocs[i];
    SDValue Val = OutVals[i];
    Chain = DAG.getCopyToReg(Chain, dl, VA.getLocReg(), Val, Flag);
    Flag = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
  }
  
  RetOps[0] = Chain;
  if (Flag.getNode())
    RetOps.push_back(Flag);
    
  return DAG.getNode(MyMipsISD::Ret, dl, MVT::Other, RetOps);
}

SDValue MyMipsTargetLowering::LowerCall(TargetLowering::CallLoweringInfo &CLI,
                                        SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG = CLI.DAG;
  SDLoc &dl = CLI.DL;
  SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
  SmallVectorImpl<SDValue> &OutVals = CLI.OutVals;
  SmallVectorImpl<ISD::InputArg> &Ins = CLI.Ins;
  SDValue Chain = CLI.Chain;
  SDValue Callee = CLI.Callee;
  CallingConv::ID CallConv = CLI.CallConv;
  bool IsVarArg = CLI.IsVarArg;

  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), ArgLocs,
                 *DAG.getContext());
  CCInfo.AnalyzeCallOperands(Outs, CC_MyMips);

  SmallVector<SDValue, 8> Ops;
  SmallVector<std::pair<unsigned, SDValue>, 8> RegsToPass;
  SDValue InFlag;

  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    SDValue Arg = OutVals[i];
    
    if (VA.isRegLoc()) {
      RegsToPass.push_back(std::make_pair(VA.getLocReg(), Arg));
      Chain = DAG.getCopyToReg(Chain, dl, VA.getLocReg(), Arg, InFlag);
      InFlag = Chain.getValue(1);
    } else {
       llvm_unreachable("Stack args in call not implemented");
    }
  }
  
  if (GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(Callee)) {
    Callee = DAG.getTargetGlobalAddress(G->getGlobal(), dl, MVT::i32);
  }

  Ops.push_back(Chain);
  Ops.push_back(Callee);
  
  // Add Register Mask
  const TargetRegisterInfo *TRI = Subtarget.getRegisterInfo();
  const uint32_t *Mask = TRI->getCallPreservedMask(DAG.getMachineFunction(), CallConv);
  if (Mask)
    Ops.push_back(DAG.getRegisterMask(Mask));
  
  for (unsigned i = 0, e = RegsToPass.size(); i != e; ++i) {
      Ops.push_back(DAG.getRegister(RegsToPass[i].first,
                                    RegsToPass[i].second.getValueType()));
  }
  
  if (InFlag.getNode())
    Ops.push_back(InFlag);

  Chain = DAG.getNode(MyMipsISD::Call, dl, DAG.getVTList(MVT::Other, MVT::Glue), Ops);
  InFlag = Chain.getValue(1);
  
  SmallVector<CCValAssign, 16> RVLocs;
  CCState RetCCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), RVLocs,
                    *DAG.getContext());
  RetCCInfo.AnalyzeCallResult(Ins, RetCC_MyMips);

  for (unsigned i = 0; i != RVLocs.size(); ++i) {
      CCValAssign &VA = RVLocs[i];
      SDValue Val = DAG.getCopyFromReg(Chain, dl, VA.getLocReg(), VA.getLocVT(), InFlag);
      Chain = Val.getValue(1);
      InVals.push_back(Val);
      InFlag = Chain.getValue(2);
  }
  
  return Chain;
}

std::pair<unsigned, const TargetRegisterClass *>
MyMipsTargetLowering::getRegForInlineAsmConstraint(const TargetRegisterInfo *TRI,
                                                   StringRef Constraint,
                                                                                                       MVT VT) const {
                                                     if (Constraint.size() == 1) {
                                                       switch (Constraint[0]) {
                                                       case 'r':
                                                         return std::make_pair(0U, &MyMips::GPRRegsRegClass);
                                                       }
                                                     }
                                                     return TargetLowering::getRegForInlineAsmConstraint(TRI, Constraint, VT);
                                                   }
                                                   
                                                   bool MyMipsTargetLowering::isLegalICmpImmediate(int64_t Imm) const {
                                                     // MyMips has no branch-with-immediate instruction,
                                                     // so all immediates in comparisons are illegal.
                                                     return false;
                                                   }
