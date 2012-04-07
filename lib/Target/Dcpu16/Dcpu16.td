//===-- Dcpu16.td - Describe the Dcpu16 Target Machine -------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Target-independent interfaces which we are implementing
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Register File, Calling Conv, Instruction Descriptions
//===----------------------------------------------------------------------===//

include "Dcpu16RegisterInfo.td"
//include "Dcpu16CallingConv.td"
include "Dcpu16InstrInfo.td"

def Dcpu16InstrInfo : InstrInfo;

//===----------------------------------------------------------------------===//
// Dcpu16 processors supported.
//===----------------------------------------------------------------------===//

class Proc<string Name, list<SubtargetFeature> Features>
 : Processor<Name, NoItineraries, Features>;

def : Proc<"generic", []>;

//===----------------------------------------------------------------------===//
// Declare the target which we are implementing
//===----------------------------------------------------------------------===//

def Dcpu16 : Target {
  // Pull in Instruction Info:
  let InstructionSet = Dcpu16InstrInfo;
}
