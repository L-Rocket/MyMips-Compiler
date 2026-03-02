#include "MyMips.h"
#include "MyMipsTargetMachine.h"
#include "MyMipsISelLowering.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "mymips-isel"

namespace {

class MyMipsDAGToDAGISel : public SelectionDAGISel {
public:
  static char ID;

  MyMipsDAGToDAGISel(MyMipsTargetMachine &TM, CodeGenOptLevel OL)
      : SelectionDAGISel(ID, TM, OL) {}

  StringRef getPassName() const override {
    return "MyMips DAG->DAG Pattern Instruction Selection";
  }

  void Select(SDNode *N) override;
  
  // Complex Pattern Selectors
  bool SelectAddr(SDNode *Parent, SDValue N, SDValue &Base, SDValue &Offset);

  // Include the generated matchers
#include "MyMipsGenDAGISel.inc"
};

char MyMipsDAGToDAGISel::ID = 0;

} // end anonymous namespace

bool MyMipsDAGToDAGISel::SelectAddr(SDNode *Parent, SDValue Addr, SDValue &Base,
                                    SDValue &Offset) {
  EVT ValTy = Addr.getValueType();

  // if Address is FI, get the TargetFrameIndex.
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    Base   = CurDAG->getTargetFrameIndex(FIN->getIndex(), ValTy);
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), ValTy);
    return true;
  }

  // Pattern: (add Val, Constant)
  if (Addr.getOpcode() == ISD::ADD) {
    if (ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1))) {
      if (isInt<17>(CN->getSExtValue())) {
        // Convert Byte Offset to Word Offset!
        int64_t ByteOffset = CN->getSExtValue();
        // We assume aligned access, so just divide by 4.
        // If ByteOffset is not a multiple of 4, this might be wrong for unaligned.
        // But for now, we trust LLVM aligns 4-byte loads.
        int64_t WordOffset = ByteOffset / 4;
        
        Base = Addr.getOperand(0);
        Offset = CurDAG->getTargetConstant(WordOffset, SDLoc(Addr), ValTy);
        return true;
      }
    }
  }

  // Default: (add Val, 0)
  Base   = Addr;
  Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), ValTy);
  return true;
}

void MyMipsDAGToDAGISel::Select(SDNode *Node) {
  // Dump information about the Node being selected
  LLVM_DEBUG(errs() << "Selecting: "; Node->dump(CurDAG); errs() << "\n");

  if (Node->isMachineOpcode()) {
    LLVM_DEBUG(errs() << "== "; Node->dump(CurDAG); errs() << "\n");
    Node->setNodeId(-1);
    return;
  }

  // Instruction Selection not handled by the auto-generated matchers.
  SelectCode(Node);
}


// Pass entry point
FunctionPass *llvm::createMyMipsISelDag(MyMipsTargetMachine &TM) {
  return new MyMipsDAGToDAGISel(TM, TM.getOptLevel());
}