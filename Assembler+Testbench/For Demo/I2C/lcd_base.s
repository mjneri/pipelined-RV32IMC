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
#		a0 -> I2C Output control
#		sp -> stack pointer, pointing to word address 0x3FF
#		gp -> points to word address 0x400 (PROTOCOLMEM)
.data 0x1C
.ascii "    "		# 0x1c
.ascii " RV3"		# 0x20
.ascii "2IMC"		# 0x24
.ascii "    "		# 0x28
.ascii "    "		# 0x2c
.ascii "Proc"		# 0x30
.ascii "esso"		# 0x34
.ascii "r   "		# 0x38

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

lcd_setup:
# Refer to pg. 46 of https://www.sparkfun.com/datasheets/LCD/HD44780.pdf
# on how to setup an LCD in 4-bit mode.
# NOTE: Sent data bits in I2C correspond to the following pins:
# <D7,D6,D5,D4,Backlight,E,R/W,RS>
# Registers used:
# s1 -> command to be sent
# s2 -> # of bytes sent
# s3 -> slave address
addi s2, x0, 1				# # of bytes to send
addi s3, x0, 0x27			# slave address of i2c

jal x1, delay_20ms	#from c.jal delay_20ms			# 20ms delay

addi s1, x0, 0x38			# function set 1
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_5ms	#from c.jal delay_5ms				# 5ms delay

addi s1, x0, 0x38			# function set 2
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x38			# function set 3
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x28			# function set 4
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

# Send commands
addi s1, x0, 0x28			# function set high
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x88			# function set low
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x08			# display_off high
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x88			# display off low
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x08			# clear high
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 18				# clear low
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_20ms	#from c.jal delay_20ms

addi s1, x0, 0x08			# entry mode set high
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x68			# entry mode set low
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x08			# display on high
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0xf8			# display on low
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay
# LCD is ready; send strings now

lcd_print:
# NOTE: Sent data bits in I2C correspond to the following pins:
# <D7,D6,D5,D4,Backlight,E,R/W,RS>
# Registers used:
# s1 -> command to be sent
# s2 -> # of bytes sent
# s3 -> slave address
# s4 -> higher order bits
# s5 -> lower order bits
# s6 -> loop index
# s7 -> loop limit1
# s8 -> loop limit2
# s9 -> data address of string
addi s6, x0, 0	#from c.li s6, 0					# initialize s6 to 0
addi s7, x0, 16	#from c.li s7, 16					# loop limit 1
addi s8, x0, 32				# loop limit 2
addi s9, x0, 0x1c	#from c.li s9, 0x1c				# s9 points to string in datamem

addi s2, x0, 1				# # of bytes to send
addi s3, x0, 0x27			# slave address of i2c

lcd_print_loop1:
# send first line to LCD
# send high order bits
lbu s4, 0(s9)				# load character from datamem
andi s4, s4, 0xf0			# take high bits
ori s4, s4, 0x09			# assert Backlight & RS

addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s4, 0(x2)	#from c.swsp s4, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

# send low order bits
lbu s5, 0(s9)				# load character from datamem
andi s5, s5, 0x0f			# take low bits
slli s5, s5, 4	#from c.slli s5, 4				# shift left 4 bits to D<7:4>
ori s5, s5, 0x09			# assert Backlight & RS

addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s5, 0(x2)	#from c.swsp s5, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay_20ms

addi s6, s6, 1	#from c.addi s6, 1				# increment loop index
addi s9, s9, 1	#from c.addi s9, 1				# increment data address pointer
bltu s6, s7, lcd_print_loop1# if loop index < 16, loop again

# Send SETDDRAM command
addi s1, x0, 0xc8			# SETDDRAM to 0x40 high
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi s1, x0, 0x08			# SETDDRAM to 0x40 low
addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s1, 0(x2)	#from c.swsp s1, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

lcd_print_loop2:
# send line 2 to LCD
# send high order bits
lbu s4, 0(s9)				# load character from datamem
andi s4, s4, 0xf0			# take high bits
ori s4, s4, 0x09			# assert Backlight & RS

addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s4, 0(x2)	#from c.swsp s4, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

# send low order bits
lbu s5, 0(s9)				# load character from datamem
andi s5, s5, 0x0f			# take low bits
slli s5, s5, 4	#from c.slli s5, 4				# shift left 4 bits to D<7:4>
ori s5, s5, 0x09			# assert Backlight & RS

addi sp, sp, -8	#from c.addi sp, -8				# push lcd_pulse_en args to stack
sw s5, 0(x2)	#from c.swsp s5, 0				# command
sw s3, 4(x2)	#from c.swsp s3, 1				# slave address
jal x1, lcd_pulse_en	#from c.jal lcd_pulse_en			# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay_20ms

addi s6, s6, 1	#from c.addi s6, 1				# increment loop index
addi s9, s9, 1	#from c.addi s9, 1				# increment data address pointer
bltu s6, s8, lcd_print_loop2# if loop index < 32, loop again

inf:
jal x0, inf	#from c.j inf

# =======================================
# SUBROUTINES
# =======================================
i2c_send:
# Register usage:
# a0 -> I2C Busy if asserted
# equivalent: void i2c_send (int data, int byte_amt, int slave_addr)
lw t0, 0(x2)	#from c.lwsp t0, 0				# get data to be sent
lw t1, 4(x2)	#from c.lwsp t1, 1				# get # of bytes to be sent
lw t2, 8(x2)	#from c.lwsp t2, 2				# get slave address
addi sp, sp, 12	#from c.addi sp, 12				# pop stack

# Setting I2C Input control
# Check first if a transaction is still in progress
i2c_wait1:
bne a0, x0, i2c_wait1		# if I2C is busy, wait here. ISR will clear a0 once I2C is done executing

sw t0, 0x14(x0)				# store data in I2C Data In

add t3, x0, t1	#from c.mv t3, t1					# copy t1 to t3
slli t3, t3, 11	#from c.slli t3, 11				# shift to #BYTES field
add t4, x0, t2	#from c.mv t4, t2					# copy slave address to t4
slli t4, t4, 4	#from c.slli t4, 4				# shift to slave address field
or t3, t3, t4				# combine #BYTES & Slave address into t3

addi t3, t3, 5	#from c.addi t3, 5				# WRITE = 1, START = 1
sw t3, 0x18(x0)				# store to I2C Input control

addi sp, sp, -4	#from c.addi sp, -4				# push stack
sw ra, 0(x2)	#from c.swsp ra, 0				# store return address to stack
jal x1, nop_13	#from c.jal nop_13				# 13 cycle NOP

xori t3, t3, 5				# WRITE = 0, START = 0
sw t3, 0x18(x0)				# store to I2C Input control

jal x1, nop_13	#from c.jal nop_13
lw ra, 0(x2)	#from c.lwsp ra, 0				# get return address from stack
addi sp, sp, 4	#from c.addi sp, 4				# pop stack

lw a0, 0x18(gp)				# load I2C output control
andi a0, a0, 1	#from c.andi a0, 1				# update BUSY field

i2c_wait2:
bne a0, x0, i2c_wait2		# wait until I2C transaction finishes

jalr x0, ra, 0	#from c.jr ra

lcd_pulse_en:
# equivalent: void lcd_pulse_en(int data, int slave_addr)
lw t0, 0(x2)	#from c.lwsp t0, 0				# get data to be sent
lw t1, 4(x2)	#from c.lwsp t1, 1				# get slave address
addi sp, sp, 8	#from c.addi sp, 8				# pop stack

ori t2, t0, 0x04			# assert E
addi t3, x0, 1	#from c.li t3, 1					# send 1 byte only

addi sp, sp, -24	#from c.addi sp, -24				# push to stack
sw t2, 0(x2)	#from c.swsp t2, 0				# pass data to be sent to i2c_send
sw t3, 4(x2)	#from c.swsp t3, 1				# pass #Bytes to i2c_send
sw t1, 8(x2)	#from c.swsp t1, 2				# pass slave address to i2c_send
sw t0, 12(x2)	#from c.swsp t0, 3				# preserve data passed to lcd_pulse_en
sw t1, 16(x2)	#from c.swsp t1, 4				# preserve slave address
sw ra, 20(x2)	#from c.swsp ra, 5				# store return address to stack
jal x1, i2c_send	#from c.jal i2c_send				# call i2c_send()
jal x1, delay_100us	#from c.jal delay_100us			# call delay_100us()

lw t0, 0(x2)	#from c.lwsp t0, 0				# get preserved data back from stack
lw t1, 4(x2)	#from c.lwsp t1, 1				# get preserved slave address
addi sp, sp, 8	#from c.addi sp, 8				# pop stack

andi t2, t0, 0xfb			# deassert E
addi t3, x0, 1	#from c.li t3, 1					# send 1 byte only

addi sp, sp, -12	#from c.addi sp, -12				# push to stack
sw t2, 0(x2)	#from c.swsp t2, 0				# pass data to be sent to i2c_send
sw t3, 4(x2)	#from c.swsp t3, 1				# pass #Bytes to i2c_send
sw t1, 8(x2)	#from c.swsp t1, 2				# pass slave address
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
