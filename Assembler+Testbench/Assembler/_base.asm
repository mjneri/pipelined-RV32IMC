main:
addi x1, x0, 20
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
loop:
addi x1, x1, -1
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
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
