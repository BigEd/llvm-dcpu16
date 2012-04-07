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
def ADDRpush	: ComplexPattern<i16, 0, "SelectAddrPush", [], []>;

// Address operands
def MEMr : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops IntRegs);
}

def MEMi : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops i16imm);
}

def MEMri : Operand<i16> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops IntRegs, i16imm);
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
/// TODO: If we are unlucky, we can only use registeres here!
///		  if this should be true, we need to write an extra pass
///		  to merge not needed SET/ADD etc.
multiclass BI_ALL<string OpcStr, bits<4> o, SDNode OpNode> {

// 0x00-0x07: Reg (A, B, C, X, Y, Z, I or J)
  def rr : BI<o, REG, REG,  
                 (outs IntRegs:$a), (ins IntRegs:$a, IntRegs:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, IntRegs:$b))]>;
  def rmemr : BI<o, REG, MEMRI, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMr:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRr:$b))]>;
  def rmemri : BI<o, REG, MEMRI, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMri:$b),
                 !strconcat(OpcStr, " $a, [NW+$b]"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRri:$b))]>;
  def rpop : BI<o, REG, POP,
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, POP"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpop:$b))]>;
  def rpeek  : BI<o, REG, PEEK,
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, PEEK"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpeek:$b))]>;
  def rpush  : BI<o, REG, PUSH, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, PUSH"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRpush:$b))]>;
  def rsp  : BI<o, REG, SPR, 
                 (outs IntRegs:$a), (ins IntRegs:$a, SPReg:$b),
                 !strconcat(OpcStr, " $a, SP"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, SPReg:$b))]>;
  def rpc  : BI<o, REG, PCR, 
                 (outs IntRegs:$a), (ins IntRegs:$a, PCReg:$b),
                 !strconcat(OpcStr, " $a, PC"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, PCReg:$b))]>;
  def ro   : BI<o, REG, OR, 
                 (outs IntRegs:$a), (ins IntRegs:$a, OReg:$b),
                 !strconcat(OpcStr, " $a, O"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, OReg:$b))]>;
  def rmemi  : BI<o, REG, MEMI, 
                 (outs IntRegs:$a), (ins IntRegs:$a, MEMi:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, ADDRi:$b))]>;
  def rimm16  : BI<o, REG, IMM16, 
                 (outs IntRegs:$a), (ins IntRegs:$a, i16imm:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set IntRegs:$a, (OpNode IntRegs:$a, i16imm:$b))]>;
//  def rimm6  : BI<o, REG, IMM6, 
//                 (outs IntRegs:$a), (ins IntRegs:$a, i6imm:$b),
//                 !strconcat(OpcStr, " $a, $b"),
//                 [(set IntRegs:$a, (OpNode IntRegs:$a, i6imm:$b))]>;                 

// 0x08-0x0f: [Reg]
  def memrreg : BI<o, MEMR, REG,  
                 (outs MEMr:$a), (ins MEMr:$a, IntRegs:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, IntRegs:$b))]>;
  def memrmemr : BI<o, MEMR, MEMR, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMr:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRr:$b))]>;
  def memrmemri : BI<o, MEMR, MEMRI, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMri:$b),
                 !strconcat(OpcStr, " [$a], [NW+$b]"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRri:$b))]>;
  def memrpop : BI<o, MEMR, POP,
                 (outs MEMr:$a), (ins MEMr:$a, MEMpop:$b),
                 !strconcat(OpcStr, " [$a], POP"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpop:$b))]>;
  def memrpeek  : BI<o, MEMR, PEEK,
                 (outs MEMr:$a), (ins MEMr:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " [$a], PEEK"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpeek:$b))]>;
  def memrpush  : BI<o, MEMR, PUSH, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMpush:$b),
                 !strconcat(OpcStr, " [$a], PUSH"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRpush:$b))]>;
  def memrsp  : BI<o, MEMR, SPR, 
                 (outs MEMr:$a), (ins MEMr:$a, SPReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, SPReg:$b))]>;
  def memrpc  : BI<o, MEMR, PCR, 
                 (outs MEMr:$a), (ins MEMr:$a, PCReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, PCReg:$b))]>;
  def memro   : BI<o, MEMR, OR, 
                 (outs MEMr:$a), (ins MEMr:$a, OReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, OReg:$b))]>;
  def memrmemi  : BI<o, MEMR, MEMI, 
                 (outs MEMr:$a), (ins MEMr:$a, MEMi:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, ADDRi:$b))]>;
  def memrimm16  : BI<o, MEMR, IMM16, 
                 (outs MEMr:$a), (ins MEMr:$a, i16imm:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMr:$a, (OpNode ADDRr:$a, i16imm:$b))]>;
//  def memrlimm6  : BI<o, MEMR, IMM6, 
//                (outs MEMr:$a), (ins MEMr:$a, i6imm:$b),
//                 !strconcat(OpcStr, " [$a], $b"),
//                 [(set MEMr:$a, (OpNode ADDRr:$a, i6imm:$b))]>;                                  

// 0x10-0x17: [Reg+i16imm]
  def memrireg : BI<o, MEMRI, REG,  
                 (outs MEMri:$a), (ins MEMri:$a, IntRegs:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, IntRegs:$b))]>;
  def memrimemr : BI<o, MEMRI, MEMR, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMr:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRr:$b))]>;
  def memrimemri : BI<o, MEMRI, MEMRI, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMri:$b),
                 !strconcat(OpcStr, " [$a], [NW+$b]"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRri:$b))]>;
  def memripop : BI<o, MEMRI, POP,
                 (outs MEMri:$a), (ins MEMri:$a, MEMpop:$b),
                 !strconcat(OpcStr, " [$a], POP"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpop:$b))]>;
  def memripeek  : BI<o, MEMRI, PEEK,
                 (outs MEMri:$a), (ins MEMri:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " [$a], PEEK"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpeek:$b))]>;
  def memripush  : BI<o, MEMRI, PUSH, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMpush:$b),
                 !strconcat(OpcStr, " [$a], PUSH"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRpush:$b))]>;
  def memrisp  : BI<o, MEMRI, SPR, 
                 (outs MEMri:$a), (ins MEMri:$a, SPReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, SPReg:$b))]>;
  def memripc  : BI<o, MEMRI, PCR, 
                 (outs MEMri:$a), (ins MEMri:$a, PCReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, PCReg:$b))]>;
  def memrio   : BI<o, MEMRI, OR, 
                 (outs MEMri:$a), (ins MEMri:$a, OReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, OReg:$b))]>;
  def memrimemi : BI<o, MEMRI, MEMI, 
                 (outs MEMri:$a), (ins MEMri:$a, MEMi:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, ADDRi:$b))]>;
  def memriimm16 : BI<o, MEMRI, IMM16, 
                 (outs MEMri:$a), (ins MEMri:$a, i16imm:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMri:$a, (OpNode ADDRri:$a, i16imm:$b))]>;
//  def memriimm6 : BI<o, MEMRI, IMM6, 
//                 (outs MEMri:$a), (ins MEMri:$a, i6imm:$b),
//                 !strconcat(OpcStr, " [$a], $b"),
//                 [(set MEMri:$a, (OpNode ADDRri:$a, i6imm:$b))]>;                                  

// 0x18: POP / [SP++]            
  def popreg : BI<o, POP, REG,  
                 (outs MEMpop:$a), (ins MEMpop:$a, IntRegs:$b),
                 !strconcat(OpcStr, " POP, $b"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, IntRegs:$b))]>;
  def popmemr : BI<o, POP, MEMR, 
                 (outs MEMpop:$a), (ins MEMpop:$a, MEMr:$b),
                 !strconcat(OpcStr, " POP, [$b]"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, ADDRr:$b))]>;
  def popmemri : BI<o, POP, POP, 
                 (outs MEMpop:$a), (ins MEMpop:$a, MEMri:$b),
                 !strconcat(OpcStr, " POP, [NW+$b]"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, ADDRri:$b))]>;
  def poppop : BI<o, POP, POP,
                 (outs MEMpop:$a), (ins MEMpop:$a, MEMpop:$b),
                 !strconcat(OpcStr, " POP, POP"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, ADDRpop:$b))]>;
  def poppeek  : BI<o, POP, PEEK,
                 (outs MEMpop:$a), (ins MEMpop:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " POP, PEEK"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, ADDRpeek:$b))]>;
  def poppush  : BI<o, POP, PUSH, 
                 (outs MEMpop:$a), (ins MEMpop:$a, MEMpush:$b),
                 !strconcat(OpcStr, " POP, PUSH"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, ADDRpush:$b))]>;
  def popsp  : BI<o, POP, SPR, 
                 (outs MEMpop:$a), (ins MEMpop:$a, SPReg:$b),
                 !strconcat(OpcStr, " POP, $b"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, SPReg:$b))]>;
  def poppc  : BI<o, POP, PCR, 
                 (outs MEMpop:$a), (ins MEMpop:$a, PCReg:$b),
                 !strconcat(OpcStr, " POP, $b"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, PCReg:$b))]>;
  def popo   : BI<o, POP, OR, 
                 (outs MEMpop:$a), (ins MEMpop:$a, OReg:$b),
                 !strconcat(OpcStr, " POP, $b"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, OReg:$b))]>;
  def popmemi : BI<o, POP, MEMI, 
                 (outs MEMpop:$a), (ins MEMpop:$a, MEMi:$b),
                 !strconcat(OpcStr, " POP, [$b]"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, ADDRi:$b))]>;
  def popimm16 : BI<o, POP, IMM16, 
                 (outs MEMpop:$a), (ins MEMpop:$a, i16imm:$b),
                 !strconcat(OpcStr, " POP, $b"),
                 [(set MEMpop:$a, (OpNode ADDRpop:$a, i16imm:$b))]>;
//  def popimm6 : BI<o, POP, IMM6, 
//                 (outs MEMpop:$a), (ins MEMpop:$a, i6imm:$b),
//                 !strconcat(OpcStr, " POP, $b"),
//                 [(set MEMpop:$a, (OpNode ADDRpop:$a, i6imm:$b))]>;    

// 0x19: PEEK / [SP]
  def peekreg : BI<o, PEEK, REG,  
                 (outs MEMpeek:$a), (ins MEMpeek:$a, IntRegs:$b),
                 !strconcat(OpcStr, " PEEK, $b"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, IntRegs:$b))]>;
  def peekmemr : BI<o, PEEK, MEMR, 
                 (outs MEMpeek:$a), (ins MEMpeek:$a, MEMr:$b),
                 !strconcat(OpcStr, " PEEK, [$b]"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, ADDRr:$b))]>;
  def peekmemri : BI<o, PEEK, POP, 
                 (outs MEMpeek:$a), (ins MEMpeek:$a, MEMri:$b),
                 !strconcat(OpcStr, " PEEK, [NW+$b]"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, ADDRri:$b))]>;
  def peekpop : BI<o, PEEK, POP,
                 (outs MEMpeek:$a), (ins MEMpeek:$a, MEMpop:$b),
                 !strconcat(OpcStr, " PEEK, POP"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, ADDRpop:$b))]>;
  def peekpeek  : BI<o, PEEK, PEEK,
                 (outs MEMpeek:$a), (ins MEMpeek:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " PEEK, PEEK"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, ADDRpeek:$b))]>;
  def peekpush  : BI<o, PEEK, PUSH, 
                 (outs MEMpeek:$a), (ins MEMpeek:$a, MEMpush:$b),
                 !strconcat(OpcStr, " PEEK, PUSH"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, ADDRpush:$b))]>;
  def peeksp  : BI<o, PEEK, SPR, 
                 (outs MEMpeek:$a), (ins MEMpeek:$a, SPReg:$b),
                 !strconcat(OpcStr, " PEEK, $b"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, SPReg:$b))]>;
  def peekpc  : BI<o, PEEK, PCR, 
                 (outs MEMpeek:$a), (ins MEMpeek:$a, PCReg:$b),
                 !strconcat(OpcStr, " PEEK, $b"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, PCReg:$b))]>;
  def peeko   : BI<o, PEEK, OR, 
                 (outs MEMpeek:$a), (ins MEMpeek:$a, OReg:$b),
                 !strconcat(OpcStr, " PEEK, $b"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, OReg:$b))]>;
  def peekmemi : BI<o, PEEK, MEMI, 
                 (outs MEMpeek:$a), (ins MEMpeek:$a, MEMi:$b),
                 !strconcat(OpcStr, " PEEK, [$b]"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, ADDRi:$b))]>;
  def peekimm16 : BI<o, PEEK, IMM16, 
                 (outs MEMpeek:$a), (ins MEMpeek:$a, i16imm:$b),
                 !strconcat(OpcStr, " PEEK, $b"),
                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, i16imm:$b))]>;
//  def peekimm6 : BI<o, PEEK, IMM6, 
//                 (outs MEMpeek:$a), (ins MEMpeek:$a, i6imm:$b),
//                 !strconcat(OpcStr, " PEEK, $b"),
//                 [(set MEMpeek:$a, (OpNode ADDRpeek:$a, i6imm:$b))]>;    


// 0x1a: PUSH / [--SP]
  def pushreg : BI<o, PUSH, REG,  
                 (outs MEMpush:$a), (ins MEMpush:$a, IntRegs:$b),
                 !strconcat(OpcStr, " PUSH, $b"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, IntRegs:$b))]>;
  def pushmemr : BI<o, PEEK, MEMR, 
                 (outs MEMpush:$a), (ins MEMpush:$a, MEMr:$b),
                 !strconcat(OpcStr, " PUSH, [$b]"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, ADDRr:$b))]>;
  def pushmemri : BI<o, PUSH, POP, 
                 (outs MEMpush:$a), (ins MEMpush:$a, MEMri:$b),
                 !strconcat(OpcStr, " PUSH, [NW+$b]"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, ADDRri:$b))]>;
  def pushpop : BI<o, PUSH, POP,
                 (outs MEMpush:$a), (ins MEMpush:$a, MEMpop:$b),
                 !strconcat(OpcStr, " PUSH, POP"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, ADDRpop:$b))]>;
  def pushpeek  : BI<o, PUSH, PEEK,
                 (outs MEMpush:$a), (ins MEMpush:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " PUSH, PEEK"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, ADDRpeek:$b))]>;
  def pushpush  : BI<o, PUSH, PUSH, 
                 (outs MEMpush:$a), (ins MEMpush:$a, MEMpush:$b),
                 !strconcat(OpcStr, " PUSH, PUSH"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, ADDRpush:$b))]>;
  def pushsp  : BI<o, PUSH, SPR, 
                 (outs MEMpush:$a), (ins MEMpush:$a, SPReg:$b),
                 !strconcat(OpcStr, " PUSH, $b"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, SPReg:$b))]>;
  def pushpc  : BI<o, PUSH, PCR, 
                 (outs MEMpush:$a), (ins MEMpush:$a, PCReg:$b),
                 !strconcat(OpcStr, " PUSH, $b"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, PCReg:$b))]>;
  def pusho   : BI<o, PUSH, OR, 
                 (outs MEMpush:$a), (ins MEMpush:$a, OReg:$b),
                 !strconcat(OpcStr, " PUSH, $b"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, OReg:$b))]>;
  def pushmemi : BI<o, PUSH, MEMI, 
                 (outs MEMpush:$a), (ins MEMpush:$a, MEMi:$b),
                 !strconcat(OpcStr, " PUSH, [$b]"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, ADDRi:$b))]>;
  def pushimm16 : BI<o, PUSH, IMM16, 
                 (outs MEMpush:$a), (ins MEMpush:$a, i16imm:$b),
                 !strconcat(OpcStr, " PUSH, $b"),
                 [(set MEMpush:$a, (OpNode ADDRpush:$a, i16imm:$b))]>;
//  def pushimm6 : BI<o, PUSH, IMM6, 
//                 (outs MEMpush:$a), (ins MEMpush:$a, i6imm:$b),
//                 !strconcat(OpcStr, " PUSH, $b"),
//                 [(set MEMpush:$a, (OpNode ADDRpush:$a, i6imm:$b))]>;    



// 0x1b: SP
  def spreg : BI<o, SPR, REG,  
                 (outs SPReg:$a), (ins SPReg:$a, IntRegs:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set SPReg:$a, (OpNode SPReg:$a, IntRegs:$b))]>;
  def spmemr : BI<o, SPR, MEMR, 
                 (outs SPReg:$a), (ins SPReg:$a, MEMr:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set SPReg:$a, (OpNode SPReg:$a, ADDRr:$b))]>;
  def spmemri : BI<o, SPR, POP, 
                 (outs SPReg:$a), (ins SPReg:$a, MEMri:$b),
                 !strconcat(OpcStr, " $a, [NW+$b]"),
                 [(set SPReg:$a, (OpNode SPReg:$a, ADDRri:$b))]>;
  def sppop : BI<o, SPR, POP,
                 (outs SPReg:$a), (ins SPReg:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, POP"),
                 [(set SPReg:$a, (OpNode SPReg:$a, ADDRpop:$b))]>;
  def sppeek  : BI<o, SPR, PEEK,
                 (outs SPReg:$a), (ins SPReg:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " $a, PEEK"),
                 [(set SPReg:$a, (OpNode SPReg:$a, ADDRpeek:$b))]>;
  def sppush  : BI<o, SPR, PUSH, 
                 (outs SPReg:$a), (ins SPReg:$a, MEMpush:$b),
                 !strconcat(OpcStr, " $a, PUSH"),
                 [(set SPReg:$a, (OpNode SPReg:$a, ADDRpush:$b))]>;
  def spsp  : BI<o, SPR, SPR, 
                 (outs SPReg:$a), (ins SPReg:$a, SPReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set SPReg:$a, (OpNode SPReg:$a, SPReg:$b))]>;
  def sppc  : BI<o, SPR, PCR, 
                 (outs SPReg:$a), (ins SPReg:$a, PCReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set SPReg:$a, (OpNode SPReg:$a, PCReg:$b))]>;
  def spo   : BI<o, SPR, OR, 
                 (outs SPReg:$a), (ins SPReg:$a, OReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set SPReg:$a, (OpNode SPReg:$a, OReg:$b))]>;
  def spmemi : BI<o, SPR, MEMI, 
                 (outs SPReg:$a), (ins SPReg:$a, MEMi:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set SPReg:$a, (OpNode SPReg:$a, ADDRi:$b))]>;
  def spimm16 : BI<o, SPR, IMM16, 
                 (outs SPReg:$a), (ins SPReg:$a, i16imm:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set SPReg:$a, (OpNode SPReg:$a, i16imm:$b))]>;
//  def spimm6 : BI<o, SPR, IMM6, 
//                 (outs SPReg:$a), (ins SPReg:$a, i6imm:$b),
//                 !strconcat(OpcStr, " $a, $b"),
//                 [(set SPReg:$a, (OpNode SPReg:$a, i6imm:$b))]>;    


// 0x1c: PC
  def pcreg : BI<o, PCR, REG,  
                 (outs PCReg:$a), (ins PCReg:$a, IntRegs:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set PCReg:$a, (OpNode PCReg:$a, IntRegs:$b))]>;
  def pcmemr : BI<o, PCR, MEMR, 
                 (outs PCReg:$a), (ins PCReg:$a, MEMr:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set PCReg:$a, (OpNode PCReg:$a, ADDRr:$b))]>;
  def pcmemri : BI<o, PCR, POP, 
                 (outs PCReg:$a), (ins PCReg:$a, MEMri:$b),
                 !strconcat(OpcStr, " $a, [NW+$b]"),
                 [(set PCReg:$a, (OpNode PCReg:$a, ADDRri:$b))]>;
  def pcpop : BI<o, PCR, POP,
                 (outs PCReg:$a), (ins PCReg:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, POP"),
                 [(set PCReg:$a, (OpNode PCReg:$a, ADDRpop:$b))]>;
  def pcpeek  : BI<o, PCR, PEEK,
                 (outs PCReg:$a), (ins PCReg:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " $a, PEEK"),
                 [(set PCReg:$a, (OpNode PCReg:$a, ADDRpeek:$b))]>;
  def pcpush  : BI<o, PCR, PUSH, 
                 (outs PCReg:$a), (ins PCReg:$a, MEMpush:$b),
                 !strconcat(OpcStr, " $a, PUSH"),
                 [(set PCReg:$a, (OpNode PCReg:$a, ADDRpush:$b))]>;
  def pcsp  : BI<o, PCR, SPR, 
                 (outs PCReg:$a), (ins PCReg:$a, SPReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set PCReg:$a, (OpNode PCReg:$a, SPReg:$b))]>;
  def pcpc  : BI<o, PCR, PCR, 
                 (outs PCReg:$a), (ins PCReg:$a, PCReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set PCReg:$a, (OpNode PCReg:$a, PCReg:$b))]>;
  def pco   : BI<o, PCR, OR, 
                 (outs PCReg:$a), (ins PCReg:$a, OReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set PCReg:$a, (OpNode PCReg:$a, OReg:$b))]>;
  def pcmemi : BI<o, PCR, MEMI, 
                 (outs PCReg:$a), (ins PCReg:$a, MEMi:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set PCReg:$a, (OpNode PCReg:$a, ADDRi:$b))]>;
  def pcimm16 : BI<o, PCR, IMM16, 
                 (outs PCReg:$a), (ins PCReg:$a, i16imm:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set PCReg:$a, (OpNode PCReg:$a, i16imm:$b))]>;
//  def pcimm6 : BI<o, PCR, IMM6, 
//                 (outs PCReg:$a), (ins PCReg:$a, i6imm:$b),
//                 !strconcat(OpcStr, " $a, $b"),
//                 [(set PCReg:$a, (OpNode PCReg:$a, i6imm:$b))]>;    



// 0x1d: O
  def oreg : BI<o, OR, REG,  
                 (outs OReg:$a), (ins OReg:$a, IntRegs:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set OReg:$a, (OpNode OReg:$a, IntRegs:$b))]>;
  def omemr : BI<o, OR, MEMR, 
                 (outs OReg:$a), (ins OReg:$a, MEMr:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set OReg:$a, (OpNode OReg:$a, ADDRr:$b))]>;
  def omemri : BI<o, OR, POP, 
                 (outs OReg:$a), (ins OReg:$a, MEMri:$b),
                 !strconcat(OpcStr, " $a, [NW+$b]"),
                 [(set OReg:$a, (OpNode OReg:$a, ADDRri:$b))]>;
  def opop : BI<o, OR, POP,
                 (outs OReg:$a), (ins OReg:$a, MEMpop:$b),
                 !strconcat(OpcStr, " $a, POP"),
                 [(set OReg:$a, (OpNode OReg:$a, ADDRpop:$b))]>;
  def opeek  : BI<o, OR, PEEK,
                 (outs OReg:$a), (ins OReg:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " $a, PEEK"),
                 [(set OReg:$a, (OpNode OReg:$a, ADDRpeek:$b))]>;
  def opush  : BI<o, OR, PUSH, 
                 (outs OReg:$a), (ins OReg:$a, MEMpush:$b),
                 !strconcat(OpcStr, " $a, PUSH"),
                 [(set OReg:$a, (OpNode OReg:$a, ADDRpush:$b))]>;
  def osp  : BI<o, OR, SPR, 
                 (outs OReg:$a), (ins OReg:$a, SPReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set OReg:$a, (OpNode OReg:$a, SPReg:$b))]>;
  def opc  : BI<o, OR, PCR, 
                 (outs OReg:$a), (ins OReg:$a, PCReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set OReg:$a, (OpNode OReg:$a, PCReg:$b))]>;
  def oo   : BI<o, OR, OR, 
                 (outs OReg:$a), (ins OReg:$a, OReg:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set OReg:$a, (OpNode OReg:$a, OReg:$b))]>;
  def omemi : BI<o, OR, MEMI, 
                 (outs OReg:$a), (ins OReg:$a, MEMi:$b),
                 !strconcat(OpcStr, " $a, [$b]"),
                 [(set OReg:$a, (OpNode OReg:$a, ADDRi:$b))]>;
  def oimm16 : BI<o, OR, IMM16, 
                 (outs OReg:$a), (ins OReg:$a, i16imm:$b),
                 !strconcat(OpcStr, " $a, $b"),
                 [(set OReg:$a, (OpNode OReg:$a, i16imm:$b))]>;
//  def oimm6 : BI<o, OR, IMM6, 
//                 (outs OReg:$a), (ins OReg:$a, i6imm:$b),
//                 !strconcat(OpcStr, " $a, $b"),
//                 [(set OReg:$a, (OpNode OReg:$a, i6imm:$b))]>;    


// 0x1e: [i6imm]
  def memireg : BI<o, MEMI, REG,  
                 (outs MEMi:$a), (ins MEMi:$a, IntRegs:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, IntRegs:$b))]>;
  def memimemr : BI<o, MEMI, MEMR, 
                 (outs MEMi:$a), (ins MEMi:$a, MEMr:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, ADDRr:$b))]>;
  def memimemri : BI<o, MEMI, POP, 
                 (outs MEMi:$a), (ins MEMi:$a, MEMri:$b),
                 !strconcat(OpcStr, " [$a], [NW+$b]"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, ADDRri:$b))]>;
  def memipop : BI<o, MEMI, POP,
                 (outs MEMi:$a), (ins MEMi:$a, MEMpop:$b),
                 !strconcat(OpcStr, " [$a], POP"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, ADDRpop:$b))]>;
  def memipeek  : BI<o, MEMI, PEEK,
                 (outs MEMi:$a), (ins MEMi:$a, MEMpeek:$b),
                 !strconcat(OpcStr, " [$a], PEEK"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, ADDRpeek:$b))]>;
  def memipush  : BI<o, MEMI, PUSH, 
                 (outs MEMi:$a), (ins MEMi:$a, MEMpush:$b),
                 !strconcat(OpcStr, " [$a], PUSH"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, ADDRpush:$b))]>;
  def memisp  : BI<o, MEMI, SPR, 
                 (outs MEMi:$a), (ins MEMi:$a, SPReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, SPReg:$b))]>;
  def memipc  : BI<o, MEMI, PCR, 
                 (outs MEMi:$a), (ins MEMi:$a, PCReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, PCReg:$b))]>;
  def memio   : BI<o, MEMI, OR, 
                 (outs MEMi:$a), (ins MEMi:$a, OReg:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, OReg:$b))]>;
  def memimemi : BI<o, MEMI, MEMI, 
                 (outs MEMi:$a), (ins MEMi:$a, MEMi:$b),
                 !strconcat(OpcStr, " [$a], [$b]"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, ADDRi:$b))]>;
  def memiimm16 : BI<o, MEMI, IMM16, 
                 (outs MEMi:$a), (ins MEMi:$a, i16imm:$b),
                 !strconcat(OpcStr, " [$a], $b"),
                 [(set MEMi:$a, (OpNode ADDRi:$a, i16imm:$b))]>;
//  def memiimm6 : BI<o, MEMI, IMM6, 
//                 (outs MEMi:$a), (ins MEMi:$a, i6imm:$b),
//                 !strconcat(OpcStr, " [$a], $b"),
//                 [(set MEMi:$a, (OpNode ADDRi:$a, i6imm:$b))]>;    
                 
}

// TODO
/// NBI_ALL multiclass - Defines all possible combinations of operands valid for
/// non basic instructions.
multiclass NBI_ALL<string OpcStr, bits<6> o, SDNode OpNode> {

// 0x00-0x07: Reg (A, B, C, X, Y, Z, I or J)
  def reg  : NBI<o, REG, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x08-0x0f: [Reg]
  def memr  : NBI<o, MEMR, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x10-0x17: [Reg+i16imm]
  def memri : NBI<o, MEMRI, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x18: POP / [SP++]
  def pop : NBI<o, POP, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x19: PEEK / [SP]
  def peek  : NBI<o, PEEK, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x1a: PUSH / [--SP]
  def push  : NBI<o, PUSH, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x1b: SP
  def sp  : NBI<o, SPR, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x1c: PC
  def pc  : NBI<o, PCR, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x1d: O
  def o   : NBI<o, OR, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x1e: [i16imm]
  def memi : NBI<o, MEMI, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x1f: i16imm
  def imm16  : NBI<o, IMM16, 
                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
                 !strconcat(OpcStr, " $b, $c, $dst"),
                 []>;

// 0x20-0x3f: i6imm 0x00-0x1f
//  def imm6  : NBI<o, IMM6, 
//                 (outs IntRegs:$dst), (ins IntRegs:$b, IntRegs:$c),
//                 !strconcat(OpcStr, " $b, $c, $dst"),
//                 []>;
}

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

// STORE (Write to memory)
// TODO: How can we tell LLVM to handle STORE and LOADS in one instruction 
//       (to save RAM/DISK space)
def SETmemrreg : BI<0x1, MEMR, REG
                 (outs), (ins MEMr:$a, IntRegs:$b),
                 "set [$a], $b",
                 [(store IntRegs:$b, ADDRr:$a)]>;
def SETmemrsp : BI<0x1, MEMR, SPR
                 (outs), (ins MEMr:$a, SPReg:$b),
                 "set [$a], $b",
                 [(store SPReg:$b, ADDRr:$a)]>;
def SETmemrpc : BI<0x1, MEMR, PCR
                 (outs), (ins MEMr:$a, PCReg:$b),
                 "set [$a], $b",
                 [(store PCReg:$b, ADDRr:$a)]>;
def SETmemro : BI<0x1, MEMR, OR
                 (outs), (ins MEMr:$a, OReg:$b),
                 "set [$a], $b",
                 [(store OReg:$b, ADDRr:$a)]>;
def SETmemrimm16 : BI<0x1, MEMR, IMM16
                 (outs), (ins MEMr:$a, i16imm:$b),
                 "set [$a], $b",
                 [(store i16imm:$b, ADDRr:$a)]>;
//def SETmemrimm6 : BI<0x1, MEMR, IMM6
//                 (outs), (ins MEMr:$a, i6imm:$b),
//                 "set [$a], $b",
//                 [(zextstorei16 i6imm:$b, ADDRr:$a)]>;


def SETmemrireg : BI<0x1, MEMRI, REG
                 (outs), (ins MEMri:$a, IntRegs:$b),
                 "set [$a], $b",
                 [(store IntRegs:$b, ADDRri:$a)]>;
def SETmemrisp : BI<0x1, MEMRI, SPR
                 (outs), (ins MEMri:$a, SPReg:$b),
                 "set [$a], $b",
                 [(store SPReg:$b, ADDRri:$a)]>;
def SETmemripc : BI<0x1, MEMRI, PCR
                 (outs), (ins MEMri:$a, PCReg:$b),
                 "set [$a], $b",
                 [(store PCReg:$b, ADDRri:$a)]>;
def SETmemrio : BI<0x1, MEMRI, OR
                 (outs), (ins MEMri:$a, OReg:$b),
                 "set [$a], $b",
                 [(store OReg:$b, ADDRri:$a)]>;
def SETmemriimm16 : BI<0x1, MEMRI, IMM16
                 (outs), (ins MEMri:$a, i16imm:$b),
                 "set [$a], $b",
                 [(store i16imm:$b, ADDRri:$a)]>;
//def SETmemriimm6 : BI<0x1, MEMRI, IMM6
//                 (outs), (ins MEMri:$a, i6imm:$b),
//                 "set [$a], $b",
//                 [(zextstorei16 i6imm:$b, ADDRri:$a)]>;


def SETpopreg : BI<0x1, POP, REG
                 (outs), (ins MEMpop:$a, IntRegs:$b),
                 "set POP, $b",
                 [(store IntRegs:$b, ADDRpop:$a)]>;
def SETpopsp : BI<0x1, POP, SPR
                 (outs), (ins MEMpop:$a, SPReg:$b),
                 "set POP, $b",
                 [(store SPReg:$b, ADDRpop:$a)]>;
def SETpoppc : BI<0x1, POP, PCR
                 (outs), (ins MEMpop:$a, PCReg:$b),
                 "set PEEK, $b",
                 [(store PCReg:$b, ADDRpop:$a)]>;
def SETpopo : BI<0x1, POP, OR
                 (outs), (ins MEMpop:$a, OReg:$b),
                 "set POP, $b",
                 [(store OReg:$b, ADDRpop:$a)]>;
def SETpopimm16 : BI<0x1, POP, IMM16
                 (outs), (ins MEMpop:$a, i16imm:$b),
                 "set POP, $b",
                 [(store i16imm:$b, ADDpop:$a)]>;
//def SETpopimm6 : BI<0x1, POP, IMM6
//                 (outs), (ins MEMpop:$a, i6imm:$b),
//                 "set POP, $b",
//                 [(zextstorei16 i6imm:$b, ADDRpop:$a)]>;


def SETpeekreg : BI<0x1, PEEK, REG
                 (outs), (ins MEMpeek:$a, IntRegs:$b),
                 "set PEEK, $b",
                 [(store IntRegs:$b, ADDRpeek:$a)]>;
def SETpeeksp : BI<0x1, PEEK, SPR
                 (outs), (ins MEMpeek:$a, SPReg:$b),
                 "set PEEK, $b",
                 [(store SPReg:$b, ADDRpeek:$a)]>;
def SETpeekpc : BI<0x1, PEEK, PCR
                 (outs), (ins MEMpeek:$a, PCReg:$b),
                 "set PEEK, $b",
                 [(store PCReg:$b, ADDRpeek:$a)]>;
def SETpeeko : BI<0x1, PEEK, OR
                 (outs), (ins MEMpeek:$a, OReg:$b),
                 "set PEEK, $b",
                 [(store OReg:$b, ADDRpeek:$a)]>;
def SETpeekimm16 : BI<0x1, PEEK, IMM16
                 (outs), (ins MEMpeek:$a, i16imm:$b),
                 "set PEEK, $b",
                 [(store i16imm:$b, ADDpeek:$a)]>;
//def SETpeekimm6 : BI<0x1, PEEK, IMM6
//                 (outs), (ins MEMpeek:$a, i6imm:$b),
//                 "set PEEK, $b",
//                 [(zextstorei16 i6imm:$b, ADDRpeek:$a)]>;


def SETpushreg : BI<0x1, PUSH, REG
                 (outs), (ins MEMpush:$a, IntRegs:$b),
                 "set PUSH, $b",
                 [(store IntRegs:$b, ADDRpush:$a)]>;
def SETpushsp : BI<0x1, PUSH, SPR
                 (outs), (ins MEMpush:$a, SPReg:$b),
                 "set PUSH, $b",
                 [(store SPReg:$b, ADDRpush:$a)]>;
def SETpushpc : BI<0x1, PUSH, PCR
                 (outs), (ins MEMpush:$a, PCReg:$b),
                 "set PUSH, $b",
                 [(store PCReg:$b, ADDRpush:$a)]>;
def SETpusho : BI<0x1, PUSH, OR
                 (outs), (ins MEMpush:$a, OReg:$b),
                 "set PUSH, $b",
                 [(store OReg:$b, ADDRpush:$a)]>;
def SETpushimm16 : BI<0x1, PUSH, IMM16
                 (outs), (ins MEMpush:$a, i16imm:$b),
                 "set PUSH, $b",
                 [(store i16imm:$b, ADDpush:$a)]>;
//def SETpushimm6 : BI<0x1, PUSH, IMM6
//                 (outs), (ins MEMpush:$a, i6imm:$b),
//                 "set PUSH, $b",
//                 [(zextstorei16 i6imm:$b, ADDRpush:$a)]>;


def SETmemireg : BI<0x1, MEMI, REG
                 (outs), (ins MEMi:$a, IntRegs:$b),
                 "set [$a], $b",
                 [(store IntRegs:$b, ADDRi:$a)]>;
def SETmemisp : BI<0x1, MEMI, SPR
                 (outs), (ins MEMi:$a, SPReg:$b),
                 "set [$a], $b",
                 [(store SPReg:$b, ADDRi:$a)]>;
def SETmemipc : BI<0x1, MEMI, PCR
                 (outs), (ins MEMi:$a, PCReg:$b),
                 "set [$a], $b",
                 [(store PCReg:$b, ADDRi:$a)]>;
def SETmemio : BI<0x1, MEMI, OR
                 (outs), (ins MEMi:$a, OReg:$b),
                 "set [$a], $b",
                 [(store OReg:$b, ADDRi:$a)]>;
def SETmemiimm16 : BI<0x1, MEMI, IMM16
                 (outs), (ins MEMi:$a, i16imm:$b),
                 "set [$a], $b",
                 [(store i16imm:$b, ADDRi:$a)]>;
//def SETmemiimm6 : BI<0x1, MEMI, IMM6
//                 (outs), (ins MEMi:$a, i6imm:$b),
//                 "set [$a], $b",
//                 [(zextstorei16 i6imm:$b, ADDRi:$a)]>;

// LOAD (Read from memory)
def SETrmemr : BI<0x1, REG, MEMR
                 (outs IntRegs:$a), (ins MEMr:$b),
                 "set $a, [$b]",
                 [(set IntRegs:$a, (load ADDRr:$b))]>;
def SETrmemri : BI<0x1, REG, MEMRI
                 (outs IntRegs:$a), (ins MEMri:$b),
                 "set $a, [$b]",
                 [(set IntRegs:$a, (load ADDRri:$b))]>;
def SETrpop : BI<0x1, REG, POP
                 (outs IntRegs:$a), (ins MEMpop:$b),
                 "set $a, POP",
                 [(set IntRegs:$a, (load ADDRpop:$b))]>;
def SETrpeek : BI<0x1, REG, PEEK
                 (outs IntRegs:$a), (ins MEMpeek:$b),
                 "set $a, PEEK",
                 [(set IntRegs:$a, (load ADDRpeek:$b))]>;
def SETrpush : BI<0x1, REG, PUSH
                 (outs IntRegs:$a), (ins MEMpush:$b),
                 "set $a, PUSH",
                 [(set IntRegs:$a, (load ADDRpush:$b))]>;
def SETrmemi : BI<0x1, REG, MEMI
                 (outs IntRegs:$a), (ins MEMi:$b),
                 "set $a, [$b]",
                 [(set IntRegs:$a, (load ADDRi:$b))]>;


def SETspemmr : BI<0x1, SPR, MEMR
                 (outs SPReg:$a), (ins MEMr:$b),
                 "set $a, [$b]",
                 [(set SPReg:$a, (load ADDRr:$b))]>;
def SETspmemri : BI<0x1, SPR, MEMRI
                 (outs SPReg:$a), (ins MEMri:$b),
                 "set $a, [$b]",
                 [(set SPReg:$a, (load ADDRri:$b))]>;
def SETsppop : BI<0x1, SPR, POP
                 (outs SPReg:$a), (ins MEMpop:$b),
                 "set $a, POP",
                 [(set SPReg:$a, (load ADDRpop:$b))]>;
def SETsppeek : BI<0x1, SPR, PEEK
                 (outs SPReg:$a), (ins MEMpeek:$b),
                 "set $a, PEEK",
                 [(set SPReg:$a, (load ADDRpeek:$b))]>;
def SETsppush : BI<0x1, SPR, PUSH
                 (outs SPReg:$a), (ins MEMpush:$b),
                 "set $a, PUSH",
                 [(set SPReg:$a, (load ADDRpush:$b))]>;
def SETspmemi : BI<0x1, SPR, MEMI
                 (outs SPReg:$a), (ins MEMi:$b),
                 "set $a, [$b]",
                 [(set SPReg:$a, (load ADDRi:$b))]>;


def SETpcemmr : BI<0x1, PCR, MEMR
                 (outs PCReg:$a), (ins MEMr:$b),
                 "set $a, [$b]",
                 [(set PCReg:$a, (load ADDRr:$b))]>;
def SETpcmemri : BI<0x1, PCR, MEMRI
                 (outs PCReg:$a), (ins MEMri:$b),
                 "set $a, [$b]",
                 [(set PCReg:$a, (load ADDRri:$b))]>;
def SETpcpop : BI<0x1, PCR, POP
                 (outs PCReg:$a), (ins MEMpop:$b),
                 "set $a, POP",
                 [(set PCReg:$a, (load ADDRpop:$b))]>;
def SETpcpeek : BI<0x1, PCR, PEEK
                 (outs PCReg:$a), (ins MEMpeek:$b),
                 "set $a, PEEK",
                 [(set PCReg:$a, (load ADDRpeek:$b))]>;
def SETpcpush : BI<0x1, PCR, PUSH
                 (outs PCReg:$a), (ins MEMpush:$b),
                 "set $a, PUSH",
                 [(set PCReg:$a, (load ADDRpush:$b))]>;
def SETpcmemi : BI<0x1, PCR, MEMI
                 (outs PCReg:$a), (ins MEMi:$b),
                 "set $a, [$b]",
                 [(set PCReg:$a, (load ADDRi:$b))]>;


def SEToemmr : BI<0x1, OR, MEMR
                 (outs OReg:$a), (ins MEMr:$b),
                 "set $a, [$b]",
                 [(set OReg:$a, (load ADDRr:$b))]>;
def SETomemri : BI<0x1, OR, MEMRI
                 (outs OReg:$a), (ins MEMri:$b),
                 "set $a, [$b]",
                 [(set OReg:$a, (load ADDRri:$b))]>;
def SETopop : BI<0x1, OR, POP
                 (outs OReg:$a), (ins MEMpop:$b),
                 "set $a, POP",
                 [(set OReg:$a, (load ADDRpop:$b))]>;
def SETopeek : BI<0x1, OR, PEEK
                 (outs OReg:$a), (ins MEMpeek:$b),
                 "set $a, PEEK",
                 [(set OReg:$a, (load ADDRpeek:$b))]>;
def SETopush : BI<0x1, OR, PUSH
                 (outs OReg:$a), (ins MEMpush:$b),
                 "set $a, PUSH",
                 [(set OReg:$a, (load ADDRpush:$b))]>;
def SETomemi : BI<0x1, OR, MEMI
                 (outs OReg:$a), (ins MEMi:$b),
                 "set $a, [$b]",
                 [(set OReg:$a, (load ADDRi:$b))]>;


defm ADD   : BI_ALL<"add", 0x2, add>;
defm SUB   : BI_ALL<"sub", 0x3, sub>;
defm MUL   : BI_ALL<"mul", 0x4, mul>;
defm DIV   : BI_ALL<"div", 0x5, sdiv>;
defm MOD   : BI_ALL<"mod", 0x6, srem>;
defm SHL   : BI_ALL<"shl", 0x7, shl>;
defm SHR   : BI_ALL<"shr", 0x8, ashr>;
defm AND   : BI_ALL<"and", 0x9, and>;
defm BOR   : BI_ALL<"bor", 0xa, or>;
defm XOR   : BI_ALL<"xor", 0xb, xor>;

// TODO
// defm IFE   : BI_ALL<"ife", 0xc, TODO>;
// defm IFN   : BI_ALL<"ifn", 0xd, TODO>;
// defm IFG   : BI_ALL<"ifg", 0xe, TODO>;
// defm IFB   : BI_ALL<"ifb", 0xf, TODO>;
// defm JSR   : NBI_ALL<"jsr", 0x1, TODO>
