//===-- Dcpu16InstrInfo.td - Target Description for Dcpu16 Target -----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the Dcpu16 instructions in TableGen format.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction format superclass
//===----------------------------------------------------------------------===//

include "Dcpu16InstrFormats.td"

//===----------------------------------------------------------------------===//
// Instruction Pattern Stuff
//===----------------------------------------------------------------------===//

// TODO: Add all Dcpu16 adress computations

// Addressing modes.
def ADDRrr : ComplexPattern<i32, 2, "SelectADDRrr", [], []>;
def ADDRri : ComplexPattern<i32, 2, "SelectADDRri", [frameindex], []>;

// Address operands
def MEMrr : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops IntRegs, IntRegs);
}
def MEMri : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops IntRegs, i16imm);
}


//===----------------------------------------------------------------------===//
// Instruction Class Templates
//===----------------------------------------------------------------------===//

// TODO: Fix me

/// BI_ALL multiclass - Defines all possible combinations of operands valid for
/// basic instructions.
multiclass BI_ALL<string OpcStr, bits<4> o, SDNode OpNode> {

// 0x00-0x07: register (A, B, C, X, Y, Z, I or J, in that order)
  def irir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def rmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def iro   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def irlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x08-0x0f: [register]
  def mrir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mro   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mrlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x10-0x17: [next word + register]
  def mnwrir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwro   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwrlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x18: POP / [SP++]
  def popir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def popmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def popmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def poppop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def poppeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def poppush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def popsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def poppc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def popo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def popmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def popinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def poplit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x19: PEEK / [SP]
  def peekir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peekmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peekmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peekpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peekpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peekpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peeksp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peekpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peeko   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peekmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peekinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def peeklit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x1a: PUSH / [--SP]
  def pushir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pusho   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pushlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x1b: SP
  def sphir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def spmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def spmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def sppop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def sppeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def sppush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def spsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def sppc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def spo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def spmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def spinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def split  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x1c: PC
  def pcir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pco   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pcinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def pclit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x1d: O
  def oir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def omr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def omnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def opop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def opeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def opush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def osp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def opc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def oo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def omnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def oinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def olit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x1e: [next word]
  def mnwir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def mnwlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x1f: next word (literal)
  def inwir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def inwlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 

// 0x20-0x3f: literal value 0x00-0x1f (literal)
  def litir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def lito   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;
  def litlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;                 
}

/// NBI_ALL multiclass - Defines all possible combinations of operands valid for
/// non basic instructions.
multiclass NBI_ALL<string OpcStr, bits<6> o, SDNode OpNode> {

// 0x00-0x07: register (A, B, C, X, Y, Z, I or J, in that order)
  def ir  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x08-0x0f: [register]
  def mr  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x10-0x17: [next word + register]
  def mnwr : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x18: POP / [SP++]
  def pop : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x19: PEEK / [SP]
  def peek  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x1a: PUSH / [--SP]
  def push  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x1b: SP
  def sp  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x1c: PC
  def pc  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x1d: O
  def o   : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x1e: [next word]
  def mnw  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x1f: next word (literal)
  def inw  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;

// 0x20-0x3f: literal value 0x00-0x1f (literal)
  def lit  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [(set IntRegs:$dst, (OpNode IntRegs:$b, IntRegs:$c))]>;  
}


//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

// TODO: Add me!
