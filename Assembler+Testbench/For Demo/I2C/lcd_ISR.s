# ISR for lcd.s
.text
isr:
	# store temp registers in stack
	addi sp, sp, -28
	c.swsp t0, 0
	c.swsp t1, 1
	c.swsp t2, 2
	c.swsp t3, 3
	c.swsp t4, 4
	c.swsp t5, 5
	c.swsp t6, 6

	# NOP for 5 more cycles so mcont.v has time to write to datamem before we access it
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop

	# Check if I2C interrupted
	lw a0, 0x18(gp)				# load I2C output control
	andi t0, a0, 2				# get DONE field only
	beq t0, x0, eret			# if DONE is not asserted, I2C didn't interrupt. exit ISR

	c.andi a0, 1				# get BUSY field only
	
eret:
	# reload temp registers
	c.lwsp t0, 0
	c.lwsp t1, 1
	c.lwsp t2, 2
	c.lwsp t3, 3
	c.lwsp t4, 4
	c.lwsp t5, 5
	c.lwsp t6, 6
	addi sp, sp, 28

	uret
	c.nop
	c.nop
	c.nop
	c.nop