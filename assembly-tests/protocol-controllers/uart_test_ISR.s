# ISR for uart_test.s
isr:
	c.li a5, 0			# reset a5 to 0
	# NOP for 13 cycles to give enough time for the
	# protocol controller (mcont.v) to write to datamem
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	
	# check if UART interrupted
	# Registers used:
	# t0 - contains UART Output Control contents
	# t1 - contains immediate
	# t2 - contains AND results
	# t3 - contains immediate
	# t4 - contains immediate
	c.lwsp t0, 3		# load UART Output Control (0x403)
	c.li t1, 0x3		# set t1 t0 0x3
	c.slli t1, 8		# set t1 to 0x00000300 (only need to check PERR and RDDONE)
	and t2, t0, t1		# get only PERR & RDDONE from Output Control
						# //if PERR == 1, t2 should be 0x00000200
						# //if RDDONE == 1, t2 should be 0x00000100
						# //if both == 1, t2 should be 0x00000300
						# //else, t2 should be 0x00000000
						# //if PERR is asserted, go to ERET
						# immediates to be used for checking are in
						# t1 (0x00000300), t3(0x00000200), t4(0x00000100)
	c.li t3, 0x2
	c.li t4, 0x1
	c.slli t3, 8
	c.slli t4, 8

# Check for PERR & RDDONE
uart_check:
	beq t2, t1, eret	# PERR & RDDONE are asserted
	beq t2, t3, eret	# PERR is asserted
	beq t2, x0, eret	# nothing asserted

	c.li a5, 1			# set a5 to non-zero value

eret:
	uret

# Add at least 4 NOPs to prevent don't cares from entering the pipeline
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop