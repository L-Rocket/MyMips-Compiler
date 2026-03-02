#include "MyMipsInstPrinter.h"
#include "MyMipsMCTargetDesc.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/Support/FormattedStream.h"

using namespace llvm;

// 引入 TableGen 生成的打印代码
#define GET_INSTRUCTION_NAME
#define PRINT_ALIAS_INSTR
#include "MyMipsGenAsmWriter.inc"

void MyMipsInstPrinter::printInst(const MCInst *MI, uint64_t Address,
                                  StringRef Annot, const MCSubtargetInfo &STI,
                                  raw_ostream &O) {
  // 直接调用 TableGen 生成的 printInstruction
  printInstruction(MI, Address, O);
  printAnnotation(O, Annot);
}

void MyMipsInstPrinter::printOperand(const MCInst *MI, unsigned OpNo,
                                     raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNo);
  if (Op.isReg()) {
    // 打印寄存器名 (如 $r1)
    O << getRegisterName(Op.getReg());
  } else if (Op.isImm()) {
    // 打印立即数
    O << Op.getImm();
  } else if (Op.isExpr()) {
    Op.getExpr()->print(O, &MAI);
  }
}

void MyMipsInstPrinter::printMemOperand(const MCInst *MI, int OpNum,
                                        raw_ostream &O) {
  // Memory operand is printed as "offset(base)"
  // The MIOperandInfo in TD file says (ops GPRRegs, simm17).
  // So OpNum is Base (Reg), OpNum+1 is Offset (Imm).
  
  const MCOperand &Base = MI->getOperand(OpNum);
  const MCOperand &Offset = MI->getOperand(OpNum + 1);

  // Print Offset
  if (Offset.isImm())
    O << Offset.getImm();
  else if (Offset.isExpr())
    Offset.getExpr()->print(O, &MAI);
  else
    O << "0";

  O << "(";
  // Print Base
  if (Base.isReg())
    O << getRegisterName(Base.getReg());
  O << ")";
}