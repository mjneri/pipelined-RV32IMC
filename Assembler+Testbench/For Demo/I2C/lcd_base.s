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
.ascii "Abcd"		# 0x30
.ascii "efgh"		# 0x34
.ascii "i"			# 0x38

.text
init:
addi sp, x0, 0x3FF			# stack pointer address
slli sp, sp, 2	#from c.slli sp, 2
addi gp, x0, 0x400			# point to PROTOCOLMEM
slli gp, gp, 2	#from c.slli gp, 2
addi s0, x0, 0	#from c.li s0, 0					# s0 = x0 for compressed instructions

i2c_setup:
# Settings: 100kbps
addi t0, x0, 124			# 100kbps prescale
slli t0, t0, 16	#from c.slli t0, 16				# shift to prescale field
addi t0, t0, 9	#from c.addi t0, 9				# SETPRESCALE = 1, START = 1
sw t0, 0x18(x0)				# store to I2C Input Control
jal x1, nop_13	#from c.jal nop_13
xori t0, t0, 9				# SETPRESCALE = 0, START = 0
sw t0, 0x18(x0)				# store back to input control

lcd_init:
# Refer to pg. 46 of https://www.sparkfun.com/datasheets/LCD/HD44780.pdf
# on how to setup an LCD in 4-bit mode.
# NOTE: Sent data bits in I2C correspond to the following pins:
# <D7,D6,D5,D4,Backlight,E,R/W,RS>
# when calling lcd_send: a2 = data, a3 = slave_addr
jal x1, delay_20ms	#from c.jal delay_20ms			# 20ms delay

addi a2, x0, 0x38			# function set 1
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_5ms	#from c.jal delay_5ms				# 5ms delay

addi a2, x0, 0x38			# function set 2
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x38			# function set 3
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x28			# function set 4
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

# Send commands
addi a2, x0, 0x28			# function set high
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x88			# function set low
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x08			# display_off high
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x88			# display off low
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x08			# clear high
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x18				# clear low
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_20ms	#from c.jal delay_20ms			# 20ms delay

addi a2, x0, 0x08			# entry mode set high
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x68			# entry mode set low
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x08			# display on high
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0xf8			# display on low
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_1s	#from c.jal delay_1s				# 1s delay
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
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x58			# SETDDRAM to 0x05 low
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi t0, x0, 0	#from c.li t0, 0					# initialize t0
addi t1, x0, 7	#from c.li t1, 7					# loop limit 1; print "RV32IMC"

lcd_print_line1:
# send first line to LCD
# send high order bits
lbu a2, 0x1c(t0)			# load character from datamem
andi a2, a2, 0xf0			# take high bits
ori a2, a2, 0x09			# assert Backlight & RS
addi a3, x0, 0x27			# slave address of i2c

addi sp, sp, -8	#from c.addi sp, -8				# store t0 & t1 to stack
sw t0, 0(x2)	#from c.swsp t0, 0
sw t1, 4(x2)	#from c.swsp t1, 1

jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

lw t0, 0(x2)	#from c.lwsp t0, 0				# load t0 & t1 from stack
lw t1, 4(x2)	#from c.lwsp t1, 1
addi sp, sp, 8	#from c.addi sp, 8

# send low order bits
lbu a2, 0x1c(t0)			# load character from datamem
andi a2, a2, 0x0f			# take low bits
slli a2, a2, 4	#from c.slli a2, 4				# shift left 4 bits to D<7:4>
ori a2, a2, 0x09			# assert Backlight & RS
addi a3, x0, 0x27			# slave address of i2c

addi sp, sp, -8	#from c.addi sp, -8				# store t0 & t1 to stack
sw t0, 0(x2)	#from c.swsp t0, 0
sw t1, 4(x2)	#from c.swsp t1, 1

jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay_20ms

lw t0, 0(x2)	#from c.lwsp t0, 0				# load t0 & t1 from stack
lw t1, 4(x2)	#from c.lwsp t1, 1
addi sp, sp, 8	#from c.addi sp, 8

addi t0, t0, 1	#from c.addi t0, 1				# increment loop index
bltu t0, t1, lcd_print_line1# if loop index < limit, loop again

# Send SETDDRAM command to 0x44
addi a2, x0, 0xc8			# SETDDRAM to 0x40 high
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x48			# SETDDRAM to 0x40 low
addi a3, x0, 0x27			# slave address of i2c
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

# Reinitialize t0 & t1
addi t0, x0, 0	#from c.li t0, 0					# loop index
addi t1, x0, 9	#from c.li t1, 9					# loop limit; print "Processor"

lcd_print_line2:
# send line 2 to LCD
# send high order bits
lbu a2, 0x30(t0)			# load character from datamem
andi a2, a2, 0xf0			# take high bits
ori a2, a2, 0x09			# assert Backlight & RS
addi a3, x0, 0x27			# slave address of i2c

addi sp, sp, -8	#from c.addi sp, -8				# store t0 & t1 to stack
sw t0, 0(x2)	#from c.swsp t0, 0
sw t1, 4(x2)	#from c.swsp t1, 1

jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

lw t0, 0(x2)	#from c.lwsp t0, 0				# load t0 & t1 from stack
lw t1, 4(x2)	#from c.lwsp t1, 1
addi sp, sp, 8	#from c.addi sp, 8

# send low order bits
lbu a2, 0x30(t0)			# load character from datamem
andi a2, a2, 0x0f			# take low bits
slli a2, a2, 4	#from c.slli a2, 4				# shift left 4 bits to D<7:4>
ori a2, a2, 0x09			# assert Backlight & RS
addi a3, x0, 0x27			# slave address of i2c

addi sp, sp, -8	#from c.addi sp, -8				# store t0 & t1 to stack
sw t0, 0(x2)	#from c.swsp t0, 0
sw t1, 4(x2)	#from c.swsp t1, 1

jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay_20ms

lw t0, 0(x2)	#from c.lwsp t0, 0				# load t0 & t1 from stack
lw t1, 4(x2)	#from c.lwsp t1, 1
addi sp, sp, 8	#from c.addi sp, 8

addi t0, t0, 1	#from c.addi t0, 1				# increment loop index
bltu t0, t1, lcd_print_line2# if loop index < limit, loop again

inf:
jal x0, inf	#from c.j inf

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
andi s1, s1, 1	#from c.andi s1, 1				# update BUSY field

i2c_wait1:
bne s1, x0, i2c_wait1		# if I2C is busy, wait here. ISR will clear s1 once I2C is done executing

# Setting I2C Input control
sw a2, 0x14(x0)				# store data in I2C Data In

add t3, x0, a3	#from c.mv t3, a3					# copy a3 to t3
slli t3, t3, 11	#from c.slli t3, 11				# shift to #BYTES field
add t4, x0, a4	#from c.mv t4, a4					# copy slave address to t4
slli t4, t4, 4	#from c.slli t4, 4				# shift to slave address field
or t3, t3, t4				# combine #BYTES & Slave address into t3

addi t3, t3, 5	#from c.addi t3, 5				# WRITE = 1, START = 1
sw t3, 0x18(x0)				# store to I2C Input control

addi sp, sp, -4	#from c.addi sp, -4				# push stack
sw ra, 0(x2)	#from c.swsp ra, 0				# store return address to stack
jal x1, nop_13	#from c.jal nop_13				# 13 cycle NOP
lw ra, 0(x2)	#from c.lwsp ra, 0				# load ra
addi sp, sp, 4	#from c.addi sp, 4				# pop stack

xori t3, t3, 5				# WRITE = 0, START = 0
sw t3, 0x18(x0)				# store to I2C Input control

addi sp, sp, -4	#from c.addi sp, -4				# push stack
sw ra, 0(x2)	#from c.swsp ra, 0				# store ra to stack
jal x1, nop_13	#from c.jal nop_13
lw ra, 0(x2)	#from c.lwsp ra, 0				# get return address from stack
addi sp, sp, 4	#from c.addi sp, 4				# pop stack

jalr x0, ra, 0	#from c.jr ra

lcd_send:
# equivalent: void lcd_send(int data, int slave_addr)
# sends a command to the LCD, making sure E input to LCD is pulsed
# args: data = a2; slave_addr = a3

# Set args to be sent to i2c_send()
ori a2, a2, 0x04			# assert E in data bits
add a4, x0, a3	#from c.mv a4, a3					# copy a3(slave_addr) to a4(slave_addr of i2c_send)
addi a3, x0, 1	#from c.li a3, 1					# send 1 byte only

addi sp, sp, -12	#from c.addi sp, -12				# push to stack
sw a2, 0(x2)	#from c.swsp a2, 0				# preserve data passed to lcd_send
sw a4, 4(x2)	#from c.swsp a4, 1				# preserve slave address
sw ra, 8(x2)	#from c.swsp ra, 2				# store return address to stack

jal x1, i2c_send	#from c.jal i2c_send				# call i2c_send()
jal x1, delay_100us	#from c.jal delay_100us			# call delay_100us()

# Set args to be sent to i2c_send()
lw a2, 0(x2)	#from c.lwsp a2, 0				# get preserved data back from stack
lw a4, 4(x2)	#from c.lwsp a4, 1				# get preserved slave address
addi sp, sp, 8	#from c.addi sp, 8				# pop stack

andi a2, a2, 0xfb			# deassert E
addi a3, x0, 1	#from c.li a3, 1					# send 1 byte only

jal x1, i2c_send	#from c.jal i2c_send				# call i2c_send()
jal x1, delay_100us	#from c.jal delay_100us			# call delay_100us()

lw ra, 0(x2)	#from c.lwsp ra, 0				# get return address from the stack
addi sp, sp, 4	#from c.addi sp, 4				# pop stack
jalr x0, ra, 0	#from c.jr ra

delay_100us:
# Formula: (50MHz * delay)/2
addi t0, x0, 0x4e2
slli t0, t0, 1	#from c.slli t0, 1

delay_100us_loop:
addi t0, t0, -1	#from c.addi t0, -1				# decrement
bne t0, x0, delay_100us_loop# if constant is not yet 0, keep looping

jalr x0, ra, 0	#from c.jr ra						# return to caller

delay_5ms:
# Formula: (50MHz * delay)/2
lui t0, 0x1e848
srli t0, t0, 12

delay_5ms_loop:
addi t0, t0, -1	#from c.addi t0, -1				# decrement
bne t0, x0, delay_5ms_loop	# if constant is not yet 0, keep looping

jalr x0, ra, 0	#from c.jr ra						# return to caller

delay_20ms:
# Formula: (50MHz * delay)/2
lui t0, 0x7a120
srli t0, t0, 12

delay_20ms_loop:
addi t0, t0, -1	#from c.addi t0, -1				# decrement
bne t0, x0, delay_20ms_loop	# if constant is not yet 0, keep looping

jalr x0, ra, 0	#from c.jr ra						# return to caller

delay_1s:
# Formula: (50MHz * delay)/2
lui t0, 0xbeb61
srli t0, t0, 8

delay_1s_loop:
addi t0, t0, -1	#from c.addi t0, -1
bne t0, x0, delay_1s_loop

jalr x0, ra, 0	#from c.jr ra

# use "13 NOPs". This is not used for forwarding or other hazards within the core.
# rather, it's used to allow the protocol controller (mcont.v) to be able
# to read from Input Control & Data in at least once
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
