//===-- Dcpu16RegisterInfo.cpp - Dcpu16 Register Information ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the Dcpu16 implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "Dcpu16RegisterInfo.h"
#include "llvm/Type.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Target/TargetInstrInfo.h"

#define GET_REGINFO_TARGET_DESC
#include "Dcpu16GenRegisterInfo.inc"

using namespace llvm;

// TODO: What does the SP:J does there?
Dcpu16RegisterInfo::Dcpu16RegisterInfo(const TargetInstrInfo &tii)
  : Dcpu16GenRegisterInfo(SP::J), TII(tii) {
}

const uint16_t* Dcpu16RegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  static const uint16_t CalleeSavedRegs[] = { 0 };
  return CalleeSavedRegs;
}

unsigned Dcpu16RegisterInfo::getEHExceptionRegister() const {
  llvm_unreachable("What is the exception register");
}

unsigned Dcpu16RegisterInfo::getEHHandlerRegister() const {
  llvm_unreachable("What is the exception handler register");
}
