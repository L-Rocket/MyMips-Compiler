#ifndef LLVM_LIB_TARGET_MYMIPS_MCTARGETDESC_MYMIPSINSTPRINTER_H
#define LLVM_LIB_TARGET_MYMIPS_MCTARGETDESC_MYMIPSINSTPRINTER_H

#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCRegister.h" 
#include <utility>

namespace llvm {
class MyMipsInstPrinter : public MCInstPrinter {
public:
  MyMipsInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                    const MCRegisterInfo &MRI)
      : MCInstPrinter(MAI, MII, MRI) {}

  void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                 const MCSubtargetInfo &STI, raw_ostream &O) override;

  void printInstruction(const MCInst *MI, uint64_t Address, raw_ostream &O);
  
  static const char *getRegisterName(MCRegister Reg);
  
  std::pair<const char *, uint64_t> getMnemonic(const MCInst *MI) override;

  bool printAliasInstr(const MCInst *MI, uint64_t Address, raw_ostream &OS);

  void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printMemOperand(const MCInst *MI, int OpNum, raw_ostream &O);
};
} // end namespace llvm

#endif