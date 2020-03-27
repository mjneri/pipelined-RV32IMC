# test program to see if transactions are initiated correctly
init:
addi sp, x0, 0x400		# address of PROTOCOLMEM
slli sp, sp, 2	#from c.slli sp, 2
addi s0, x0, 0	#from c.li s0, 0				# s0 serves as x0 for some compressed instructions

main:
# Writing to SPI Data In & Input control
lui a0, 0xade1b
addi a0, a0, 0x055	# data = 0xade1b055
sw a0, 4(s0)	#from c.sw a0, 1(s0)		# SPI Data In

addi a0, x0, 0x1b1	# prescale for SCK = 115,200bps
slli a0, a0, 8	#from c.slli a0, 8		# shift to prescale field
xori a0, a0, 0x3	# turn on & enable SPI
sw a0, 8(s0)	#from c.sw a0, 2(s0)		# SPI Input Control 1

# Writing to UART Data In & Input control
lui a0, 0xc0e19
addi t1, x0, 0x400
slli t1, t1, 1	#from c.slli t1, 1
add a0, a0, t1	#from c.add a0, t1		# data = 0xc0e19800
sw a0, 12(s0)	#from c.sw a0, 3(s0)		# UART Data In

addi a0, x0, 0x1b2	# baudcontrol for 115200 bps
slli a0, a0, 8	#from c.slli a0, 8		# shift to baudcontrol field
xori a0, a0, 1		# enable UART
sw a0, 16(s0)	#from c.sw a0, 4(s0)		# UART Input Control

# Writing to I2C Data In & Input Control
lui a0, 0xeee19
addi a0, a0, 0x700	# data = 0xeee19700
sw a0, 20(s0)	#from c.sw a0, 5(s0)		# I2C Data In

addi a0, x0, 54		# prescale for SCL = 115,200 bps
slli a0, a0, 16	#from c.slli a0, 16		# shift to prescale field
xori a0, a0, 5		# start write
sw a0, 24(s0)	#from c.sw a0, 6(s0)		# I2C Input Control

inf:
jal x0, inf	#from c.j inf
