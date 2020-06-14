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
# NOTE: when passing arguments to subroutines, store them in a2-a7
# If return values are needed, store them in a0-a1

.data 0x1c
	.ascii "RV32IMC Reporting for duty! I will convert lowercase to uppercase!\r\n"

.text
init:
	addi sp, x0, 0x3FF			# Stack pointer address
	c.slli sp, 2
	addi gp, x0, 0x400			# set gp to point to PROTOCOLMEM addresses
	c.slli gp, 2
	c.li s0, 0					# s0 = 0 for compressed instructions

setup:
	# Settings: 9600bps, no parity, 1 stop bit
	addi t0, x0, 0x145
	c.slli t0, 4
	c.addi t0, 7				# t0 = 5207 -> baudcontrol for 9600bps
	c.slli t0, 8				# shift to baudcontrol field
	sw t0, 0x10(x0)				# store to Input Control

send_intro:
	# Send introduction to external device
	c.li t6, 0					# initialize t6 to 0; t6 will serve as byte index
	send_intro_loop:
	lbu a2, 0x1c(t6)			# load char from intro string to uart_send args
	c.jal uart_send				# call uart_send(a2)
	
	c.li t0, 0xa				# ascii for \n
	lbu a2, 0x1c(t6)			# reload char
	beq t0, a2, data_wait		# if last sent char is \n, go to data wait

	c.addi t6, 1				# increment byte index
	c.j send_intro_loop			# go back to loop


data_wait:
	beq s2, x0, data_wait		# Wait until s2 is asserted, indicating that valid data has been received
	c.li s2, 0					# Reset s2 to 0 to indicate received data is now being processed

main:
	lbu t0, 0x10(gp)			# Load UART Data Out

	# Check if received data is lowercase ASCII or not; if not, no need to convert
	# equivalent: check if 'a' < data < 'z'
	addi t1, x0, 97				# 'a'
	addi t2, x0, 123			# 'z' + 1
	bltu t0, t1, __main1		# if data < 'a', go to __main1
	bgeu t0, t2, __main1		# if data > 'z', go to __main1

	addi t0, t0, -32			# subtract 32 from ASCII value to get uppercase ASCII

	__main1:
	c.mv a2, t0					# copy data to a2 (arg for uart_send)
	c.jal uart_send				# call uart_send(); equivalent: uart_send(a2)
	c.j data_wait				# wait for new data


# ======================================================
# SUBROUTINES
# ======================================================
	
uart_send:
	# equivalent: void uart_send(char c); Args: a2 = char c
	# Subroutine that sends 1 byte to UART Transmit buffer. UART sends automatically start after
	# Check if transmit buffer is full
	#; if TXBF is asserted, program will loop here until the ISR deasserts it
	lbu s1, 0xc(gp)				# get TXBF from Output control
	andi s1, s1, 0x40
	
	uart_txbufcheck:
	c.bnez s1, uart_txbufcheck	# wait until TXBF is not asserted anymore

	# Send char to TXBUFFER
	c.sw a2, 3(s0)				# store to UART Data In (addr 0xC)
	
	lw t0, 0x10(x0)				# Load UART Input Control
	ori t0, t0, 1				# set EN = 1
	sw t0, 0x10(x0)				# store back to Input Control

	c.addi sp, -4				# push to stack
	c.swsp ra, 0				# store return address to stack
	c.jal nop_13				# NOP for 13 cycles until mcont.v reads from input control
	c.lwsp ra, 0				# pop ra from stack
	c.addi sp, 4

	lw t0, 0x10(x0)				# Load input control
	xori t0, t0, 1				# set EN = 0
	sw t0, 0x10(x0)				# store back to input control

	c.addi sp, -4				# push to stack
	c.swsp ra, 0				# store ra to stack
	c.jal nop_13				# NOP for 13 cycles
	c.lwsp ra, 0				# get return address from stack
	c.addi sp, 4				# pop stack

	c.jr ra						# return to calling function


# use "13 NOPs". This is not used for forwarding or other hazards within the core.
# rather, it's used to allow the protocol controller (mcont.v) to be able
# to read from UART Input control & UART Data In at least once
nop_13:
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
	c.jr ra					# jump back to return address