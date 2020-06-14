# This test program tests the functionality of all protocol controllers
# with the RV32IMC core.
# --
# Hardware configuration:
# UART: ESP8266 running esp8266-spotify-remote.ino
# SPI: Arduino Uno w/ buttons
# I2C: LCD
# --
# Description:
# 	- The core polls the SPI device if a button has been pressed.
# 	- If a button is pressed, the core will send the corresponding command to the UART device.
# 	- The core will then wait for data from the UART device, stopping only if more than 200ms has passed between bytes received.
#	- After receiving the data, it is compared with previous data received; if they;re different, send the new string to the I2C device.
#	- The core will then go back to polling the SPI device.
# 	- Ideally, a hardware interrupt from the SPI device is connected to the FPGA, s.t. when a button is pressed, the device can
#		interrupt the core so it can start reading from the device. However, in this case, we only want to show the functionality
#		of the protocol controllers.
# --
# Register usage:
#		gp -> PROTOCOLMEM address
#		sp -> points to end of COREMEM (word addr 0x3FF)
#		s0 -> x0 for compressed instructions
#		s1 -> UART Output Control
#		s2 -> I2C Output Control
#		s3 -> SPI Output Control
#		s4 -> UART Previous Interrupt status
#		s5 -> UART Data Out
#		s6 -> I2C Data Out
#		s7 -> SPI Data Out
#		--
#		a0-a1 -> return values
#		a2-a7 -> subroutine arguments
#		t0-t6 -> local subroutine registers (not saved between calls)
#		ISR stores ax & tx registers to stack before running.

.data 0x1C

.text
init:
	addi sp, x0, 0x3FF			# Stack pointer address
	c.slli sp, 2
	addi gp, x0, 0x400			# set gp to point to PROTOCOLMEM addresses
	c.slli gp, 2
	c.li s0, 0					# s0 = 0 for compressed instructions

uart_setup:
	# Settings: 9600bps, no parity, 1 stop bit
	addi t0, x0, 0x145
	c.slli t0, 4
	c.addi t0, 7				# t0 = 5207 -> baudcontrol for 9600bps
	c.slli t0, 8				# shift to baudcontrol field
	sw t0, 0x10(x0)				# store to Input Control

spi_setup:
	# Settings: 100kbps, cpha = 0, cpol = 0 (shift@negedge, sample@posedge), ord = 0 (send MSB first)
	addi t0, x0, 124			# 100kbps prescale
	c.slli t0, 8				# shift to prescale field
	sw t0, 0x8(x0)				# store to SPI Input Control

i2c_setup:
	# Settings: 100kbps
	addi t0, x0, 124			# 100kbps prescale
	c.slli t0, 16				# shift to prescale field
	c.addi t0, 9				# SETPRESCALE = 1, START = 1
	sw t0, 0x18(x0)				# store to I2C Input Control
	c.jal nop_13
	xori t0, t0, 9				# SETPRESCALE = 0, START = 0
	sw t0, 0x18(x0)				# store back to input control

main:
	c.jal lcd_init				# initialize LCD

loop:
	# Ask Arduino which button was pressed:
	# Command format (Received from Arduino):
	# 0x10 -> no button pressed
	# 0x11 -> PLAY/PAUSE
	# 0x12 -> NEXT
	# 0x13 -> PREV
	# --
	# 0x0000 -> sent to Arduino, indicating that we want to read from it
	c.li a2, 0					# select Slave 0
	c.jal spi_read				# call spi_read(ss); a0 contains return value

	c.li t0, 0x11				# check for PLAY/PAUSE
	c.li t1, 0x12				# check for NEXT
	c.li t2, 0x13				# check for PREV

	beq a0, t0, btn_playpause
	beq a0, t1, btn_next
	beq a0, t2, btn_prev

	c.j song_check				# no buttons were pressed; wait for data from ESP8266

	btn_playpause:
	# send "PLAYPAUSE\r\n" to ESP8266

	btn_next:
	# send "NEXT\r\n" to ESP8266
	
	btn_prev:
	# send "PREV\r\n" to ESP8266

	song_check:
	# wait for data from ESP8266 to see if song changed

# ======================================================= #
#	 					SUBROUTINES						  #
# ======================================================= #

# HIGH-LEVEL SUBROUTINES
lcd_init:
	# equivalent: void lcd_init(void)
	# Refer to pg. 46 of https://www.sparkfun.com/datasheets/LCD/HD44780.pdf
	# on how to setup an LCD in 4-bit mode.
	# NOTE: Sent data bits in I2C correspond to the following pins:
	# <D7,D6,D5,D4,Backlight,E,R/W,RS>
	# when calling lcd_send: a2 = data, a3 = slave_addr
	
	# Store return address to stack first
	c.addi sp, -4
	c.swsp ra, 0

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
	c.jal delay_100us

	# Reload ra from stack
	c.lwsp ra, 0
	c.addi sp, 4

	c.jr ra						# return to calling function

lcd_print:
	# equivalent: void lcd_print(char *str)
	# sends the string to LCD
	# args: a2 = *str

# MID-LEVEL SUBROUTINES
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

i2c_send:
	# equivalent: void i2c_send (int data, int byte_amt, int slave_addr)
	# args: a2 = data, a3 = byte amt, a4 = slave_addr

	# Check first if a transaction is still in progress
	lw s2, 0x18(gp)				# load I2C output control
	andi s2, s2, 1				# get BUSY field

	i2c_wait1:
	bne s2, x0, i2c_wait1		# if I2C is busy, wait here. ISR will clear s2 once I2C is done executing

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
	lw s2, 0x18(gp)				# load I2C output control
	andi s2, s2, 1				# get BUSY field
	i2c_wait2:
	bne s2, x0, i2c_wait2		# if I2C is busy, wait here. ISR will clear s2 once I2C is done executing

	c.jr ra

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

spi_write:
	# equivalent: void spi_write(char *data, int ss)
	# args: a2 = data, a3 = ss
	# NOTE: data is 2 bytes
	# Register usage:
	# s3 -> asserted if SPI is BUSY

	# Check first if a transaction is still in progress
	lbu s3, 0x4(gp)				# load SPI Output Control
	c.li t0, 1					# for comparing w/ BUSY field

	spi_write_wait:
	beq s3, t0, spi_write_wait	# loop until SPI is not BUSY; ISR will deassert s3

	# Set data & SS
	sh a2, 0x4(x0)				# store data to SPI Data In

	c.andi a3, 0x3				# make sure to take only bit1 & bit0
	c.slli a3, 5				# shift slave select to SS field
	lw t0, 0x8(x0)				# load SPI Input Control
	andi t0, t0, -97			# set SS field to 0
	or t0, t0, a3				# insert new SS to Input control
	ori t0, t0, 3				# set ON = 1, EN = 1
	sw t0, 0x8(x0)				# store back to SPI Input Control
		
	c.li t1, 1					# for checking BUSY
	spi_write_waitbusy:			# SPI output control is polled until BUSY is asserted, so we are certain that e_clk
	lbu t0, 0x4(gp)				# has captured EN & the transaction has started.
	bne t0, t1, spi_write_waitbusy

	lw t0, 0x8(x0)				# load SPI Input control
	c.addi t0, -1				# set EN = 0
	sw t0, 0x8(x0)				# store back to SPI Input Control

	c.addi sp, -4				# push ra to stack
	c.swsp ra, 0
	c.jal nop_13
	c.lwsp ra, 0				# reload ra from stack
	c.addi sp, 4

	c.jr ra						# jump back to calling function

spi_read:
	# equivalent: int spi_read(int ss)
	# args: a2 = ss
	# return value: a0 = valid data
	# Register usage:
	# s3 -> SPI Output Control
	# s7 -> SPI Data Out
	# NOTE: when only a read is performed in a transaction, "send" 0 to the slave device

	# check if a transaction is still in progress
	lbu s3, 0x4(gp)				# load SPI Output Control
	c.li t0, 1					# for comparing w/ BUSY field

	spi_read_wait:
	beq s3, t0, spi_read_wait	# loop until BUSY is not asserted; ISR will set s3 to 0

	# set slave select & data
	sw x0, 0x4(x0)				# store 0 to SPI Data In

	c.andi a2, 0x3				# make sure to take only first two bits from arg
	c.slli a2, 5				# shift to SS field
	lw t0, 0x8(x0)				# load SPI Input Control
	andi t0, t0, -97			# set SS field to 0
	or t0, t0, a2				# insert new SS to input control
	ori t0, t0, 3				# set ON = 1, EN = 1
	sw t0, 0x8(x0)				# store back to Input control

	c.li t1, 1					# for checking BUSY
	spi_read_waitbusy:			# SPI output control is polled until BUSY is asserted, so we are certain that e_clk
	lbu t0, 0x4(gp)				# has captured EN & the transaction has started.
	bne t0, t1, spi_read_waitbusy

	lw t0, 0x8(x0)				# load SPI Input control
	c.addi t0, -1				# set EN = 0
	sw t0, 0x8(x0)				# store back to SPI Input Control

	c.addi sp, -4				# push ra to stack
	c.swsp ra, 0
	c.jal nop_13
	c.lwsp ra, 0				# reload ra from stack
	c.addi sp, 4

	# Wait until valid data is received
	lbu s3, 0x4(gp)				# load SPI output control
	c.li t0, 2					# for comparing w/ DONE field
	spi_read_datawait:
	bne s3, t0, spi_read_datawait	# wait until DONE is asserted; ISR will assert s3

	c.mv a0, s7					# load SPI Output Data as return value
	c.jr ra						# jump back to calling function

# LOW-LEVEL SUBROUTINES (Subroutines that don't call other subroutines)
strlen:
	# equivalent: unsigned int strlen(char *str)
	# args: a2 = *str
	# ret: a0 = strlen
	# in this case, strings do not end w/ '\0'. They end w/ '\r' (0x0A)
	c.li a0, 0					# loop index; equivalent: int count = 0;
	c.li t0, 0x0D				# for checking '\r'

	strlen_loop:
	# loop until char == '\r'
	lbu t1, 0(a2)				# load char
	beq t1, t0, __strlen		# keep looping while char != '\r'; if char == '\r', break from loop
	c.addi a2, 1				# increment str pointer
	c.addi a0, 1				# increment count
	c.j strlen_loop

	__strlen:
	c.jr ra						# return a0


# -- Delay subroutines --
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


# NOP 13
nop_13:
	# use 13 NOPs. This is not used for forwarding or other hazards within the core.
	# rather, it's used to allow the protocol controller (mcont.v) to be able
	# to read from Input Control & Data in at least once
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