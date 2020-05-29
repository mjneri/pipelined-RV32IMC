# This test code is to demonstrate UART functionality of the
# Pipelined RV32IMC + Protocol controllers
#
# An external device sends a lowercase character to the FPGA, and outputs
# the uppercase character.
# ==========================
# Register usage:
#		gp -> points to PROTOCOLMEM addresses
#		s0 -> x0 for compressed instructions
#		s1 -> TXBF
#		s2 -> Asserted if valid data has been received
#		s11 -> WRDONE & RDDONE status from previous interrupt
#		t0-t6 -> local subroutine registers (not saved between calls)
#		a0-a1 -> subroutine return values
#		a2-a7 -> subroutine arguments
# ==========================
# NOTE: ISR should save a0-a7 & t0-t6 in the stack to preserve their value.
# Also, should the ISR need to use c.jal, dont forget to save ra to the stack first.

.text
isr:
	# push temporary register contents to the stack
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

	c.li s2, 0					# initialize s2 to 0

	# check if UART interrupted
	lw t0, 0xc(gp)				# load UART Output Control to t0
	andi t1, t0, 0x101			# get RDDONE & WRDONE
	beq t1, x0, eret			# if both are deasserted, UART didn't interrupt. execute URET

	andi s1, t0, 0x40			# get TXBF & store to s1 so main program can check if buffer is still full
	
	c.mv t2, s11				# copy s11 contents to t2
	andi t2, t2, 0x100			# get RDDONE from s11
	bne t2, x0, eret			# if RDDONE was asserted from the previous interrupt, then current interrupt is due to WRDONE.
								# Don't execute code for received data.
	
	andi t1, t0, 0x100			# get RDDONE
	beq t1, x0, eret			# if interrupt wasn't due to received data, exit ISR

	# Check if data received is valid
	andi t1, t0, 0x200			# get PERR
	bne t1, x0, eret			# if PERR is asserted, data is invalid; exit ISR
	c.li s2, 1					# if data is valid, assert s2

eret:
	# Pop registers from stack
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

	lw s11, 0xc(gp)				# load Output control
	andi s11, s11, 0x101		# get updated RDDONE & WRDONE

	uret

# Add at least 4 NOPs to prevent don't cares from entering the pipeline
	c.nop
	c.nop
	c.nop
	c.nop