Main:
	addi x28, x0, 10
	addi x29, x0, 15
	sw x28, 112(x0)
Loop:
	addi x28, x28, 1
	beq x29, x28, Exit
	jal x0, Loop
Exit:
	sw x29, 116(x0)
	uret
