main:
	addi x1, x0, 10
loop:
	addi x1, x1, -1
	beq x1, x0, zoom
	jal x0, loop
zoom:
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
