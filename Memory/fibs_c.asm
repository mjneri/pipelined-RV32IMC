# This program writes the fibbonacci sequence into the memory. (Compressed)
c.addi x12, 63
c.addi x12, 63
c.addi x12, 62
c.addi x8, 1
c.sw x8, 1(x11)
c.addi x11, 8
Fibs_C:
c.lw x8, -2(x11)
c.lw x9, -1(x11)
add x10, x9, x8
c.sw x10, 0(x11)
c.addi x11, 4
sub x13, x12, x11
c.beqz x13, Exit_C
c.jal Fibs_C
Exit_C:
c.sw x11, 0(x12)

nop
nop
nop
nop
nop
nop
nop

# This program writes the fibbonacci sequence into the memory. (Regular)
addi x22, x0, 380
addi x21, x11, 4
addi x18, x0, 1
sw x18, 4(x21)
addi x21, x21, 8
Fibs_B:
lw x18, -8(x21)
lw x19, -4(x21)
add x20, x19, x18
sw x20, 0(x21)
addi x21, x21, 4
beq x21, x22, Exit_B
jal x0, Fibs_B
Exit_B:
sw x21, 0(x22)

nop
nop
nop
nop
nop
nop
nop
nop
nop
nop