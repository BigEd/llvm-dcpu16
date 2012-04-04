//===-- Dcpu16TargetMachine.cpp - Define TargetMachine for DCPU16 ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Implements the info about DCPU16 target spec.
//
//===----------------------------------------------------------------------===//

#include "Dcpu16TargetMachine.h"
#include "Dcpu16.h"
#include "llvm/PassManager.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"
using namespace llvm;

extern "C" void LLVMInitializeDcpu16Target() {
  // Register the target.
  RegisterTargetMachine<Dcpu16TargetMachine> X(TheDcpu16Target);
}

// DataLayout --> Big-endian, 32-bit pointer/ABI/alignment
// The stack is always 8 byte aligned
// On function prologue, the stack is created by decrementing
// its pointer. Once decremented, all references are done with positive
// offset from the stack/frame pointer, using StackGrowsUp enables
// an easier handling.
Dcpu16TargetMachine::
Dcpu16TargetMachine(const Target &T, StringRef TT,
                    StringRef CPU, StringRef FS, const TargetOptions &Options,
                    Reloc::Model RM, CodeModel::Model CM,
                    CodeGenOpt::Level OL)
  : LLVMTargetMachine(T, TT, CPU, FS, Options, RM, CM, OL),
    Subtarget(TT, CPU, FS),
    DataLayout("E-p:32:32:32-i8:8:8-i16:16:16"),
    InstrInfo(*this),
    FrameLowering(Subtarget),
    TLInfo(*this), TSInfo(*this), ELFWriterInfo(*this),
    InstrItins(Subtarget.getInstrItineraryData()) {
}

namespace {
/// Dcpu16 Code Generator Pass Configuration Options.
class Dcpu16PassConfig : public TargetPassConfig {
public:
  Dcpu16PassConfig(Dcpu16TargetMachine *TM, PassManagerBase &PM)
    : TargetPassConfig(TM, PM) {}

  Dcpu16TargetMachine &getDcpu16TargetMachine() const {
    return getTM<Dcpu16TargetMachine>();
  }

  virtual bool addInstSelector();
  virtual bool addPreEmitPass();
};
} // namespace

TargetPassConfig *Dcpu16TargetMachine::createPassConfig(PassManagerBase &PM) {
  return new Dcpu16PassConfig(this, PM);
}

// Install an instruction selector pass using
// the ISelDag to gen Dcpu16 code.
bool Dcpu16PassConfig::addInstSelector() {
  PM.add(createDcpu16ISelDag(getDcpu16TargetMachine()));
  return false;
}

// Implemented by targets that want to run passes immediately before
// machine code is emitted. return true if -print-machineinstrs should
// print out the code after the passes.
bool Dcpu16PassConfig::addPreEmitPass() {
  PM.add(createDcpu16DelaySlotFillerPass(getDcpu16TargetMachine()));
  return true;
}
