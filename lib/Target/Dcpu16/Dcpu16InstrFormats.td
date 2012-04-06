//===-- Dcpu16InstrFormats.td - Dcpu16 Instruction Formats ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//


class Instruction<dag outs, dag ins, string asmstr, list<dag> pattern> {
  field bits<16> Inst;

  let Namespace = "DCPU";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString   = asmstr;
  let Pattern = pattern;
}

// Basic instructions
class BI<bits<4> o, bits<6> a, bits<6> b, dag outs, dag ins, string asmstr, list<dag> pattern>: 
   : Instruction<outs, ins, asmstr, pattern> {
  let Inst{3-0} = o;
  let Inst{10-4} = a;
  let Inst{15-10} = b;
}

// Non-basic instructions
class NBI<bits<6> o, bits<6> a, dag outs, dag ins, string asmstr, list<dag> pattern> 
   : Instruction<outs, ins, asmstr, pattern> {
  bits<4> op = 0;
  
  let Inst{3-0} = op;
  let Inst{10-4} = o;
  let Inst{15-10} = a;
}
