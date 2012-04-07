Low Level Virtual Machine (LLVM)
================================

Consider this attempt to create a new backend from scratch 
to be dead. But don't fear, there is somebody else who branched
an existing 16-bit backend and got much faster, much further:

 * https://github.com/krasin/llvm-dcpu16

I will focus on porting the newlib (c standard library) to the
DCPU16 target, using his compiler.
