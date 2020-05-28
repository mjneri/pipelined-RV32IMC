# ISR for lcd.s
.text
isr:
	# store temp registers in stack
	addi sp, sp, -60			# formula: sp - (# of registers to save)*4
	c.swsp t0, 0
	c.swsp t1, 1
	c.swsp t2, 2
	c.swsp t3, 3
	c.swsp t4, 4
	c.swsp t5, 5
	c.swsp t6, 6
	c.swsp a0, 7
	c.swsp a1, 8
	c.swsp a2, 9
	c.swsp a3, 10
	c.swsp a4, 11
	c.swsp a5, 12
	c.swsp a6, 13
	c.swsp a7, 14

	# Check if I2C interrupted
	lw s1, 0x18(gp)				# load I2C output control
	c.andi s1, 1				# get BUSY field only so i2c_send() knows if I2C is still busy
	
eret:
	# reload temp registers
	c.lwsp t0, 0
	c.lwsp t1, 1
	c.lwsp t2, 2
	c.lwsp t3, 3
	c.lwsp t4, 4
	c.lwsp t5, 5
	c.lwsp t6, 6
	c.lwsp a0, 7
	c.lwsp a1, 8
	c.lwsp a2, 9
	c.lwsp a3, 10
	c.lwsp a4, 11
	c.lwsp a5, 12
	c.lwsp a6, 13
	c.lwsp a7, 14
	addi sp, sp, 60

	uret
	c.nop
	c.nop
	c.nop
	c.nop