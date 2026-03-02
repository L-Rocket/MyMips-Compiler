#ifndef LLVM_LIB_TARGET_MYMIPS_MCTARGETDESC_MYMIPSMCTARGETDESC_H
#define LLVM_LIB_TARGET_MYMIPS_MCTARGETDESC_MYMIPSMCTARGETDESC_H

#include "llvm/Support/DataTypes.h"
#include "llvm/ADT/StringRef.h" 
#include <memory>

namespace llvm {
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class MCTargetOptions;
class Target;
class Triple; // 前置声明 Triple 类

// 工厂函数声明
MCInstrInfo *createMyMipsMCInstrInfo();
MCRegisterInfo *createMyMipsMCRegisterInfo(const Triple &TT);
MCSubtargetInfo *createMyMipsMCSubtargetInfo(const Triple &TT, StringRef CPU, StringRef FS);

namespace MyMips {
  using namespace llvm; // 让 MyMips 命名空间里能直接看到 llvm::R0
}
} // End llvm namespace


// 定义 TableGen 生成的枚举 (寄存器号, 指令号等)
// 这些必须放在 .h 里，因为其他文件需要用到寄存器枚举值 (如 MyMips::R0)
#define GET_REGINFO_ENUM
#include "MyMipsGenRegisterInfo.inc"


#define GET_INSTRINFO_ENUM
#include "MyMipsGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "MyMipsGenSubtargetInfo.inc"

#endif