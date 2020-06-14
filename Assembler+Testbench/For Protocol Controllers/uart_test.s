# test program for UART
init:
	addi sp, x0, 0x400		# PROTOCOLMEM addr
	c.slli sp, 2
	c.li s0, 0				# s0 = x0 for compressed instructions

uart_setup:
	addi t0, x0, 434		# 115200 bps baudrate
	c.slli t0, 8			# shift to baudcontrol field
	c.mv a0, t0				# move t0 contents to a0
	c.addi a0, 2			# even parity
	c.sw a0, 4(s0)			# store to UART Input control

# Loop until RDDONE = 1.
# check a5 for looping
uart_wait:
	c.beqz a5, uart_wait	# if a5 == 0, valid data not yet received

# send the received data back after some modifications (flip byte order)
uart_read:
	c.li a5, 0				# reset a5 to 0
	lbu a0, 0x10(sp)		# load UART Data Out
	srli t0, a0, 4			# shift MSByte of received data to LSByte field
	c.slli a0, 4			# shift LSByte to MSByte field
	c.add a0, t0			# a0 contains flipped data bytes
	c.mv a1, a0				# move data to a1
	sb a1, 0xc(x0)			# Store to UART Data In

	c.lw a0, 4(s0)			# Load input control
	c.addi a0, 1			# set EN = 1
	c.sw a0, 4(s0)			# store back to UART Input control
	c.jal nop_13			# go to nop_13 subroutine

	c.addi a0, -1			# set EN = 0
	c.sw a0, 4(s0)			# store back to UART Input control
	c.jal nop_13			# go to nop_13 subroutine
	c.j uart_wait			# go back to uart_wait

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