#ifndef LLVM_LIB_TARGET_MYMIPS_TARGETINFO_MYMIPSTARGETINFO_H
#define LLVM_LIB_TARGET_MYMIPS_TARGETINFO_MYMIPSTARGETINFO_H

namespace llvm {

class Target;

// 声明获取 Target 单例的函数
Target &getTheMyMipsTarget();

} // namespace llvm

#endif // LLVM_LIB_TARGET_MYMIPS_TARGETINFO_MYMIPSTARGETINFO_H