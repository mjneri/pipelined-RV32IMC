Main:
	addi x1, x0, 10
	addi x2, x0, 15
	sw x1, 128(x0)
Loop:
	addi x1, x1, 1
	beq x1, x2, Exit
	jal x0, Loop
Exit:
	sw x1, 132(x0)
	uret