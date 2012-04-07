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

/// BI_ALL multiclass - Defines all possible combinations of operands valid for
/// basic instructions.
multiclass BI_ALL<string OpcStr, bits<4> o, SDNode OpNode> {

// 0x00-0x07: Reg (A, B, C, X, Y, Z, I or J)
  def rr : BI<o, DCPU:Reg, DCPU:Reg,  
                 (outs IntRegs:$a), (ins IntRegs:$a, ins IntRegs:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, IntRegs:$b))]>;
  def rmemr : BI<o, DCPU:IR, DCPU:MR, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMr:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRr:$b))]>;
  def rmemri : BI<o, DCPU:Reg, DCPU:MEMri, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMri:$b),
                 !strconcat(OpcStr, " $a, [NW+$b]"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRri:$b))]>;
  def rpop : BI<o, DCPU:Reg, DCPU:POP,
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, POP"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpop:$b))]>;
  def rpeek  : BI<o, DCPU:Reg, DCPU:PEEK,
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, PEEK"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpeek:b))]>;
  def rpush  : BI<o, DCPU:Reg, DCPU:PUSH, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, PUSH"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpush:b))]>;
  def rsp  : BI<o, DCPU:Reg, DCPU:SP, 
                 (outs IntRegs:$a), (ins IntRegs:$a, SPReg:$b),
                 !strconcat(OpcStr, " $a, SP"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, SPReg:$b))]>;
  def rpc  : BI<o, DCPU:Reg, DCPU:PC, 
                 (outs IntRegs:$a), (ins IntRegs:$a, PCReg:$b),
                 !strconcat(OpcStr, " $a, PC"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, PCReg:$b))]>;
  def ro   : BI<o, DCPU:Reg, DCPU:O, 
                 (outs IntRegs:$a), (ins IntRegs:$a, OReg:$b),
                 !strconcat(OpcStr, " $a, O"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, OReg:$b))]>;
  def rmemi  : BI<o, DCPU:Reg, DCPU:MEMi, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMi:$b),
                 !strconcat(OpcStr, " $a, [$b]),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRi:$b))]>;
  def rimm16  : BI<o, DCPU:Reg, DCPU:Imm16, 
                 (outs IntRegs:$a), (ins IntRegs:$a, Imm16:$b),
                 !strconcat(OpcStr, " $a, $b),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, Imm16:$b))]>;
  def rimm6  : BI<o, DCPU:Reg, DCPU:Imm6, 
                 (outs IntRegs:$a), (ins IntRegs:$a, Imm6:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, Imm6:$b))]>;                 

// 0x08-0x0f: [Reg]
  def memrreg : BI<o, DCPU:MEMr, DCPU:Reg,  
                 (outs MEMr:$a), (ins MEMr:$a, ins IntRegs:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, IntRegs:$b))]>;
  def memrmemr : BI<o, DCPU:MEMr, DCPU:MEMr, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMr:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRr:$b))]>;
  def memrmemri : BI<o, DCPU:MEMr, DCPU:MEMri, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMri:$b),
                 !strconcat(OpcStr, " [$a], [NW+$b]"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRri:$b))]>;
  def memrpop : BI<o, DCPU:MEMr, DCPU:POP,
                 (outs MEMr:$a), (ins MEMr:$a, MEMpop:$b),
                 !strconcat(OpcStr, " [$a], POP"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpop:$b))]>;
  def memrpeek  : BI<o, DCPU:MEMr, DCPU:PEEK,
                 (outs MEMr:$a), (ins MEMr:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " [$a], PEEK"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpeek:$b))]>;
  def memrpush  : BI<o, DCPU:MEMr, DCPU:PUSH, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMpush:$b),
                 !strconcat(OpcStr, " [$a], PUSH"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpush:$b))]>;
  def memrsp  : BI<o, DCPU:MEMr, DCPU:SP, 
                 (outs MEMr:$a), (ins MEMr:$a, SPReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, SPReg:$b))]>;
  def memrpc  : BI<o, DCPU:MEMr, DCPU:PC, 
                 (outs MEMr:$a), (ins MEMr:$a, PCReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, PCReg:$b))]>;
  def memro   : BI<o, DCPU:MEMr, DCPU:O, 
                 (outs MEMr:$a), (ins MEMr:$a, OReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, OReg:$b))]>;
  def memrmemi  : BI<o, DCPU:MEMr, DCPU:MEMi, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMi:$b),
                 !strconcat(OpcStr, " [$a], [$b]),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRi:$b))]>;
  def memrimm16  : BI<o, DCPU:MEMr, DCPU:Imm16, 
                 (outs MEMr:$a), (ins MEMr:$a, Imm16:$b),
                 !strconcat(OpcStr, " [$a], $b),
                 [(set MEMr:$a, (OpNode ADDRr:$a, Imm16:$b))]>;
  def memrlimm6  : BI<o, DCPU:MEMr, DCPU:Imm6, 
                 (outs MEMr:$a), (ins MEMr:$a, Imm6:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, Imm6:$b))]>;                                  

// 0x10-0x17: [Reg+Imm16]
  def memrireg : BI<o, DCPU:MEMri, DCPU:Reg,  
                 (outs MEMri:$a), (ins MEMri:$a, ins IntRegs:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, IntRegs:$b))]>;
  def memrimemr : BI<o, DCPU:MEMri, DCPU:MEMr, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMr:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRr:$b))]>;
  def memrimemri : BI<o, DCPU:MEMri, DCPU:MEMri, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMri:$b),
                 !strconcat(OpcStr, " [$a], [NW+$b]"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRri:$b))]>;
  def memripop : BI<o, DCPU:MEMri, DCPU:POP,
                 (outs MEMri:$a), (ins MEMri:$a, MEMpop:$b),
                 !strconcat(OpcStr, " [$a], POP"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpop:$b))]>;
  def memripeek  : BI<o, DCPU:MEMri, DCPU:PEEK,
                 (outs MEMri:$a), (ins MEMri:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " [$a], PEEK"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpeek:$b))]>;
  def memripush  : BI<o, DCPU:MEMri, DCPU:PUSH, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMpush:$b),
                 !strconcat(OpcStr, " [$a], PUSH"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpush:$b))]>;
  def memrisp  : BI<o, DCPU:MEMri, DCPU:SP, 
                 (outs MEMri:$a), (ins MEMri:$a, SPReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, SPReg:$b))]>;
  def memripc  : BI<o, DCPU:MEMri, DCPU:PC, 
                 (outs MEMri:$a), (ins MEMri:$a, PCReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, PCReg:$b))]>;
  def memrio   : BI<o, DCPU:MEMri, DCPU:O, 
                 (outs MEMri:$a), (ins MEMri:$a, OReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, OReg:$b))]>;
  def memrimemi : BI<o, DCPU:MEMri, DCPU:MEMi, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMi:$b),
                 !strconcat(OpcStr, " [$a], [$b]),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRi:$b))]>;
  def memriimm16 : BI<o, DCPU:MEMri, DCPU:Imm16, 
                 (outs MEMri:$a), (ins MEMri:$a, Imm16:$b),
                 !strconcat(OpcStr, " [$a], $b),
                 [(set MEMri:$a, (OpNode ADDRri:$a, Imm16:$b))]>;
  def memriimm6 : BI<o, DCPU:MEMri, DCPU:Imm6, 
                 (outs MEMri:$a), (ins MEMri:$a, Imm6:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, Imm6:$b))]>;                                  

// TODO fix me! Use values from above!

// 0x18: POP / [SP++]               

// 0x19: PEEK / [SP]

// 0x1a: PUSH / [--SP]

// 0x1b: SP

// 0x1c: PC

// 0x1d: O

// 0x1e: [Imm6]

// 0x1f: Imm16

// 0x20-0x3f: Imm6 0x00-0x1f
                 
}

/// NBI_ALL multiclass - Defines all possible combinations of operands valid for
/// non basic instructions.
multiclass NBI_ALL<string OpcStr, bits<6> o, SDNode OpNode> {

// 0x00-0x07: Reg (A, B, C, X, Y, Z, I or J)
  def reg  : NBI<o, DCPU:Reg, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x08-0x0f: [Reg]
  def memr  : NBI<o, DCPU:MEMr, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x10-0x17: [Reg+Imm16]
  def memri : NBI<o, DCPU:MEMri, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x18: POP / [SP++]
  def pop : NBI<o, DCPU:POP, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x19: PEEK / [SP]
  def peek  : NBI<o, DCPU:PEEK, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1a: PUSH / [--SP]
  def push  : NBI<o, DCPU:PUSH, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1b: SP
  def sp  : NBI<o, DCPU:SP, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1c: PC
  def pc  : NBI<o, DCPU:PC, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1d: O
  def o   : NBI<o, DCPU:O, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1e: [Imm16]
  def memi : NBI<o, DCPU:MEMi, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x1f: Imm16
  def imm16  : NBI<o, DCPU:Imm16, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;

// 0x20-0x3f: Imm6 0x00-0x1f
  def imm6  : NBI<o, DCPU:Imm6, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 [()]>;  
}


//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

// TODO: Add me!
