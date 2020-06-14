# test program to see if transactions are initiated correctly
# a0 = Input control
# a1 = data to be sent

init:
	addi sp, x0, 0x400		# address of PROTOCOLMEM
	c.slli sp, 2
	c.li s0, 0				# s0 = x0 for compressed instructions

uart_transact:
	# Settings: 115200bps, even parity, 2 stop bits
	# Send data: 0xdc
	addi a0, x0, 433		# 115200 bps
	c.slli a0, 8			# shift to baudcontrol field
	c.addi a0, 10			# STOPSEL = 1, PARITY = 1
	c.sw a0, 4(s0)			# store to input control

	addi a1, x0, 0xdc		# data to be sent
	c.sw a1, 3(s0)			# store to data in

	c.addi a0, 1			# set EN = 1
	c.sw a0, 4(s0)			# store back to input control
	c.jal nop_13			# NOP 13

	c.addi a0, -1 			# set EN = 0
	c.sw a0, 4(s0)			# store back to input control
	c.jal nop_13			# NOP 13

	c.li a0, 0				# Reset a0 & a1 contents
	c.li a1, 1

spi_transact:
	# Settings: 100kbps, cpha = 1, cpol = 1, ss = 0x2, ord = 0
	# Send data: 0xade1
	addi a0, x0, 124		# 100kbps
	c.slli a0, 8			# shift to prescale field
	c.addi a0, 0xC			# ORD=0, CPHA=1, CPOL=1
	c.addi a0, 2			# ON = 1

	addi a1, x0, 0xad
	c.slli a1, 8
	ori a1, a1, 0xe1		# data = 0xade1
	c.sw a1, 1(s0)			# store to data in

	ori a0, a0, 0x40		# set SS = 0x2
	c.addi a0, 1			# set EN = 1
	c.sw a0, 2(s0)			# store to input control
	c.jal nop_13

	c.addi a0, -1			# set EN = 0
	c.sw a0, 2(s0)			# store to input control
	c.jal nop_13

	c.li a0, 0				# Reset a0 & a1 contents
	c.li a1, 0

i2c_transact:
	# settings: 100kbps, send 4 bytes, slave addr = 0x5a, data = 0xdeadb6ef (will be received as 0xefb6adde)
	addi a0, x0, 124		# 100kbps prescale
	c.slli a0, 16			# shift to prescale field
	c.addi a0, 8			# SETPRESCALE = 1
	c.addi a0, 1			# START = 1
	c.sw a0, 6(s0)			# store to input control
	c.jal nop_13

	xori a0, a0, 9			# SETPRESCALE = 0, START = 0
	c.sw a0, 6(s0)			# store to input control
	lui a1, 0xdeadb
	ori a1, a1, 0x6ef
	c.sw a1, 5(s0)			# store to data in

	lui a0, 0x00002			# # BYTES = 4
	ori a0, a0, 0x5A0		# Set Slave address
	c.addi a0, 4			# WRITE = 1
	# c.addi a0, 2			# READ = 1
	c.addi a0, 1			# START = 1
	c.sw a0, 6(s0)			# store to input control
	c.jal nop_13

	xori a0, a0, 5			# WRITE = 0, START = 0
	# xori a0, a0, 3			# READ = 0, START = 0
	c.sw a0, 6(s0)			# store to input control

	c.li a0, 0				# Reset a0 & a1 contents
	c.li a1, 0

inf:
	c.j inf

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