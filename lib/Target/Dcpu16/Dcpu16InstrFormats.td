//===-- Dcpu16InstrFormats.td - Dcpu16 Instruction Formats ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

// Format specifies the encoding used by the instruction.  This is part of the
// ad-hoc solution used to emit machine instruction encodings by our machine
// code emitter.
class Format<bits<4> val> {
  bits<4> Value = val;
}

def REG		: Format<0>; // 0x00-0x07: Reg (A, B, C, X, Y, Z, I or J)
def MEMR	: Format<1>; // 0x08-0x0f: [Reg]
def MEMRI	: Format<2>; // 0x10-0x17: [Reg + i16imm]
def POP		: Format<3>; // 0x18: POP / [SP++]
def PEEK	: Format<4>; // 0x19: PEEK / [SP]
def PUSH	: Format<5>; // 0x1a: PUSH / [--SP]
def SPR		: Format<6>; // 0x1b: SP
def PCR		: Format<7>; // 0x1c: PC
def OR		: Format<8>; // 0x1d: O
def MEMI	: Format<9>; // 0x1e: [i16imm]
def IMM16	: Format<10>; // 0x1f: i16imm
def IMM6	: Format<11>; // 0x20-0x3f: i6imm 0x00-0x1f

class Dcpu16Instruction<dag outs, dag ins, string asmstr, list<dag> pattern>: Instruction {
  field bits<16> Inst;

  let Namespace = "DCPU";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString   = asmstr;
  let Pattern = pattern;
}

// Basic instructions
class BI<bits<4> o, Format a, Format b, dag outs, dag ins, string asmstr, list<dag> pattern>
   : Dcpu16Instruction<outs, ins, asmstr, pattern> {
  bits<4> op = o;
  
  Format a = a;
  Format b = b;
}

// Non-basic instructions
class NBI<bits<6> o, Format a, dag outs, dag ins, string asmstr, list<dag> pattern> 
   : Dcpu16Instruction<outs, ins, asmstr, pattern> {
  bits<6> op = o;

  let Inst{3-0} = 0;
  
  Format a = a;
}
