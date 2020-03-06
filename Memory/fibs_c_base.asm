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
bne x21, x0, Fibs_C	#from c.bnez x21, Fibs_C
nop
nop
jal x0, Exit_B	#from c.j Exit_B
jalr x0, x13, 0	#from c.jr x13

addi x11, x4, 4
# This program writes the fibbonacci sequence into the memory. (Compressed)
addi x12, x12, 380	#from c.addi x12, 380
addi x8, x8, 1	#from c.addi x8, 1
sw x8, 4(x11)	#from c.sw x8, 4(x11)
addi x11, x11, 8	#from c.addi x11, 8
Fibs_C:
lw x8, -8(x11)	#from c.lw x8, -8(x11)
lw x9, -4(x11)	#from c.lw x9, -4(x11)
add x10, x9, x8
sw x10, 0(x11)	#from c.sw x10, 0(x11)
addi x11, x11, 4	#from c.addi x11, 4
sub x15, x12, x11
beq x15, x0, Exit_C	#from c.beqz x15, Exit_C
jal x1, Fibs_C	#from c.jal Fibs_C
Exit_C:
sw x11, 0(x12)	#from c.sw x11, 0(x12)

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
