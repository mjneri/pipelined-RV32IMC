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
	c.addi4spn x8, 10
	c.addi16sp 20
	nop
	nop

	addi x12, x4, 16
# This program writes the fibbonacci sequence into the memory. (Compressed)
	c.addi x5, 184
	c.addi x1, 1
	sw x1, 4(x12)
	c.addi x12, 8
Fibs_C:
	c.lw x9, -8(x12)
	c.lw x10, -4(x12)
	add x11, x2, x1
	c.sw x11, 0(x12)
	c.addi x12, 4
	sub x15, x12, x5
	c.beqz x15, Exit_C
	c.jal Fibs_C
Exit_C:
	sw x12, 0(x5)
	
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
