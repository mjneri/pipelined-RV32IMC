# test program to see if transactions are initiated correctly
init:
addi sp, x0, 0x400		# address of PROTOCOLMEM
slli sp, sp, 2	#from c.slli sp, 2

main:
# Writing to SPI Data In & Input control
lui t0, 0xade1b
addi t0, t0, 0x055
sw t0, 4(x0)	# SPI Data In

addi t0, x0, 0x3e8
slli t0, t0, 8	#from c.slli t0, 8
addi t0, t0, 0xc	#from c.addi t0, 0xc		# prescale
xori t0, t0, 0x2	# turn on
sw t0, 8(x0)		# SPI Input control 1

# Writing to UART Data In & Input control
lui t0, 0xc0e19
addi t1, x0, 0x400
slli t1, t1, 1	#from c.slli t1, 1
add t0, t0, t1	#from c.add t0, t1
sw t0, 12(x0)		# UART Data In

addi t0, x0, 0x4b0
slli t0, t0, 3	#from c.slli t0, 3
slli t0, t0, 8	#from c.slli t0, 8
xori t0, t0, 1
sw t0, 16(x0)		# UART Input Control

# Writing to I2C Data In & Input Control
lui t0, 0xeee19
addi t0, t0, 0x700
sw t0, 20(x0)		# I2C Data In

addi t0, x0, 0x22	# prescale
sw t0, 24(x0)		# I2C Input Control

inf:
jal x0, inf	#from c.j inf
