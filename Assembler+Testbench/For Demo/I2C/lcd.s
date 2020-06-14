# This program is used to demonstrate functionality of the I2C protocol
# w/ the RV32IMC processor.
# ==================================================
# LCD: data sent is in the format: <D7, D6, D5, D4, Backlight, E, R/W, RS>
# ==================================================
# This program writes the following to the LCD:
# ==================
# |     RV32IMC    |
# |    Processor   |
# ==================
#
# Register usage:
#		s0 -> x0 for compressed instructions
#		s1 -> I2C Output control
#		sp -> stack pointer, pointing to word address 0x3FF
#		gp -> points to word address 0x400 (PROTOCOLMEM)
.data 0x1C
	.ascii "RV32"		# 0x1c
	.ascii "IMC"		# 0x20
	
.data 0x30
	.ascii "Proc"		# 0x30
	.ascii "esso"		# 0x34
	.ascii "r"			# 0x38

.text
init:
	addi sp, x0, 0x3FF			# stack pointer address
	c.slli sp, 2
	addi gp, x0, 0x400			# point to PROTOCOLMEM
	c.slli gp, 2
	c.li s0, 0					# s0 = x0 for compressed instructions

i2c_setup:
	# Settings: 100kbps
	addi t0, x0, 124			# 100kbps prescale
	c.slli t0, 16				# shift to prescale field
	c.addi t0, 9				# SETPRESCALE = 1, START = 1
	sw t0, 0x18(x0)				# store to I2C Input Control
	c.jal nop_13
	xori t0, t0, 9				# SETPRESCALE = 0, START = 0
	sw t0, 0x18(x0)				# store back to input control

lcd_init:
	# Refer to pg. 46 of https://www.sparkfun.com/datasheets/LCD/HD44780.pdf
	# on how to setup an LCD in 4-bit mode.
	# NOTE: Sent data bits in I2C correspond to the following pins:
	# <D7,D6,D5,D4,Backlight,E,R/W,RS>
	# when calling lcd_send: a2 = data, a3 = slave_addr
	c.jal delay_20ms			# 20ms delay

	addi a2, x0, 0x38			# function set 1
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_5ms				# 5ms delay

	addi a2, x0, 0x38			# function set 2
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x38			# function set 3
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x28			# function set 4
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	# Send commands
	addi a2, x0, 0x28			# function set high
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x88			# function set low
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x08			# display_off high
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x88			# display off low
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x08			# clear high
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x18			# clear low
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_20ms			# 20ms delay

	addi a2, x0, 0x08			# entry mode set high
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x68			# entry mode set low
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x08			# display on high
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0xf8			# display on low
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_1s				# 1s delay
	# LCD is ready; send strings now

lcd_print:
	# NOTE: Sent data bits in I2C correspond to the following pins:
	# <D7,D6,D5,D4,Backlight,E,R/W,RS>
	# Registers used:
	# t0 -> loop index
	# t1 -> loop limit
	# a2-a3 -> args for lcd_send (data & slave_addr)

	# Send SETDDRAM command to 0x05
	addi a2, x0, 0x88			# SETDDRAM to 0x05 high
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x58			# SETDDRAM to 0x05 low
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	c.li t0, 0					# initialize t0
	c.li t1, 7					# loop limit 1; print "RV32IMC"

	lcd_print_line1:
		# send first line to LCD
		# send high order bits
		lbu a2, 0x1c(t0)			# load character from datamem
		andi a2, a2, 0xf0			# take high bits
		ori a2, a2, 0x09			# assert Backlight & RS
		addi a3, x0, 0x27			# slave address of i2c

		c.addi sp, -8				# store t0 & t1 to stack
		c.swsp t0, 0
		c.swsp t1, 1

		c.jal lcd_send				# pulse E
		c.jal delay_100us			# 100us delay

		c.lwsp t0, 0				# load t0 & t1 from stack
		c.lwsp t1, 1
		c.addi sp, 8

		# send low order bits
		lbu a2, 0x1c(t0)			# load character from datamem
		andi a2, a2, 0x0f			# take low bits
		c.slli a2, 4				# shift left 4 bits to D<7:4>
		ori a2, a2, 0x09			# assert Backlight & RS
		addi a3, x0, 0x27			# slave address of i2c

		c.addi sp, -8				# store t0 & t1 to stack
		c.swsp t0, 0
		c.swsp t1, 1

		c.jal lcd_send				# pulse E
		c.jal delay_100us			# 100us delay

		c.lwsp t0, 0				# load t0 & t1 from stack
		c.lwsp t1, 1
		c.addi sp, 8

		c.addi t0, 1				# increment loop index
		bltu t0, t1, lcd_print_line1# if loop index < limit, loop again
	
	# Send SETDDRAM command to 0x44
	addi a2, x0, 0xc8			# SETDDRAM to 0x40 high
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	addi a2, x0, 0x48			# SETDDRAM to 0x40 low
	addi a3, x0, 0x27			# slave address of i2c
	c.jal lcd_send				# pulse E
	c.jal delay_100us			# 100us delay

	# Reinitialize t0 & t1
	c.li t0, 0					# loop index
	c.li t1, 9					# loop limit; print "Processor"
	
	lcd_print_line2:
		# send line 2 to LCD
		# send high order bits
		lbu a2, 0x30(t0)
		andi a2, a2, 0xf0
		ori a2, a2, 0x9
		addi a3, x0, 0x27

		c.addi sp, -8				# store t0 & t1 to stack
		c.swsp t0, 0
		c.swsp t1, 1

		c.jal lcd_send				# pulse E
		c.jal delay_100us			# 100us delay

		c.lwsp t0, 0				# load t0 & t1 from stack
		c.lwsp t1, 1
		c.addi sp, 8

		# send low order bits
		lbu a2, 0x30(t0)
		andi a2, a2, 0x0f
		c.slli a2, 4
		ori a2, a2, 0x9
		addi a3, x0, 0x27

		c.addi sp, -8				# store t0 & t1 to stack
		c.swsp t0, 0
		c.swsp t1, 1

		c.jal lcd_send				# pulse E
		c.jal delay_100us			# 100us delay

		c.lwsp t0, 0				# load t0 & t1 from stack
		c.lwsp t1, 1
		c.addi sp, 8

		c.addi t0, 1				# increment loop index
		bltu t0, t1, lcd_print_line2# if loop index < limit, loop again

inf:
	c.j inf

# =======================================
# SUBROUTINES
# =======================================
i2c_send:
	# Register usage:
	# s1 -> I2C Busy if asserted
	# equivalent: void i2c_send (int data, int byte_amt, int slave_addr)
	# args: a2 = data, a3 = byte amt, a4 = slave_addr

	# Check first if a transaction is still in progress
	lw s1, 0x18(gp)				# load I2C output control
	c.andi s1, 1				# get BUSY field

	i2c_wait1:
	bne s1, x0, i2c_wait1		# if I2C is busy, wait here. ISR will clear s1 once I2C is done executing

	# Setting I2C Input control
	sw a2, 0x14(x0)				# store data in I2C Data In

	c.mv t3, a3					# copy a3 to t3
	c.slli t3, 11				# shift to #BYTES field
	c.mv t4, a4					# copy slave address to t4
	c.slli t4, 4				# shift to slave address field
	or t3, t3, t4				# combine #BYTES & Slave address into t3

	c.addi t3, 5				# WRITE = 1, START = 1
	sw t3, 0x18(x0)				# store to I2C Input control

	c.addi sp, -4				# push stack
	c.swsp ra, 0				# store return address to stack
	c.jal nop_13				# 13 cycle NOP
	c.lwsp ra, 0				# load ra
	c.addi sp, 4				# pop stack

	xori t3, t3, 5				# WRITE = 0, START = 0
	sw t3, 0x18(x0)				# store to I2C Input control

	c.addi sp, -4				# push stack
	c.swsp ra, 0				# store ra to stack
	c.jal nop_13
	c.lwsp ra, 0				# get return address from stack
	c.addi sp, 4				# pop stack

	# Don't return until transaction is finished
	lw s1, 0x18(gp)				# load I2C output control
	c.andi s1, 1				# get BUSY field
	i2c_wait2:
	bne s1, x0, i2c_wait2		# if I2C is busy, wait here. ISR will clear s1 once I2C is done executing

	c.jr ra

lcd_send:
	# equivalent: void lcd_send(int data, int slave_addr)
	# sends a command to the LCD, making sure E input to LCD is pulsed
	# args: data = a2; slave_addr = a3

	# Set args to be sent to i2c_send()
	ori a2, a2, 0x04			# assert E in data bits
	c.mv a4, a3					# copy a3(slave_addr) to a4(slave_addr of i2c_send)
	c.li a3, 1					# send 1 byte only
	
	c.addi sp, -12				# push to stack
	c.swsp a2, 0				# preserve data passed to lcd_send
	c.swsp a4, 1				# preserve slave address
	c.swsp ra, 2				# store return address to stack

	c.jal i2c_send				# call i2c_send()
	c.jal delay_100us			# call delay_100us()

	# Set args to be sent to i2c_send()
	c.lwsp a2, 0				# get preserved data back from stack
	c.lwsp a4, 1				# get preserved slave address
	c.addi sp, 8				# pop stack

	andi a2, a2, 0xfb			# deassert E
	c.li a3, 1					# send 1 byte only
	
	c.jal i2c_send				# call i2c_send()
	c.jal delay_100us			# call delay_100us()

	c.lwsp ra, 0				# get return address from the stack
	c.addi sp, 4				# pop stack
	c.jr ra

delay_100us:
	# Formula: (50MHz * delay)/2
	addi t0, x0, 0x4e2
	c.slli t0, 1

	delay_100us_loop:
	c.addi t0, -1				# decrement
	bne t0, x0, delay_100us_loop# if constant is not yet 0, keep looping
	
	c.jr ra						# return to caller

delay_5ms:
	# Formula: (50MHz * delay)/2
	lui t0, 0x1e848
	srli t0, t0, 12

	delay_5ms_loop:
	c.addi t0, -1				# decrement
	bne t0, x0, delay_5ms_loop	# if constant is not yet 0, keep looping
	
	c.jr ra						# return to caller

delay_20ms:
	# Formula: (50MHz * delay)/2
	lui t0, 0x7a120
	srli t0, t0, 12

	delay_20ms_loop:
	c.addi t0, -1				# decrement
	bne t0, x0, delay_20ms_loop	# if constant is not yet 0, keep looping
	
	c.jr ra						# return to caller

delay_1s:
	# Formula: (50MHz * delay)/2
	lui t0, 0xbeb61
	srli t0, t0, 8

	delay_1s_loop:
	c.addi t0, -1
	bne t0, x0, delay_1s_loop

	c.jr ra

# use "13 NOPs". This is not used for forwarding or other hazards within the core.
# rather, it's used to allow the protocol controller (mcont.v) to be able
# to read from Input Control & Data in at least once
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