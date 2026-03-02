#include "MyMips.h"
#include "MyMipsInstrInfo.h"
#include "MyMipsTargetMachine.h"
#include "TargetInfo/MyMipsTargetInfo.h"
#include "MCTargetDesc/MyMipsInstPrinter.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCSymbol.h"

using namespace llvm;

namespace {
class MyMipsAsmPrinter : public AsmPrinter {
public:
  explicit MyMipsAsmPrinter(TargetMachine &TM, std::unique_ptr<MCStreamer> Streamer)
      : AsmPrinter(TM, std::move(Streamer)) {}

  StringRef getPassName() const override { return "MyMips Assembly Printer"; }

  void emitInstruction(const MachineInstr *MI) override;
  
  bool lowerOperand(const MachineOperand &MO, MCOperand &MCOp);

  // Implement PrintAsmOperand for inline assembly
  bool PrintAsmOperand(const MachineInstr *MI, unsigned OpNo,
                       const char *ExtraCode, raw_ostream &O) override;
};
}

void MyMipsAsmPrinter::emitInstruction(const MachineInstr *MI) {
  // Expand BNE pseudo: bne $rs, $rt, target -> bgt $rs, $rt, target; bgt $rt, $rs, target
  if (MI->getOpcode() == MyMips::BNE) {
    MCInst Inst1;
    Inst1.setOpcode(MyMips::BGT);
    Inst1.addOperand(MCOperand::createReg(MI->getOperand(0).getReg())); // rs
    Inst1.addOperand(MCOperand::createReg(MI->getOperand(1).getReg())); // rt
    MCOperand TargetOp;
    lowerOperand(MI->getOperand(2), TargetOp);
    Inst1.addOperand(TargetOp);
    EmitToStreamer(*OutStreamer, Inst1);

    MCInst Inst2;
    Inst2.setOpcode(MyMips::BGT);
    Inst2.addOperand(MCOperand::createReg(MI->getOperand(1).getReg())); // rt
    Inst2.addOperand(MCOperand::createReg(MI->getOperand(0).getReg())); // rs
    Inst2.addOperand(TargetOp);
    EmitToStreamer(*OutStreamer, Inst2);
    return;
  }

  MCInst TmpInst;
  TmpInst.setOpcode(MI->getOpcode());
  
  for (const MachineOperand &MO : MI->operands()) {
    MCOperand MCOp;
    if (lowerOperand(MO, MCOp))
      TmpInst.addOperand(MCOp);
  }
  EmitToStreamer(*OutStreamer, TmpInst);
}

bool MyMipsAsmPrinter::lowerOperand(const MachineOperand &MO, MCOperand &MCOp) {
  switch (MO.getType()) {
  default: 
    return false;
  case MachineOperand::MO_Register:
    if (MO.isImplicit()) return false;
    MCOp = MCOperand::createReg(MO.getReg());
    return true;
  case MachineOperand::MO_Immediate:
    MCOp = MCOperand::createImm(MO.getImm());
    return true;
  case MachineOperand::MO_GlobalAddress:
    MCOp = MCOperand::createExpr(MCSymbolRefExpr::create(getSymbol(MO.getGlobal()), OutContext));
    return true;
  case MachineOperand::MO_MachineBasicBlock:
    MCOp = MCOperand::createExpr(MCSymbolRefExpr::create(MO.getMBB()->getSymbol(), OutContext));
    return true;
  case MachineOperand::MO_BlockAddress:
    MCOp = MCOperand::createExpr(MCSymbolRefExpr::create(GetBlockAddressSymbol(MO.getBlockAddress()), OutContext));
    return true;
  case MachineOperand::MO_ExternalSymbol:
     MCOp = MCOperand::createExpr(MCSymbolRefExpr::create(GetExternalSymbolSymbol(MO.getSymbolName()), OutContext));
     return true;
  }
}

bool MyMipsAsmPrinter::PrintAsmOperand(const MachineInstr *MI, unsigned OpNo,
                                       const char *ExtraCode, raw_ostream &O) {
  // Default handling for inline asm operands
  if (ExtraCode && ExtraCode[0])
    return true; // Unknown modifier

  const MachineOperand &MO = MI->getOperand(OpNo);
  switch (MO.getType()) {
  case MachineOperand::MO_Register:
    O << MyMipsInstPrinter::getRegisterName(MO.getReg());
    return false;
  case MachineOperand::MO_Immediate:
    O << MO.getImm();
    return false;
  default:
    return true; // Failed to print
  }
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMyMipsAsmPrinter() {
  RegisterAsmPrinter<MyMipsAsmPrinter> X(getTheMyMipsTarget());
}
