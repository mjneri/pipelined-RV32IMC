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
sw t0, 0(x2)	#from c.swsp t0, 0
sw t1, 4(x2)	#from c.swsp t1, 1
sw t2, 8(x2)	#from c.swsp t2, 2
sw t3, 12(x2)	#from c.swsp t3, 3
sw t4, 16(x2)	#from c.swsp t4, 4
sw t5, 20(x2)	#from c.swsp t5, 5
sw t6, 24(x2)	#from c.swsp t6, 6
sw a0, 28(x2)	#from c.swsp a0, 7
sw a1, 32(x2)	#from c.swsp a1, 8
sw a2, 36(x2)	#from c.swsp a2, 9
sw a3, 40(x2)	#from c.swsp a3, 10
sw a4, 44(x2)	#from c.swsp a4, 11
sw a5, 48(x2)	#from c.swsp a5, 12
sw a6, 52(x2)	#from c.swsp a6, 13
sw a7, 56(x2)	#from c.swsp a7, 14

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
lw t0, 0(x2)	#from c.lwsp t0, 0
lw t1, 4(x2)	#from c.lwsp t1, 1
lw t2, 8(x2)	#from c.lwsp t2, 2
lw t3, 12(x2)	#from c.lwsp t3, 3
lw t4, 16(x2)	#from c.lwsp t4, 4
lw t5, 20(x2)	#from c.lwsp t5, 5
lw t6, 24(x2)	#from c.lwsp t6, 6
lw a0, 28(x2)	#from c.lwsp a0, 7
lw a1, 32(x2)	#from c.lwsp a1, 8
lw a2, 36(x2)	#from c.lwsp a2, 9
lw a3, 40(x2)	#from c.lwsp a3, 10
lw a4, 44(x2)	#from c.lwsp a4, 11
lw a5, 48(x2)	#from c.lwsp a5, 12
lw a6, 52(x2)	#from c.lwsp a6, 13
lw a7, 56(x2)	#from c.lwsp a7, 14
addi sp, sp, 60

uret
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
