# 确保包含父级目录的源码和构建产物
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/..
  ${CMAKE_CURRENT_BINARY_DIR}/..
)

add_llvm_component_library(LLVMMyMipsDesc
  MyMipsMCTargetDesc.cpp
  MyMipsInstPrinter.cpp
  MyMipsMCAsmInfo.cpp

  LINK_COMPONENTS
  MC
  Support
  MyMipsInfo

  ADD_TO_COMPONENT
  MyMips
)