include_directories( ${CMAKE_CURRENT_BINARY_DIR}/.. ${CMAKE_CURRENT_SOURCE_DIR}/.. )

add_llvm_library(LLVMSparcInfo
  Dcpu16TargetInfo.cpp
  )

add_dependencies(LLVMSparcInfo Dcpu16CommonTableGen)
