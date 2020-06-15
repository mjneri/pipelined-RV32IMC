main:
	addi x1, x0, 20
	c.nop
	c.nop
	c.nop
	c.nop
loop:
	addi x1, x1, -1
	c.nop
	c.nop
	c.nop
	c.nop
	beq x1, x0, zoom
	jal x0, loop

zoom:
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
	nop