# test program to see if transactions are initiated correctly
# a0 = Input control
# a1 = data to be sent

init:
addi sp, x0, 0x400		# address of PROTOCOLMEM
slli sp, sp, 2	#from c.slli sp, 2
addi s0, x0, 0	#from c.li s0, 0				# s0 = x0 for compressed instructions

uart_transact:
# Settings: 115200bps, even parity, 2 stop bits
# Send data: 0xdc
addi a0, x0, 433		# 115200 bps
slli a0, a0, 8	#from c.slli a0, 8			# shift to baudcontrol field
addi a0, a0, 10	#from c.addi a0, 10			# STOPSEL = 1, PARITY = 1
sw a0, 16(s0)	#from c.sw a0, 4(s0)			# store to input control

addi a1, x0, 0xdc		# data to be sent
sw a1, 12(s0)	#from c.sw a1, 3(s0)			# store to data in

addi a0, a0, 1	#from c.addi a0, 1			# set EN = 1
sw a0, 16(s0)	#from c.sw a0, 4(s0)			# store back to input control
jal x1, nop_13	#from c.jal nop_13			# NOP 13

addi a0, a0, -1	#from c.addi a0, -1 			# set EN = 0
sw a0, 16(s0)	#from c.sw a0, 4(s0)			# store back to input control
jal x1, nop_13	#from c.jal nop_13			# NOP 13

addi a0, x0, 0	#from c.li a0, 0				# Reset a0 & a1 contents
addi a1, x0, 1	#from c.li a1, 1

spi_transact:
# Settings: 100kbps, cpha = 1, cpol = 1, ss = 0x2, ord = 0
# Send data: 0xade1
addi a0, x0, 124		# 100kbps
slli a0, a0, 8	#from c.slli a0, 8			# shift to prescale field
addi a0, a0, 0xC	#from c.addi a0, 0xC			# ORD=0, CPHA=1, CPOL=1
addi a0, a0, 2	#from c.addi a0, 2			# ON = 1
# c.sw a0, 2(s0)			# store to input control

addi a1, x0, 0xad
slli a1, a1, 8	#from c.slli a1, 8
ori a1, a1, 0xe1		# data = 0xade1
sw a1, 4(s0)	#from c.sw a1, 1(s0)			# store to data in

ori a0, a0, 0x40		# set SS = 0x2
addi a0, a0, 1	#from c.addi a0, 1			# set EN = 1
sw a0, 8(s0)	#from c.sw a0, 2(s0)			# store to input control

spi_wait_busy:			# Wait until BUSY = 1 so that we're sure that the transaction has started
lw a2, 4(x2)	#from c.lwsp a2, 1			# load Output control
beq a2, x0, spi_wait_busy	#from c.beqz a2, spi_wait_busy

addi a0, a0, -1	#from c.addi a0, -1			# set EN = 0
sw a0, 8(s0)	#from c.sw a0, 2(s0)			# store to input control
jal x1, nop_13	#from c.jal nop_13

addi a0, x0, 0	#from c.li a0, 0				# Reset a0 & a1 contents
addi a1, x0, 0	#from c.li a1, 0

i2c_transact:
# settings: 100kbps, send 4 bytes, slave addr = 0x5a, data = 0xdeadb6ef
addi a0, x0, 124		# 100kbps prescale
slli a0, a0, 16	#from c.slli a0, 16			# shift to prescale field
addi a0, a0, 8	#from c.addi a0, 8			# SETPRESCALE = 1
addi a0, a0, 1	#from c.addi a0, 1			# START = 1
sw a0, 24(s0)	#from c.sw a0, 6(s0)			# store to input control
jal x1, nop_13	#from c.jal nop_13

xori a0, a0, 9			# SETPRESCALE = 0, START = 0
sw a0, 24(s0)	#from c.sw a0, 6(s0)			# store to input control
lui a1, 0xdeadb
ori a1, a1, 0x6ef
sw a1, 20(s0)	#from c.sw a1, 5(s0)			# store to data in

lui a0, 0x00002			# # BYTES = 4
ori a0, a0, 0x5A0		# Set Slave address
addi a0, a0, 4	#from c.addi a0, 4			# WRITE = 1
addi a0, a0, 1	#from c.addi a0, 1			# START = 1
sw a0, 24(s0)	#from c.sw a0, 6(s0)			# store to input control
jal x1, nop_13	#from c.jal nop_13

xori a0, a0, 5			# WRITE = 0, START = 0
sw a0, 24(s0)	#from c.sw a0, 6(s0)			# store to input control

addi a0, x0, 0	#from c.li a0, 0				# Reset a0 & a1 contents
addi a1, x0, 0	#from c.li a1, 0

inf:
jal x0, inf	#from c.j inf

# use "13 NOPs". This is not used for forwarding or other hazards within the core.
# rather, it's used to allow the protocol controller (mcont.v) to be able
# to read from UART Input control & UART Data In at least once
nop_13:
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
jalr x0, ra, 0	#from c.jr ra					# jump back to return address
