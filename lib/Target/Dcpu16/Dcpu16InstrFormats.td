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

// TODO Question: Is the [next word] = [imm16] ? 
def IR		: Format<0>; // 0x00-0x07: register (A, B, C, X, Y, Z, I or J, in that order)
def MR		: Format<1>; // 0x08-0x0f: [register]
def MNWR	: Format<2>; // 0x10-0x17: [next word + register]
def POP		: Format<3>; // 0x18: POP / [SP++]
def PEEK	: Format<4>; // 0x19: PEEK / [SP]
def PUSH	: Format<5>; // 0x1a: PUSH / [--SP]
def SP		: Format<6>; // 0x1b: SP
def PC		: Format<7>; // 0x1c: PC
def O		: Format<8>; // 0x1d: O
def MNW		: Format<9>; // 0x1e: [next word]
def INW		: Format<10>; // 0x1f: next word (literal)
def LIT		: Format<11>; // 0x20-0x3f: literal value 0x00-0x1f (literal)

class Instruction<dag outs, dag ins, string asmstr, list<dag> pattern> {
  field bits<16> Inst;

  let Namespace = "DCPU";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString   = asmstr;
  let Pattern = pattern;
}

// Basic instructions
class BI<bits<4> o, Format a, Format b, dag outs, dag ins, string asmstr, list<dag> pattern>: 
   : Instruction<outs, ins, asmstr, pattern> {
  let Inst{3-0} = o;
  
  Format a = a;
  Format b = b;
}

// Non-basic instructions
class NBI<bits<6> o, Format a, dag outs, dag ins, string asmstr, list<dag> pattern> 
   : Instruction<outs, ins, asmstr, pattern> {
  bits<4> op = 0;
  
  let Inst{3-0} = op;
  let Inst{10-4} = o;
  
  Format a = a;
}
