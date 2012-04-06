//===-- Dcpu16InstrFormats.td - Dcpu16 Instruction Formats ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

// Basic opcodes
classInstDCPU<dag outs, dag ins, string asmstr, list<dag> pattern> : InstB {
  field bits<16> Inst;

  let Namespace = "DCPU";

  bits<4> o;
  bits<6> a;
  bits<6> b;
  
  let Inst{3-0} = o;
  let Inst{9-4} = a;
  let Inst{15-10} = b;

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString   = asmstr;
  let Pattern = pattern;
}

// Non-basic opcodes
classInstDCPU<dag outs, dag ins, string asmstr, list<dag> pattern> : InstNB {
  field bits<16> Inst;

  let Namespace = "DCPU";
  
  bits<4> op = 0;
  bits<8> o;
  bits<6> a;
  
  let Inst{3-0} = op;
  let Inst{10-4} = o;
  let Inst{15-10} = a;

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString   = asmstr;
  let Pattern = pattern;
}

