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

let Namespace = "Dcpu16" in {
	def A : Register<"a">;
	def B : Register<"b">;
	def C : Register<"c">;
	def X : Register<"x">;
	def Y : Register<"y">;
	def Z : Register<"z">;
	def I : Register<"i">;
	def J : Register<"j">;

	def O : Register<"o">;
	def PC: Register<"pc">;
	def SP: Register<"pc">;
}

// Integer register
def IntRegs : RegisterClass<"Dcpu16", [i16],  16,
                        (add A, B, C, X, Y, Z, I, J, PC)>;

// Overflow and stackpointer register
def OReg : RegisterClass<"Dcpu16", [i16], 16, (add O, SP)> {
  let isAllocatable = 0;
}
