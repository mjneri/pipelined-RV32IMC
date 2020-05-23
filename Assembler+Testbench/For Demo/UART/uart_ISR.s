# This test code is to demonstrate UART functionality of the
# Pipelined RV32IMC + Protocol controllers
#
# An external device sends a command to the FPGA, and outputs
# a corresponding answer.
# Commands:
# ADD XXX,YYY -> add
# SUB XXX,YYY -> sub
# DIV XXX,YYY -> div
# REM XXX,YYY -> rem
# MUL XXX,YYY -> mul
# MHU XXX,YYY -> mulhu
# ==========================
# 3 digits per operand only. Expected inputs are unsigned
# Received data is stored starting at addr 0x100:
# 0x100: "COM[]" (contains ADD , SUB , etc.)
# 0x104: "XXX,"
# 0x108: "YYY"
# 13 bytes are expected, including \r\n
# ==========================
# Register usage:
# 		s1 -> # of bytes received
#		s4 -> TXBF
#		s11-> wrdone & rddone status from previous interrupt
#		a3 -> == 1 if 13 bytes received, 0 otherwise
#		t0-t6 -> local subroutine registers (not saved between calls)
# ==========================
# NOTE: when addressing strings (.ascii), LSByte corresponds to first character in the string.

.text
isr:
	# push temporary register contents to the stack
	c.addi sp, -28
	c.swsp t0, 0
	c.swsp t1, 1
	c.swsp t2, 2
	c.swsp t3, 3
	c.swsp t4, 4
	c.swsp t5, 5
	c.swsp t6, 6

	c.li a3, 0					# initialize a3 to 0

	# NOP for 5 more cycles to give enough time for the
	# protocol controller (mcont.v) to write to datamem
	c.nop
	c.nop
	c.nop
	c.nop
	c.nop

	# check if UART interrupted
	lw t0, 0xc(gp)				# load UART Output Control
	andi t1, t0, 0x101			# get RDDONE & WRDONE
	beq t1, x0, eret			# if both are deasserted, UART didn't interrupt. execute URET

	andi s4, t0, 0x40			# get TXBF & store to s4 so main program can check if buffer is still full
	
	c.mv t2, s11				# copy s11 contents to t2
	andi t2, t2, 0x100			# get RDDONE from s11
	bne t2, x0, eret			# if RDDONE was asserted from the previous interrupt, then current interrupt is due to WRDONE.
								# Don't execute code for received data.
	
	andi t1, t0, 0x100			# get RDDONE
	beq t1, x0, eret			# if interrupt wasn't due to received data, exit ISR

	# Check if data received is valid
	andi t1, t0, 0x200			# get PERR
	bne t1, x0, eret			# if PERR is asserted, data is invalid; exit ISR

	# Load received data
	lw t2, 0x10(gp)				# get received data from UART Data Out
	c.addi s1, 1				# increment # of bytes received
	c.li t1, 12					# check if byte received is 12th byte ('\r')
	bge s1, t1, isr_skipstore	# if bytes received >= 12, don't store to datamem
	
	addi t1, s1, -1				# offset = bytes received - 1
	sb t2, 0x100(t1)			# store data starting at 0x100

	isr_skipstore:
	c.li t1, 13					# check if 13 bytes have been received
	blt s1, t1, eret			# if bytes received < 13, don't assert a3
	c.li a3, 1					# assert a3 so main program knows 13 bytes have been received
	c.li s1, 0					# reset bytes received to 0

eret:
	# Pop registers from stack
	c.lwsp t0, 0
	c.lwsp t1, 1
	c.lwsp t2, 2
	c.lwsp t3, 3
	c.lwsp t4, 4
	c.lwsp t5, 5
	c.lwsp t6, 6
	c.addi sp, 28

	lw s11, 0xc(gp)				# load Output control
	andi s11, s11, 0x101		# get updated RDDONE & WRDONE

	uret

# Add at least 4 NOPs to prevent don't cares from entering the pipeline
	c.nop
	c.nop
	c.nop
	c.nop