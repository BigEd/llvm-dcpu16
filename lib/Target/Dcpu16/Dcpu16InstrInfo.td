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

// Define Dcpu16 specific addressing mode.
// TODO: not sure with the complex pattern yet, definitly needs some thaughts...
def ADDRr		: ComplexPattern<iPTR, 1, "SelectAddrR", [], []>;
def ADDRi		: ComplexPattern<i16, 1, "SelectAddrI", [], []>;
def ADDRri		: ComplexPattern<i16, 2, "SelectAddrRI", [], []>;

def ADDRpop		: ComplexPattern<i16, 0, "SelectAddrPop", [], []>;
def ADDRpeek	: ComplexPattern<i16, 0, "SelectAddrPeek", [], []>;
def ADDRoush	: ComplexPattern<i16, 0, "SelectAddrPush", [], []>;

// Address operands
def MEMr : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops IntRegs);
}

def MEMi : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops Imm16);
}

def MEMri : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops IntRegs, Imm16);
}

// TODO: How do we build the POP, PEEK, PUSH Address operands? (and fix them in the multiclass)
def MEMpop : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops SPReg);
}

def MEMpeek : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops SPReg);
}

def MEMpush : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops SPReg);
}

//===----------------------------------------------------------------------===//
// Instruction Class Templates
//===----------------------------------------------------------------------===//

// TODO: Fix me

/// BI_ALL multiclass - Defines all possible combinations of operands valid for
/// basic instructions.
multiclass BI_ALL<string OpcStr, bits<4> o, SDNode OpNode> {

// 0x00-0x07: register (A, B, C, X, Y, Z, I or J, in that order)
  def irir  : BI<o, DCPU:IR, DCPU:IR,  
                 (outs IntRegs:$a), (ins IntRegs:$a, ins IntRegs:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, IntRegs:$b))]>;
  def irmr  : BI<o, DCPU:IR, DCPU:MR, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMr:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRr:$b))]>;
  def irmnwr : BI<o, DCPU:IR, DCPU:MNWR, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMri:$b),
                 !strconcat(OpcStr, " $a, [NW+$b]"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRri:$b))]>;
  def irpop : BI<o, DCPU:IR, DCPU:POP,
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, POP"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpop:$b))]>;
  def irpeek  : BI<o, DCPU:IR, DCPU:PEEK,
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, PEEK"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpeek:b))]>;
  def irpush  : BI<o, DCPU:IR, DCPU:PUSH, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, PUSH"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpush:b))]>;
  def irsp  : BI<o, DCPU:IR, DCPU:SP, 
                 (outs IntRegs:$a), (ins IntRegs:$a, SPReg:$b),
                 !strconcat(OpcStr, " $a, SP"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, SPReg:$b))]>;
  def irpc  : BI<o, DCPU:IR, DCPU:PC, 
                 (outs IntRegs:$a), (ins IntRegs:$a, PCReg:$b),
                 !strconcat(OpcStr, " $a, PC"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, PCReg:$b))]>;
  def iro   : BI<o, DCPU:IR, DCPU:O, 
                 (outs IntRegs:$a), (ins IntRegs:$a, OReg:$b),
                 !strconcat(OpcStr, " $a, O"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, OReg:$b))]>;
  def irmnw  : BI<o, DCPU:IR, DCPU:MNW, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMi:$b),
                 !strconcat(OpcStr, " $a, [$b]),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRi:$b))]>;
  def irinw  : BI<o, DCPU:IR, DCPU:INW, 
                 (outs IntRegs:$a), (ins IntRegs:$a, Imm16:$b),
                 !strconcat(OpcStr, " $a, $b),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, Imm16:$b))]>;
  def irlit  : BI<o, DCPU:IR, DCPU:LIT, 
                 (outs IntRegs:$a), (ins IntRegs:$a, Imm6:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, Imm6:$b))]>;                 

// 0x08-0x0f: [register]
  def mrir  : BI<o, DCPU:MR, DCPU:IR,  
                 (outs MEMr:$a), (ins MEMr:$a, ins IntRegs:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, IntRegs:$b))]>;
  def mrmr  : BI<o, DCPU:MR, DCPU:MR, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMr:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRr:$b))]>;
  def mrmnwr : BI<o, DCPU:MR, DCPU:MNWR, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMri:$b),
                 !strconcat(OpcStr, " [$a], [NW+$b]"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRri:$b))]>;
  def mrpop : BI<o, DCPU:MR, DCPU:POP,
                 (outs MEMr:$a), (ins MEMr:$a, MEMpop:$b),
                 !strconcat(OpcStr, " [$a], POP"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpop:$b))]>;
  def mrpeek  : BI<o, DCPU:MR, DCPU:PEEK,
                 (outs MEMr:$a), (ins MEMr:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " [$a], PEEK"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpeek:$b))]>;
  def mrpush  : BI<o, DCPU:MR, DCPU:PUSH, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMpush:$b),
                 !strconcat(OpcStr, " [$a], PUSH"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpush:$b))]>;
  def mrsp  : BI<o, DCPU:MR, DCPU:SP, 
                 (outs MEMr:$a), (ins MEMr:$a, SPReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, SPReg:$b))]>;
  def mrpc  : BI<o, DCPU:MR, DCPU:PC, 
                 (outs MEMr:$a), (ins MEMr:$a, PCReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, PCReg:$b))]>;
  def mro   : BI<o, DCPU:MR, DCPU:O, 
                 (outs MEMr:$a), (ins MEMr:$a, OReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, OReg:$b))]>;
  def mrmnw  : BI<o, DCPU:MR, DCPU:MNW, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMi:$b),
                 !strconcat(OpcStr, " [$a], [$b]),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRi:$b))]>;
  def mrinw  : BI<o, DCPU:MR, DCPU:INW, 
                 (outs MEMr:$a), (ins MEMr:$a, Imm16:$b),
                 !strconcat(OpcStr, " [$a], $b),
                 [(set MEMr:$a, (OpNode ADDRr:$a, Imm16:$b))]>;
  def mrlit  : BI<o, DCPU:MR, DCPU:LIT, 
                 (outs MEMr:$a), (ins MEMr:$a, Imm6:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, Imm6:$b))]>;                                  

// 0x10-0x17: [next word + register]
  def mnwrir  : BI<o, DCPU:MNWR, DCPU:IR,  
                 (outs MEMri:$a), (ins MEMri:$a, ins IntRegs:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, IntRegs:$b))]>;
  def mnwrmr  : BI<o, DCPU:MNWR, DCPU:MR, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMr:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRr:$b))]>;
  def mnwrmnwr : BI<o, DCPU:MNWR, DCPU:MNWR, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMri:$b),
                 !strconcat(OpcStr, " [$a], [NW+$b]"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRri:$b))]>;
  def mnwrpop : BI<o, DCPU:MNWR, DCPU:POP,
                 (outs MEMri:$a), (ins MEMri:$a, MEMpop:$b),
                 !strconcat(OpcStr, " [$a], POP"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpop:$b))]>;
  def mnwrpeek  : BI<o, DCPU:MNWR, DCPU:PEEK,
                 (outs MEMri:$a), (ins MEMri:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " [$a], PEEK"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpeek:$b))]>;
  def mnwrpush  : BI<o, DCPU:MNWR, DCPU:PUSH, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMpush:$b),
                 !strconcat(OpcStr, " [$a], PUSH"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpush:$b))]>;
  def mnwrsp  : BI<o, DCPU:MNWR, DCPU:SP, 
                 (outs MEMri:$a), (ins MEMri:$a, SPReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, SPReg:$b))]>;
  def mnwrpc  : BI<o, DCPU:MNWR, DCPU:PC, 
                 (outs MEMri:$a), (ins MEMri:$a, PCReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, PCReg:$b))]>;
  def mnwro   : BI<o, DCPU:MNWR, DCPU:O, 
                 (outs MEMri:$a), (ins MEMri:$a, OReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, OReg:$b))]>;
  def mnwrmnw  : BI<o, DCPU:MNWR, DCPU:MNW, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMi:$b),
                 !strconcat(OpcStr, " [$a], [$b]),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRi:$b))]>;
  def mnwrinw  : BI<o, DCPU:MNWR, DCPU:INW, 
                 (outs MEMri:$a), (ins MEMri:$a, Imm16:$b),
                 !strconcat(OpcStr, " [$a], $b),
                 [(set MEMri:$a, (OpNode ADDRri:$a, Imm16:$b))]>;
  def mnwrlit  : BI<o, DCPU:MNWR, DCPU:LIT, 
                 (outs MEMri:$a), (ins MEMri:$a, Imm6:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, Imm6:$b))]>;                                  

// TODO fix me! Use values from above!

// 0x18: POP / [SP++]
  def popir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def popmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def popmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def poppop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def poppeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def poppush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def popsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def poppc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def popo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def popmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def popinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def poplit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 

// 0x19: PEEK / [SP]
  def peekir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peekmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peekmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peekpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peekpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peekpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peeksp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peekpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peeko   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peekmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peekinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def peeklit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 

// 0x1a: PUSH / [--SP]
  def pushir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pusho   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pushlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 

// 0x1b: SP
  def sphir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def spmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def spmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def sppop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def sppeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def sppush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def spsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def sppc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def spo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def spmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def spinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def split  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 

// 0x1c: PC
  def pcir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pco   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pcinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def pclit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 

// 0x1d: O
  def oir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def omr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def omnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def opop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def opeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def opush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def osp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def opc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def oo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def omnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def oinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def olit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 

// 0x1e: [next word]
  def mnwir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def mnwlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 

// 0x1f: next word (literal)
  def inwir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwo   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def inwlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 

// 0x20-0x3f: literal value 0x00-0x1f (literal)
  def litir  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litmr  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litmnwr : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litpop : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litpeek  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litpush  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litsp  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litpc  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def lito   : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litmnw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litinw  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;
  def litlit  : BI<o, a, b, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;                 
}

/// NBI_ALL multiclass - Defines all possible combinations of operands valid for
/// non basic instructions.
multiclass NBI_ALL<string OpcStr, bits<6> o, SDNode OpNode> {

// 0x00-0x07: register (A, B, C, X, Y, Z, I or J, in that order)
  def ir  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x08-0x0f: [register]
  def mr  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x10-0x17: [next word + register]
  def mnwr : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x18: POP / [SP++]
  def pop : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x19: PEEK / [SP]
  def peek  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1a: PUSH / [--SP]
  def push  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1b: SP
  def sp  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1c: PC
  def pc  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1d: O
  def o   : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1e: [next word]
  def mnw  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1f: next word (literal)
  def inw  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x20-0x3f: literal value 0x00-0x1f (literal)
  def lit  : NBI<o, a, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;  
}


//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

// TODO: Add me!
