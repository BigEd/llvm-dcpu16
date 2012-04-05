set(LLVM_TARGET_DEFINITIONS Dcpu16.td)

tablegen(LLVM Dcpu16GenRegisterInfo.inc -gen-register-info)
tablegen(LLVM Dcpu16GenInstrInfo.inc -gen-instr-info)
tablegen(LLVM Dcpu16GenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM Dcpu16GenDAGISel.inc -gen-dag-isel)
tablegen(LLVM Dcpu16GenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM Dcpu16GenCallingConv.inc -gen-callingconv)
add_public_tablegen_target(Dcpu16CommonTableGen)

add_llvm_target(Dcpu16CodeGen
  Dcpu16AsmPrinter.cpp
  Dcpu16InstrInfo.cpp
  Dcpu16ISelDAGToDAG.cpp
  Dcpu16ISelLowering.cpp
  Dcpu16FrameLowering.cpp
  Dcpu16MachineFunctionInfo.cpp
  Dcpu16RegisterInfo.cpp
  Dcpu16Subtarget.cpp
  Dcpu16TargetMachine.cpp
  Dcpu16SelectionDAGInfo.cpp
  )

add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)
