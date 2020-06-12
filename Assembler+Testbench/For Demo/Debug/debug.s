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
#		s4 -> UART Data Out
#		s5 -> I2C Data Out (not used in this program)
#		s6 -> SPI Data Out
#		s7 -> UART data has been received
#		s11 -> WRDONE&RDDONE status of previous interrupt
#		--
#		a0-a1 -> return values
#		a2-a7 -> subroutine arguments
#		t0-t6 -> local subroutine registers (not saved between calls)
#		ISR stores ax & tx registers to stack before running.

# Strings used for sending commands to the ESP8266
.data 0x1C				# "PLAYPAUSE\r\n"
	.ascii "PLAY"		# 0x1c
	.ascii "PAUS"		# 0x20
	.ascii "E\r\n"		# 0x24

.data 0x30				# "PREV\r\n"
	.ascii "PREV"		# 0x30
	.ascii "\r\n"		# 0x34

.data 0x40				# "NEXT\r\n"
	.ascii "NEXT"		# 0x40
	.ascii "\r\n"		# 0x44

.data 0x100
	.ascii "LCD\n"		# 0x100
	.ascii "Init"		# 0x104
	.ascii "iali"		# 0x108
	.ascii "zed"		# 0x10c

.data 0x120
	.ascii "NEW "
	.ascii "SONG"

# Declaring "Global variables" (mostly just memory addresses)
# #define BUFSIZE 64 (64 bytes/16 word addresses)
# static char Rxbuffer[BUFSIZE]; (0x50 -> 0x8c)
# static char prevRx[BUFSIZE]; (0xa0 -> 0xdc)

# NOTE: for debugging purposes, delay subroutines are shortened, & prescale values are set high

.text
init:
	addi sp, x0, 0x3FF			# Stack pointer address
	c.slli sp, 2
	addi gp, x0, 0x400			# set gp to point to PROTOCOLMEM addresses
	c.slli gp, 2
	c.li s0, 0					# s0 = 0 for compressed instructions

uart_setup:
	# Settings: 1.8432Mbps, no parity, 1 stop bit
	c.li t0, 26					# 1.8432Mbps
	c.slli t0, 8
	sw t0, 0x10(x0)				# store to Input Control

spi_setup:
	# Settings: 12.5MHz, cpha = 0, cpol = 0 (shift@negedge, sample@posedge), ord = 0 (send MSB first)
	c.li t0, 0					# 12.5MHz prescale
	c.slli t0, 8				# shift to prescale field
	sw t0, 0x8(x0)				# store to SPI Input Control

i2c_setup:
	# Settings: 1MHz
	addi t0, x0, 11				# 1MHz prescale
	c.slli t0, 16				# shift to prescale field
	c.addi t0, 9				# SETPRESCALE = 1, START = 1
	sw t0, 0x18(x0)				# store to I2C Input Control
	c.jal nop_13
	xori t0, t0, 9				# SETPRESCALE = 0, START = 0
	sw t0, 0x18(x0)				# store back to input control

main:
	addi a2, x0, 0x100			# "LCD\nInitialized" Address
	c.jal lcd_print				# lcd_print(a2)
	c.jal delay

loop:
	# Ask Arduino which button was pressed:
	# Command format (Received from Arduino):
	# 0x10 -> no button pressed
	# 0x11 -> PLAY/PAUSE
	# 0x12 -> NEXT
	# 0x13 -> PREV
	# --
	# 0x00FF -> sent to Arduino, indicating that we want to read from it
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
		addi a2, x0, 0x1c		# address of "PLAYPAUSE\r\n"
		c.jal uart_write		# call uart_write(a2)
		c.j song_check

	btn_next:
		# send "NEXT\r\n" to ESP8266
		addi a2, x0, 0x40		# address of "NEXT\r\n"
		c.jal uart_write		# call uart_write(a2)
		c.j song_check
	
	btn_prev:
		# send "PREV\r\n" to ESP8266
		addi a2, x0, 0x30		# address of "PREV\r\n"
		c.jal uart_write		# call uart_write(a2)

	song_check:
		# wait for data from ESP8266 to see if song changed
		c.jal uart_read			# call uart_read()
		addi a2, x0, 0xa0		# address of prevRx
		addi a3, x0, 0x50		# address of Rxbuffer
		c.jal strcmp			# call strcmp(prevRx, Rxbuffer)
		c.beqz a0, loop			# if prevRx == Rxbuffer, go back to loop. Else, print new string to LCD
		
		c.jal lcd_clear			# clear LCD
		addi a2, x0, 0x50		# address of Rxbuffer
		# addi a2, x0, 0x120		# address of "NEW SONG"
		c.jal lcd_print			# call lcd_print(Rxbuffer)
		# c.jal uart_write		# call uart_write(a2); to confirm that processor doesnt freeze at uart_read()
		# c.jal delay_1s
		# c.jal lcd_clear
		c.j loop				# go back to start of loop

# ======================================================= #
#	 					SUBROUTINES						  #
# ======================================================= #

# HIGH-LEVEL SUBROUTINES
lcd_init: 						# equivalent: void lcd_init(void)
	# Refer to pg. 46 of https://www.sparkfun.com/datasheets/LCD/HD44780.pdf
	# on how to setup an LCD in 4-bit mode.
	# NOTE: Sent data bits in I2C correspond to the following pins:
	# <D7,D6,D5,D4,Backlight,E,R/W,RS>
	# when calling lcd_send: a2 = data, a3 = slave_addr
	
	# Store return address to stack first
	c.addi sp, -4
	c.swsp ra, 0

	c.jal delay					# 20ms delay

	addi a2, x0, 0x38			# function set 1
	c.jal lcd_send				# pulse E
	c.jal delay					# 5ms delay

	addi a2, x0, 0x38			# function set 2
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x38			# function set 3
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x28			# function set 4
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	# Send commands
	addi a2, x0, 0x28			# function set high
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x88			# function set low
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x08			# display_off high
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x88			# display off low
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x08			# clear high
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x18			# clear low
	c.jal lcd_send				# pulse E
	c.jal delay					# 20ms delay

	addi a2, x0, 0x08			# entry mode set high
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x68			# entry mode set low
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x08			# display on high
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0xf8			# display on low
	c.jal lcd_send				# pulse E
	c.jal delay		

	# Reload ra from stack
	c.lwsp ra, 0
	c.addi sp, 4
	c.jr ra						# return to calling function

lcd_print:						# equivalent: void lcd_print(char *str)
	# sends the string to LCD
	# args: a2 = *str
	# <Command bits> = <Backlight, E, RW, RS>
	c.addi sp, -4				# store ra to stack
	c.swsp ra, 0

	c.addi sp, -4
	c.swsp a2, 0				# store *str to stack
	c.jal strlen				# strlen(a2); a0 = strlen
	c.lwsp a2, 0				# reload *str from stack
	c.addi sp, 4

	c.beqz a0, lcd_print_ret	# if strlen == 0, return to caller

	c.li t0, 0					# loop index; int i = 0;
	c.mv t1, a2					# move *str to t1
	c.mv t2, a0					# move strlen to t2
	
	lcd_print_loop:				# send all characters to LCD
		lbu a2, 0(t1)			# load char to a2 (arg for char_codelcd())

		c.addi sp, -12			# store loop index, *str & strlen to stack
		c.swsp t0, 0			# loop index
		c.swsp t1, 1			# *str
		c.swsp t2, 2			# strlen

		c.jal char_codelcd		# char_codelcd(a2); a0 = ascii value
		c.mv a2, a0				# move return value to a2 (arg for lcd_send())
		c.addi sp, -4			# preserve a2 value
		c.swsp a2, 0

		# Get <D7:D4> + <Command bits> first
		lui t3, 0x00f0f
		srli t3, t3, 12			# t3 = 0x00000f0f
		and a2, a2, t3			# <D7:D4> <0,0,0,0> <Command bits>
		srli t3, a2, 8			# get <D7:D4> only
		c.slli t3, 4			# shift back to bits <7:4>
		or a2, a2, t3			# combine
		andi a2, a2, 0xff		# take 8 bits only; a2 now contains <D7:D4> <Command bits>
		c.jal lcd_send			# lcd_send(a2)

		# Get <D3:D0> + <Command bits>
		c.lwsp a2, 0			# reload preserved a2
		c.addi sp, 4			# pop stack
		andi a2, a2, 0xff		# a2 now contains <D3:D0> <Command bits>
		c.jal lcd_send			# lcd_send(a2)

		c.lwsp t0, 0			# reload from stack; loop index
		c.lwsp t1, 1			# *str
		c.lwsp t2, 2			# strlen
		c.addi sp, 12			# pop stack

		c.addi t0, 1			# increment loop index
		c.addi t1, 1			# increment *str
		bltu t0, t2, lcd_print_loop	# if loop index < strlen, loop again

	lcd_print_ret:
	c.lwsp ra, 0				# load ra from stack
	c.addi sp, 4
	c.jr ra						# return

lcd_clear:						# equivalent: void lcd_clear(void)
	# Store ra to stack
	c.addi sp, -4
	c.swsp ra, 0

	addi a2, x0, 0x08			# clear high
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x18			# clear low
	c.jal lcd_send				# pulse E
	c.jal delay					# 20ms delay

	# Load ra from stack
	c.lwsp ra, 0
	c.addi sp, 4
	c.jr ra						# return

lcd_returnhome:					# equivalent: void lcd_returnhome(void)
	# Store ra to stack
	c.addi sp, -4
	c.swsp ra, 0

	addi a2, x0, 0x08			# return home high
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	addi a2, x0, 0x28			# return home low
	c.jal lcd_send				# pulse E
	c.jal delay					# 100us delay

	# Load ra from stack
	c.lwsp ra, 0
	c.addi sp, 4
	c.jr ra						# return

# MID-LEVEL SUBROUTINES
lcd_send:						# equivalent: void lcd_send(uint_8 data)
	# sends a command to the LCD, making sure E input to LCD is pulsed
	# args: data = a2
	# Set args to be sent to i2c_write()
	ori a2, a2, 0x04			# assert E in data bits
	c.li a3, 1					# send 1 byte only
	addi a4, x0, 0x27			# slave_addr of LCD
	
	c.addi sp, -12				# push to stack
	c.swsp a2, 0				# preserve data passed to lcd_send
	c.swsp a4, 1				# preserve slave address
	c.swsp ra, 2				# store return address to stack

	c.jal i2c_write				# call i2c_write()
	c.jal delay					# call delay_100us()

	# Set args to be sent to i2c_write()
	c.lwsp a2, 0				# get preserved data back from stack
	c.lwsp a4, 1				# get preserved slave address
	c.addi sp, 8				# pop stack

	andi a2, a2, 0xfb			# deassert E
	c.li a3, 1					# send 1 byte only
	
	c.jal i2c_write				# call i2c_write()
	c.jal delay					# call delay_100us()

	c.lwsp ra, 0				# get return address from the stack
	c.addi sp, 4				# pop stack
	c.jr ra

i2c_write: 						# equivalent: void i2c_write (int data, int byte_amt, int slave_addr)
	# args: a2 = data, a3 = byte amt, a4 = slave_addr
	# Check first if a transaction is still in progress
	lw s2, 0x18(gp)				# load I2C output control
	c.li t0, 1					# for comparing w/ BUSY field
	i2c_wait1:
	beq s2, t0, i2c_wait1		# if I2C is busy, wait here. ISR will update s2 once I2C is done executing

	# Setting I2C Input control
	sw a2, 0x14(x0)				# store data in I2C Data In

	c.mv t3, a3					# copy a3 to t3
	c.slli t3, 11				# shift to #BYTES field
	c.mv t4, a4					# copy slave address to t4
	c.slli t4, 4				# shift to slave address field
	or t3, t3, t4				# combine #BYTES & Slave address into t3

	c.addi t3, 5				# WRITE = 1, START = 1
	sw t3, 0x18(x0)				# store to I2C Input control

	lw s2, 0x18(gp)				# load I2C output control
	c.li t0, 1					# for comparing w/ BUSY field
	i2c_wait2:
	bne s2, t0, i2c_wait2		# wait until BUSY asserts. ISR will update s2 once I2C starts transmission

	xori t3, t3, 5				# WRITE = 0, START = 0
	sw t3, 0x18(x0)				# store to I2C Input control

	# Don't return until transaction is finished
	lw s2, 0x18(gp)				# load I2C output control
	c.li t0, 1					# for comparing w/ BUSY field
	i2c_wait3:
	beq s2, t0, i2c_wait3		# if I2C is busy, wait here. ISR will update s2 once I2C is done executing

	c.jr ra

uart_write: 					# equivalent: void uart_write(char *str); Args: a2 = char *str
	# Subroutine that sends a string to UART Transmit buffer. UART sends automatically start after
	c.addi sp, -4				# push to stack
	c.swsp ra, 0				# store return address to stack

	# get strlen(str)
	c.addi sp, -4
	c.swsp a2, 0				# preserve *str
	c.jal strlen				# call strlen(str); a0 = strlen
	c.lwsp a2, 0				# reload *str from stack
	c.addi sp, 4

	c.beqz a0, uart_write_ret	# if strlen == 0, return

	c.li t2, 0					# loop index; int i = 0;
	c.mv t1, a2					# move *str to t1

	uart_write_loop:			# Send char to TXBUFFER
		lhu s1, 0xc(gp)			# Check if transmit buffer is full; get TXBF&TRMT from Output control
		andi s1, s1, 0xc0		#; if TXBF is asserted, program will loop here until the ISR updates s1
		addi t3, x0, 0x40		# for checking w/ TXBF field
		uart_txbfcheck:
		beq s1, t3, uart_txbfcheck	# wait until TXBF is not asserted anymore
		
		lbu a2, 0(t1)			# load byte pointed to by *str
		c.sw a2, 3(s0)			# store to UART Data In (addr 0xC)
		
		lw t0, 0x10(x0)			# Load UART Input Control
		ori t0, t0, 1			# set EN = 1
		sw t0, 0x10(x0)			# store back to Input Control

		c.jal nop_13			# NOP for 13 cycles
		lw t0, 0x10(x0)			# Load input control
		xori t0, t0, 1			# set EN = 0
		sw t0, 0x10(x0)			# store back to input control
		c.jal nop_13			# NOP for 13 cycles

		c.addi t2, 1			# increment loop index
		c.addi t1, 1			# increment *str
		bltu t2, a0, uart_write_loop# if loop index < strlen, loop again

	# Once all bytes have been stored to TXBUFFER, return
	uart_write_ret:
	c.lwsp ra, 0				# load ra from stack
	c.addi sp, 4
	c.jr ra						# return to calling function

uart_read:						# equivalent: void uart_read(void)
	# Subroutine that reads data sent over UART & stores to memory
	# Data is saved to Rxbuffer (occupies 0x50-0x8c)
	# Before overwriting Rxbuffer, its contents are copied to prevRx (0xa0-0xdc)
	# We assume that most data received won't exceed 64 bytes, but to prevent
	# overflows, we limit data that we want to receive to just 64 bytes.
	# Register usage: 
	# s1 (UART Output Control)
	# s4 (UART Data Out)
	# s7 (UART Data has been received)
	c.addi sp, -4				# store ra to stack
	c.swsp ra, 0

	# initialize prevRx to \0; equiv: memset(prevRx, 0, sizeof(prevRx));
	c.li t0, 0					# loop index
	addi t1, x0, 64				# loop limit
	__memset_1:					# for(t0=0; t0<64; t0=t0+4)
		sw x0, 0xa0(t0)			# prevRx
		c.addi t0, 4
		bltu t0, t1, __memset_1
	
	# copy Rxbuffer contents to prevRx; equiv: strcpy(prevRx, Rxbuffer);
	c.li t0, 0					# loop index
	addi t1, x0, 64				# loop limit
	__strcpy_1:					# for(t0=0; t0<64; t0=t0+4)
		lw t2, 0x50(t0)			# load Rxbuffer
		sw t2, 0xa0(t0)			# store to prevRx
		c.addi t0, 4
		bltu t0, t1, __strcpy_1
	
	# Check if data has been received first
	beq s7, x0, uart_read_ret	# if s7==0, no data recvd yet; return to calling function
								# This is so that if no data has been received, Rxbuffer will not
								# be initialized to 0.
	
	# If data received, start storing to Rxbuffer. Keep waiting for data as long as <50ms 
	# have passed between bytes.
	# NOTE: it's the ISR's job to store recvd data to s4
	# If >50ms pass & no data is received, the subroutine will just return to caller
	# initialize Rxbuffer to \0; (memset(Rxbuffer, 0, sizeof(Rxbuffer));
	c.li t0, 0					# loop index
	addi t1, x0, 64				# loop limit
	__memset_2:					# for(t0=0; t0<64; t0=t0+4)
		sw x0, 0x50(t0)			# Rxbuffer
		c.addi t0, 4
		bltu t0, t1, __memset_2

	c.li t0, 0					# Rxbuffer[t0]; equiv: int i = 0;
	addi t1, x0, 64				# 64 byte limit
	addi t2, x0, 167			# ~10us delay; Formula: (50MHz*10us)/(3 instructions in loop)
	uart_read_rxbuffer:
		beq s7, x0, __rxbuffer	# check if data has been received; if s7==0, no data recvd yet;
		# Store recvd data to Rxbuffer
		c.li s7, 0				# reset s7 to 0
		sb s4, 0x50(t0)			# Rxbuffer[t0] = RXData;
		c.addi t0, 1			# t0++;
		
		#; if 64 bytes have been stored already, return to caller
		bgeu t0, t1, uart_read_ret

		# Reinitialize delay counter to restart the 'timer'
		addi t2, x0, 167

		__rxbuffer:
		c.addi t2, -1			# decrement; if constant > 0, keep looping
		bne t2, x0, uart_read_rxbuffer

	uart_read_ret:
	c.lwsp ra, 0				# reload ra from stack
	c.addi sp, 4
	c.jr ra						# return to calling function

spi_write: 						# equivalent: void spi_write(char *data, int ss)
	# args: a2 = data, a3 = ss
	# NOTE: data is 2 bytes
	# Register usage:
	# s3 -> SPI Output control

	# Check first if a transaction is still in progress
	lbu s3, 0x4(gp)				# load SPI Output Control
	c.li t0, 1					# for comparing w/ BUSY field

	spi_write_wait:
	beq s3, t0, spi_write_wait	# loop until SPI is not BUSY; ISR will update s3

	# Set data & SS
	sh a2, 0x4(x0)				# store data to SPI Data In

	c.andi a3, 0x3				# make sure to take only bit1 & bit0
	c.slli a3, 5				# shift slave select to SS field
	lw t0, 0x8(x0)				# load SPI Input Control
	andi t0, t0, -97			# set SS field to 0
	or t0, t0, a3				# insert new SS to Input control
	ori t0, t0, 3				# set ON = 1, EN = 1
	sw t0, 0x8(x0)				# store back to SPI Input Control
	
	lbu s3, 0x4(gp)				# load SPI Output Control
	c.li t0, 1					# for checking BUSY
	spi_write_waitbusy:			# wait until SPI has started the transaction. ISR will update s3
	bne s3, t0, spi_write_waitbusy

	lw t0, 0x8(x0)				# load SPI Input control
	c.addi t0, -1				# set EN = 0
	sw t0, 0x8(x0)				# store back to SPI Input Control

	c.jr ra						# jump back to calling function

spi_read: 						# equivalent: int spi_read(int ss)
	# args: a2 = ss
	# return value: a0 = valid data
	# Register usage:
	# s3 -> SPI Output Control
	# s6 -> SPI Data Out
	# NOTE: when only a read is performed in a transaction, "send" 0x00FF to the slave device

	# check if a transaction is still in progress
	lbu s3, 0x4(gp)				# load SPI Output Control
	c.li t0, 1					# for comparing w/ BUSY field

	spi_read_wait:
	beq s3, t0, spi_read_wait	# loop until BUSY is not asserted; ISR will update s3

	# set slave select & data
	addi t0, x0, 0xff			# 0xff
	sh t0, 0x4(x0)				# store 0x00FF to SPI Data In

	c.andi a2, 0x3				# make sure to take only first two bits from arg
	c.slli a2, 5				# shift to SS field
	lw t0, 0x8(x0)				# load SPI Input Control
	andi t0, t0, -97			# set SS field to 0
	or t0, t0, a2				# insert new SS to input control
	ori t0, t0, 3				# set ON = 1, EN = 1
	sw t0, 0x8(x0)				# store back to Input control

	lbu s3, 0x4(gp)				# load SPI Output Control
	c.li t0, 1					# for checking BUSY
	spi_read_waitbusy:			# wait until SPI has started the transaction. ISR will update s3
	bne s3, t0, spi_read_waitbusy

	lw t0, 0x8(x0)				# load SPI Input control
	c.addi t0, -1				# set EN = 0
	sw t0, 0x8(x0)				# store back to SPI Input Control

	# Wait until valid data is received
	lbu s3, 0x4(gp)				# load SPI output control
	c.li t0, 1					# for comparing w/ BUSY field
	spi_read_datawait:
	beq s3, t0, spi_read_datawait	# wait until BUSY is deasserted; ISR will update s3

	c.mv a0, s6					# load SPI Output Data as return value
	c.jr ra						# jump back to calling function

# LOW-LEVEL SUBROUTINES (Subroutines that don't call other subroutines)
strcmp:							# equivalent: int strcmp(char *str1, char *str2)
	# args: a2 = *str1, a3 = *str2
	# ret: a0 = 0 if strings are equal, 1 otherwise
	# subroutine compares strings by byte
	c.li t2, 0xd				# for checking '\r
	__strcmp_loop:
		lbu t0, 0(a2)			# load from str1
		lbu t1, 0(a3)			# load from str2

		c.li a0, 1				# set a0 = 1 in case bytes are not equal
		bne t0, t1, strcmp_ret	# if bytes are not equal, break from loop
		c.li a0, 0				# reset a0 = 0; skipped if t0!=t1
		
		beq t0, x0, strcmp_ret	# if t0=='\0', break loop
		beq t0, t2, strcmp_ret	# if t0=='\r', break loop
		beq t1, x0, strcmp_ret	# if t0=='\0', break loop
		beq t1, t2, strcmp_ret	# if t0=='\r', break loop
		
		c.addi a2, 1			# increment *str1
		c.addi a3, 1			# increment *str2
		c.j __strcmp_loop

	strcmp_ret:
	c.jr ra						# return a0;

strlen: 						# equivalent: unsigned int strlen(char *str)
	# args: a2 = *str
	# ret: a0 = strlen
	# in this case, strings can also end w/ '\r' (0x0D)
	c.li a0, 0					# loop index; equivalent: int count = 0;

	strlen_loop:
	# loop until char == '\0'
	lbu t1, 0(a2)				# load char
	beq t1, x0, __strlen		# if char =='\0', break from loop
	c.addi a2, 1				# increment str pointer
	c.addi a0, 1				# increment count
	c.j strlen_loop

	__strlen:
	c.jr ra						# return a0

char_codelcd: 					# equivalent: unsigned int char_codelcd(char c)
	# returns ASCII value of c w/ <Backlight, E, RW, RS> bits for use w/ an I2C LCD
	# args: a2 = c
	# ret: a0 = ASCII code + commands; format: <D7:D4> <D3:D0> <Backlight, E, RW, RS> 
	# Most args are expected to be in ASCII already; this function pretty much
	# converts only '\r' & '\n' to SETDDRAM commands
	addi a0, x0, 0x0A			# '\n'
	beq a2, a0, __char_code_setddram
	addi a0, x0, 0x0D			# '\r'
	beq a2, a0, __char_code_setddram

	c.mv a0, a2					# default: return same value as arg
	addi t0, x0, 0x9			# assert Backlight & RS
	c.slli a0, 4				# shift to <11:8>
	or a0, a0, t0
	c.j __char_code_ret

	__char_code_setddram:
	addi a0, x0, 0xC0			# SETDDRAM to 0x40
	addi t0, x0, 0x8			# assert Backlight
	c.slli a0, 4				# shift to <11:8>
	or a0, a0, t0

	__char_code_ret:
	c.jr ra						# return to calling function


# -- Delay subroutines --
delay:						# not present in main demo.s
	# 1us delay
	c.li t0, 25
	delay_loop:
	c.addi t0, -1
	bne t0, x0, delay_loop

	c.jr ra

# NOP 13
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