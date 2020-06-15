# ISR for spi.s
# Register usage:
#		s0 -> SPI BUSY
#		s1 -> SPI DONE
#		sp -> Stack pointer; points to word address 0x3FF
#		gp -> points to PROTOCOLMEM address (0x400)
#		a0-a1 -> return values
# 		a2-a7 -> subroutine arguments
.text
isr:
	# store temp registers & args in stack
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

	# Load SPI Data Out
	lhu s2, 0x8(gp)
	
	# Update SPI BUSY & SPI DONE registers (s0&s1)
	lw t0, 0x4(gp)				# load SPI Output Control
	andi s0, t0, 1				# get BUSY field
	andi s1, t0, 2				# get DONE field

	# Turn off SPI controller
	# This is done due to how e_clk in the SPI controller works.
	# By turning off the controller, e_clk starts running at 25MHz again, allowing
	# it to capture EN. If we leave ON = 1, e_clk will stay running at the prescale frequency,
	# which lessens the chance of e_clk capturing EN.
	lw t0, 0x8(x0)				# load SPI Input Control
	xori t0, t0, 2				# set ON = 0
	sw t0, 0x8(x0)				# store back to Input Control

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