# This program writes the fibbonacci sequence into the memory. (Regular)
addi x5, x0, 188
addi x1, x0, 1
sw x1, 4(x0)
addi x4, x0, 8
Fibs_B:
lw x1, -8(x4)
lw x2, -4(x4)
add x3, x2, x1
sw x3, 0(x4)
addi x4, x4, 4
beq x4, x5, Exit_B
jal x0, Fibs_B
Exit_B:
sw x4, 0(x5)

nop
nop
c.bnez x21, Fibs_C
nop
nop
c.j Exit_B
c.jr x13

addi x11, x4, 4
# This program writes the fibbonacci sequence into the memory. (Compressed)
c.addi x12, 380
c.addi x8, 1
c.sw x8, 1(x11)
c.addi x11, 8
Fibs_C:
c.lw x8, -2(x11)
c.lw x9, -1(x11)
add x10, x9, x8
c.sw x10, 0(x11)
c.addi x11, 4
sub x15, x12, x11
c.beqz x15, Exit_C
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
nop
nop
nop