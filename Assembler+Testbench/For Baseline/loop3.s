main:
	addi x1, x0, 10
loop:
	addi x1, x1, -1
	beq x1, x0, zoom
	jal x0, loop
zoom:
	jal x0, zoom
