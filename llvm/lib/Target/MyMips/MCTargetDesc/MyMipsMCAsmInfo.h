#ifndef LLVM_LIB_TARGET_MYMIPS_MCTARGETDESC_MYMIPSMCASMINFO_H
#define LLVM_LIB_TARGET_MYMIPS_MCTARGETDESC_MYMIPSMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {
class Triple;

class MyMipsMCAsmInfo : public MCAsmInfoELF {
  void anchor() override;

public:
  explicit MyMipsMCAsmInfo(const Triple &TheTriple);
};

} // namespace llvm

#endif