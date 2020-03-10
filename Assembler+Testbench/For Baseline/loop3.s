main:
	addi x1, x0, 20
	nop
	nop
	nop
	nop
loop:
	addi x1, x1, -1
	nop
	nop
	nop
	nop
	beq x1, x0, zoom
	jal x0, loop
zoom:
	jal x0, zoom
