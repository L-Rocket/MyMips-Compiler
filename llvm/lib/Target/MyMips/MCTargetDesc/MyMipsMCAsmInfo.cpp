#include "MyMipsMCAsmInfo.h"

// ❌ 旧版本写法:
// #include "llvm/ADT/Triple.h"

// ✅ LLVM 18 正确写法:
#include "llvm/TargetParser/Triple.h"

using namespace llvm;

void MyMipsMCAsmInfo::anchor() {}
// ... (后面代码保持不变)

MyMipsMCAsmInfo::MyMipsMCAsmInfo(const Triple &TheTriple) {
  // 设置指针大小 (MIPS32)
  CodePointerSize = 4;
  CalleeSaveStackSlotSize = 4;

  // 设置注释符号
  CommentString = "#";
  
  // 设置指令对齐
  MinInstAlignment = 4;

  // 支持调试信息
  SupportsDebugInformation = true;
  ExceptionsType = ExceptionHandling::DwarfCFI;
  
  UseIntegratedAssembler = false;
}