Main:
	addi x28, x0, 10
	addi x29, x0, 15
	sw x28, 8(x5)
Loop:
	addi x28, x28, 1
	beq x29, x28, Exit
	jal x0, Loop
Exit:
	sw x28, 12(x5)
	uret
