add_llvm_component_library(LLVMMyMipsInfo
  MyMipsTargetInfo.cpp
  LINK_COMPONENTS
  MC
  Support
  ADD_TO_COMPONENT
  MyMips
)
