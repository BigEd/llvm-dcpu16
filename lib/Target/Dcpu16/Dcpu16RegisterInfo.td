//===-- Dcpu16RegisterInfo.td - Dcpu16 Register defs ---------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the Dcpu16 register file 
//===----------------------------------------------------------------------===//


class Dcpu16Reg<bits<6> num, string n> : Register<n> {
  field bits<6> Num;
  let Namespace = "DCPU";
}

def A : Dcpu16Reg<0x00, "a">;
def B : Dcpu16Reg<0x01, "b">;
def C : Dcpu16Reg<0x02, "c">;
def X : Dcpu16Reg<0x03, "x">;
def Y : Dcpu16Reg<0x04, "y">;
def Z : Dcpu16Reg<0x05, "z">;
def I : Dcpu16Reg<0x06, "i">;
def J : Dcpu16Reg<0x07, "j">;

def SP: Dcpu16Reg<0x1b, "pc">;
def PC: Dcpu16Reg<0x1c, "pc">;
def O : Dcpu16Reg<0x1d, "o">;

// Integer register
def IntRegs : RegisterClass<"DCPU", [i16],  16,
                        (add A, B, C, X, Y, Z, I, J, PC)>;

// Overflow and stackpointer register
def OReg : RegisterClass<"DCPU", [i16], 16, (add O, SP)> {
  let isAllocatable = 0;
}
