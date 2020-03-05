# This program writes the fibbonacci sequence into the memory. (Regular)
addi x5, x0, 184
sw x0, 0(x0)
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
sw x4, 0(x0)

nop
nop
addi x8, x2, 40	#from c.addi4spn x8, 10
addi x2, x2, 320	#from c.addi16sp 20
nop
nop

addi x12, x4, 16
# This program writes the fibbonacci sequence into the memory. (Compressed)
addi x5, x5, 184	#from c.addi x5, 184
addi x1, x1, 1	#from c.addi x1, 1
sw x1, 4(x12)
addi x12, x12, 8	#from c.addi x12, 8
Fibs_C:
lw x9, -8(x12)	#from c.lw x9, -8(x12)
lw x10, -4(x12)	#from c.lw x10, -4(x12)
add x11, x2, x1
sw x11, 0(x12)	#from c.sw x11, 0(x12)
addi x12, x12, 4	#from c.addi x12, 4
sub x15, x12, x5
beq x15, x0, Exit_C	#from c.beqz x15, Exit_C
jal x1, Fibs_C	#from c.jal Fibs_C
Exit_C:
sw x12, 0(x5)

nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
