add_llvm_component_group(MyMips)
set(LLVM_TARGET_DEFINITIONS MyMips.td)

tablegen(LLVM MyMipsGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM MyMipsGenInstrInfo.inc    -gen-instr-info)
tablegen(LLVM MyMipsGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM MyMipsGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM MyMipsGenAsmWriter.inc     -gen-asm-writer)
tablegen(LLVM MyMipsGenDAGISel.inc       -gen-dag-isel)

add_public_tablegen_target(MyMipsCommonTableGen)

add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)

add_llvm_target(MyMipsCodeGen
  MyMipsInstrInfo.cpp
  MyMipsRegisterInfo.cpp
  MyMipsSubtarget.cpp
  MyMipsTargetMachine.cpp
  MyMipsFrameLowering.cpp
  MyMipsISelLowering.cpp
  MyMipsISelDAGToDAG.cpp
  MyMipsAsmPrinter.cpp

  LINK_COMPONENTS
  Analysis
  AsmPrinter
  CodeGen
  Core
  MC
  MyMipsDesc
  MyMipsInfo
  Support
  Target
  TargetParser

  ADD_TO_COMPONENT
  MyMips
)
