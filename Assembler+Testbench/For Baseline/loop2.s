main:
	addi x1, x0, 10
	auipc x2, 0
	addi x1, x1, -1
	beq x1, x0, zoom
	jalr x0, x2, 0
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
