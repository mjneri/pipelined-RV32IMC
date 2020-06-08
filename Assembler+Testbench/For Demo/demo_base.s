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

.text
init:
addi sp, x0, 0x3FF			# Stack pointer address
slli sp, sp, 2	#from c.slli sp, 2
addi gp, x0, 0x400			# set gp to point to PROTOCOLMEM addresses
slli gp, gp, 2	#from c.slli gp, 2
addi s0, x0, 0	#from c.li s0, 0					# s0 = 0 for compressed instructions

uart_setup:
# Settings: 4800bps, no parity, 1 stop bit
lui t0, 0x028af
slli t0, t0, 4	#from c.slli t0, 4				# shift to baudcontrol field
sw t0, 0x10(x0)				# store to Input Control

spi_setup:
# Settings: 100kbps, cpha = 0, cpol = 0 (shift@negedge, sample@posedge), ord = 0 (send MSB first)
addi t0, x0, 124			# 100kbps prescale
slli t0, t0, 8	#from c.slli t0, 8				# shift to prescale field
sw t0, 0x8(x0)				# store to SPI Input Control

i2c_setup:
# Settings: 100kbps
addi t0, x0, 124			# 100kbps prescale
slli t0, t0, 16	#from c.slli t0, 16				# shift to prescale field
addi t0, t0, 9	#from c.addi t0, 9				# SETPRESCALE = 1, START = 1
sw t0, 0x18(x0)				# store to I2C Input Control
jal x1, nop_13	#from c.jal nop_13
xori t0, t0, 9				# SETPRESCALE = 0, START = 0
sw t0, 0x18(x0)				# store back to input control

main:
jal x1, lcd_init	#from c.jal lcd_init				# initialize LCD
addi a2, x0, 0x100			# "LCD\nInitialized" Address
jal x1, lcd_print	#from c.jal lcd_print				# lcd_print(a2)
jal x1, delay_1s	#from c.jal delay_1s
jal x1, delay_1s	#from c.jal delay_1s
jal x1, lcd_clear	#from c.jal lcd_clear

loop:
# Ask Arduino which button was pressed:
# Command format (Received from Arduino):
# 0x10 -> no button pressed
# 0x11 -> PLAY/PAUSE
# 0x12 -> NEXT
# 0x13 -> PREV
# --
# 0x00FF -> sent to Arduino, indicating that we want to read from it
addi a2, x0, 0	#from c.li a2, 0					# select Slave 0
jal x1, spi_read	#from c.jal spi_read				# call spi_read(ss); a0 contains return value

addi t0, x0, 0x11	#from c.li t0, 0x11				# check for PLAY/PAUSE
addi t1, x0, 0x12	#from c.li t1, 0x12				# check for NEXT
addi t2, x0, 0x13	#from c.li t2, 0x13				# check for PREV

beq a0, t0, btn_playpause
beq a0, t1, btn_next
beq a0, t2, btn_prev

jal x0, song_check	#from c.j song_check				# no buttons were pressed; wait for data from ESP8266

btn_playpause:
# send "PLAYPAUSE\r\n" to ESP8266
addi a2, x0, 0x1c		# address of "PLAYPAUSE\r\n"
jal x1, uart_write	#from c.jal uart_write		# call uart_write(a2)
jal x0, song_check	#from c.j song_check

btn_next:
# send "NEXT\r\n" to ESP8266
addi a2, x0, 0x40		# address of "NEXT\r\n"
jal x1, uart_write	#from c.jal uart_write		# call uart_write(a2)
jal x0, song_check	#from c.j song_check

btn_prev:
# send "PREV\r\n" to ESP8266
addi a2, x0, 0x30		# address of "PREV\r\n"
jal x1, uart_write	#from c.jal uart_write		# call uart_write(a2)

song_check:
# wait for data from ESP8266 to see if song changed
jal x1, uart_read	#from c.jal uart_read			# call uart_read()
addi a2, x0, 0xa0		# address of prevRx
addi a3, x0, 0x50		# address of Rxbuffer
jal x1, strcmp	#from c.jal strcmp			# call strcmp(prevRx, Rxbuffer)
beq a0, x0, loop	#from c.beqz a0, loop			# if prevRx == Rxbuffer, go back to loop. Else, print new string to LCD

jal x1, lcd_clear	#from c.jal lcd_clear			# clear LCD
addi a2, x0, 0x50		# address of Rxbuffer
jal x1, lcd_print	#from c.jal lcd_print			# call lcd_print(Rxbuffer)
jal x0, loop	#from c.j loop				# go back to start of loop

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
addi sp, sp, -4	#from c.addi sp, -4
sw ra, 0(x2)	#from c.swsp ra, 0

jal x1, delay_20ms	#from c.jal delay_20ms			# 20ms delay

addi a2, x0, 0x38			# function set 1
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_5ms	#from c.jal delay_5ms				# 5ms delay

addi a2, x0, 0x38			# function set 2
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x38			# function set 3
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x28			# function set 4
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

# Send commands
addi a2, x0, 0x28			# function set high
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x88			# function set low
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x08			# display_off high
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x88			# display off low
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x08			# clear high
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x18			# clear low
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_20ms	#from c.jal delay_20ms			# 20ms delay

addi a2, x0, 0x08			# entry mode set high
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x68			# entry mode set low
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x08			# display on high
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0xc8			# display on low
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us

# Reload ra from stack
lw ra, 0(x2)	#from c.lwsp ra, 0
addi sp, sp, 4	#from c.addi sp, 4
jalr x0, ra, 0	#from c.jr ra						# return to calling function

lcd_print:						# equivalent: void lcd_print(char *str)
# sends the string to LCD
# args: a2 = *str
# <Command bits> = <Backlight, E, RW, RS>
addi sp, sp, -4	#from c.addi sp, -4				# store ra to stack
sw ra, 0(x2)	#from c.swsp ra, 0

addi sp, sp, -4	#from c.addi sp, -4
sw a2, 0(x2)	#from c.swsp a2, 0				# store *str to stack
jal x1, strlen	#from c.jal strlen				# strlen(a2); a0 = strlen
lw a2, 0(x2)	#from c.lwsp a2, 0				# reload *str from stack
addi sp, sp, 4	#from c.addi sp, 4

beq a0, x0, lcd_print_ret	#from c.beqz a0, lcd_print_ret	# if strlen == 0, return to caller

addi t0, x0, 0	#from c.li t0, 0					# loop index; int i = 0;
add t1, x0, a2	#from c.mv t1, a2					# move *str to t1
add t2, x0, a0	#from c.mv t2, a0					# move strlen to t2

lcd_print_loop:				# send all characters to LCD
lbu a2, 0(t1)			# load char to a2 (arg for char_codelcd())

addi sp, sp, -12	#from c.addi sp, -12			# store loop index, *str & strlen to stack
sw t0, 0(x2)	#from c.swsp t0, 0			# loop index
sw t1, 4(x2)	#from c.swsp t1, 1			# *str
sw t2, 8(x2)	#from c.swsp t2, 2			# strlen

jal x1, char_codelcd	#from c.jal char_codelcd		# char_codelcd(a2); a0 = ascii value
add a2, x0, a0	#from c.mv a2, a0				# move return value to a2 (arg for lcd_send())
addi sp, sp, -4	#from c.addi sp, -4			# preserve a2 value
sw a2, 0(x2)	#from c.swsp a2, 0

# Get <D7:D4> + <Command bits> first
lui t3, 0x00f0f
srli t3, t3, 12			# t3 = 0x00000f0f
and a2, a2, t3			# <D7:D4> <0,0,0,0> <Command bits>
srli t3, a2, 8			# get <D7:D4> only
slli t3, t3, 4	#from c.slli t3, 4			# shift back to bits <7:4>
or a2, a2, t3			# combine
andi a2, a2, 0xff		# take 8 bits only; a2 now contains <D7:D4> <Command bits>
jal x1, lcd_send	#from c.jal lcd_send			# lcd_send(a2)

# Get <D3:D0> + <Command bits>
lw a2, 0(x2)	#from c.lwsp a2, 0			# reload preserved a2
addi sp, sp, 4	#from c.addi sp, 4			# pop stack
andi a2, a2, 0xff		# a2 now contains <D3:D0> <Command bits>
jal x1, lcd_send	#from c.jal lcd_send			# lcd_send(a2)

lw t0, 0(x2)	#from c.lwsp t0, 0			# reload from stack; loop index
lw t1, 4(x2)	#from c.lwsp t1, 1			# *str
lw t2, 8(x2)	#from c.lwsp t2, 2			# strlen
addi sp, sp, 12	#from c.addi sp, 12			# pop stack

addi t0, t0, 1	#from c.addi t0, 1			# increment loop index
addi t1, t1, 1	#from c.addi t1, 1			# increment *str
bltu t0, t2, lcd_print_loop	# if loop index < strlen, loop again

lcd_print_ret:
lw ra, 0(x2)	#from c.lwsp ra, 0				# load ra from stack
addi sp, sp, 4	#from c.addi sp, 4
jalr x0, ra, 0	#from c.jr ra						# return

lcd_clear:						# equivalent: void lcd_clear(void)
# Store ra to stack
addi sp, sp, -4	#from c.addi sp, -4
sw ra, 0(x2)	#from c.swsp ra, 0

addi a2, x0, 0x08			# clear high
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x18			# clear low
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_20ms	#from c.jal delay_20ms			# 20ms delay

# Load ra from stack
lw ra, 0(x2)	#from c.lwsp ra, 0
addi sp, sp, 4	#from c.addi sp, 4
jalr x0, ra, 0	#from c.jr ra						# return

lcd_returnhome:					# equivalent: void lcd_returnhome(void)
# Store ra to stack
addi sp, sp, -4	#from c.addi sp, -4
sw ra, 0(x2)	#from c.swsp ra, 0

addi a2, x0, 0x08			# return home high
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

addi a2, x0, 0x28			# return home low
jal x1, lcd_send	#from c.jal lcd_send				# pulse E
jal x1, delay_100us	#from c.jal delay_100us			# 100us delay

# Load ra from stack
lw ra, 0(x2)	#from c.lwsp ra, 0
addi sp, sp, 4	#from c.addi sp, 4
jalr x0, ra, 0	#from c.jr ra						# return

# MID-LEVEL SUBROUTINES
lcd_send:						# equivalent: void lcd_send(uint_8 data)
# sends a command to the LCD, making sure E input to LCD is pulsed
# args: data = a2
# Set args to be sent to i2c_write()
ori a2, a2, 0x04			# assert E in data bits
addi a3, x0, 1	#from c.li a3, 1					# send 1 byte only
addi a4, x0, 0x27			# slave_addr of LCD

addi sp, sp, -12	#from c.addi sp, -12				# push to stack
sw a2, 0(x2)	#from c.swsp a2, 0				# preserve data passed to lcd_send
sw a4, 4(x2)	#from c.swsp a4, 1				# preserve slave address
sw ra, 8(x2)	#from c.swsp ra, 2				# store return address to stack

jal x1, i2c_write	#from c.jal i2c_write				# call i2c_write()
jal x1, delay_100us	#from c.jal delay_100us			# call delay_100us()

# Set args to be sent to i2c_write()
lw a2, 0(x2)	#from c.lwsp a2, 0				# get preserved data back from stack
lw a4, 4(x2)	#from c.lwsp a4, 1				# get preserved slave address
addi sp, sp, 8	#from c.addi sp, 8				# pop stack

andi a2, a2, 0xfb			# deassert E
addi a3, x0, 1	#from c.li a3, 1					# send 1 byte only

jal x1, i2c_write	#from c.jal i2c_write				# call i2c_write()
jal x1, delay_100us	#from c.jal delay_100us			# call delay_100us()

lw ra, 0(x2)	#from c.lwsp ra, 0				# get return address from the stack
addi sp, sp, 4	#from c.addi sp, 4				# pop stack
jalr x0, ra, 0	#from c.jr ra

i2c_write: 						# equivalent: void i2c_write (int data, int byte_amt, int slave_addr)
# args: a2 = data, a3 = byte amt, a4 = slave_addr
# Check first if a transaction is still in progress
lw s2, 0x18(gp)				# load I2C output control
addi t0, x0, 1	#from c.li t0, 1					# for comparing w/ BUSY field
i2c_wait1:
beq s2, t0, i2c_wait1		# if I2C is busy, wait here. ISR will update s2 once I2C is done executing

# Setting I2C Input control
sw a2, 0x14(x0)				# store data in I2C Data In

add t3, x0, a3	#from c.mv t3, a3					# copy a3 to t3
slli t3, t3, 11	#from c.slli t3, 11				# shift to #BYTES field
add t4, x0, a4	#from c.mv t4, a4					# copy slave address to t4
slli t4, t4, 4	#from c.slli t4, 4				# shift to slave address field
or t3, t3, t4				# combine #BYTES & Slave address into t3

addi t3, t3, 5	#from c.addi t3, 5				# WRITE = 1, START = 1
sw t3, 0x18(x0)				# store to I2C Input control

lw s2, 0x18(gp)				# load I2C output control
addi t0, x0, 1	#from c.li t0, 1					# for comparing w/ BUSY field
i2c_wait2:
bne s2, t0, i2c_wait2		# wait until BUSY asserts. ISR will update s2 once I2C starts transmission

xori t3, t3, 5				# WRITE = 0, START = 0
sw t3, 0x18(x0)				# store to I2C Input control

# Don't return until transaction is finished
lw s2, 0x18(gp)				# load I2C output control
addi t0, x0, 1	#from c.li t0, 1					# for comparing w/ BUSY field
i2c_wait3:
beq s2, t0, i2c_wait3		# if I2C is busy, wait here. ISR will update s2 once I2C is done executing

jalr x0, ra, 0	#from c.jr ra

uart_write: 					# equivalent: void uart_write(char *str); Args: a2 = char *str
# Subroutine that sends a string to UART Transmit buffer. UART sends automatically start after
addi sp, sp, -4	#from c.addi sp, -4				# push to stack
sw ra, 0(x2)	#from c.swsp ra, 0				# store return address to stack

# get strlen(str)
addi sp, sp, -4	#from c.addi sp, -4
sw a2, 0(x2)	#from c.swsp a2, 0				# preserve *str
jal x1, strlen	#from c.jal strlen				# call strlen(str); a0 = strlen
lw a2, 0(x2)	#from c.lwsp a2, 0				# reload *str from stack
addi sp, sp, 4	#from c.addi sp, 4

beq a0, x0, uart_write_ret	#from c.beqz a0, uart_write_ret	# if strlen == 0, return

addi t2, x0, 0	#from c.li t2, 0					# loop index; int i = 0;
add t1, x0, a2	#from c.mv t1, a2					# move *str to t1

uart_write_loop:			# Send char to TXBUFFER
lhu s1, 0xc(gp)			# Check if transmit buffer is full; get TXBF&TRMT from Output control
andi s1, s1, 0xc0		#; if TXBF is asserted, program will loop here until the ISR updates s1
addi t3, x0, 0x40		# for checking w/ TXBF field
uart_txbfcheck:
beq s1, t3, uart_txbfcheck	# wait until TXBF is not asserted anymore

lbu a2, 0(t1)			# load byte pointed to by *str
sw a2, 12(s0)	#from c.sw a2, 3(s0)			# store to UART Data In (addr 0xC)

lw t0, 0x10(x0)			# Load UART Input Control
ori t0, t0, 1			# set EN = 1
sw t0, 0x10(x0)			# store back to Input Control

jal x1, nop_13	#from c.jal nop_13			# NOP for 13 cycles
lw t0, 0x10(x0)			# Load input control
xori t0, t0, 1			# set EN = 0
sw t0, 0x10(x0)			# store back to input control
jal x1, nop_13	#from c.jal nop_13			# NOP for 13 cycles

addi t2, t2, 1	#from c.addi t2, 1			# increment loop index
addi t1, t1, 1	#from c.addi t1, 1			# increment *str
bltu t2, a0, uart_write_loop# if loop index < strlen, loop again

# Once all bytes have been stored to TXBUFFER, return
uart_write_ret:
lw ra, 0(x2)	#from c.lwsp ra, 0				# load ra from stack
addi sp, sp, 4	#from c.addi sp, 4
jalr x0, ra, 0	#from c.jr ra						# return to calling function

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
addi sp, sp, -4	#from c.addi sp, -4				# store ra to stack
sw ra, 0(x2)	#from c.swsp ra, 0

# initialize prevRx to \0; equiv: memset(prevRx, 0, sizeof(prevRx));
addi t0, x0, 0	#from c.li t0, 0					# loop index
addi t1, x0, 64				# loop limit
__memset_1:					# for(t0=0; t0<64; t0=t0+4)
sw x0, 0xa0(t0)			# prevRx
addi t0, t0, 4	#from c.addi t0, 4
bltu t0, t1, __memset_1

# copy Rxbuffer contents to prevRx; equiv: strcpy(prevRx, Rxbuffer);
addi t0, x0, 0	#from c.li t0, 0					# loop index
addi t1, x0, 64				# loop limit
__strcpy_1:					# for(t0=0; t0<64; t0=t0+4)
lw t2, 0x50(t0)			# load Rxbuffer
sw t2, 0xa0(t0)			# store to prevRx
addi t0, t0, 4	#from c.addi t0, 4
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
addi t0, x0, 0	#from c.li t0, 0					# loop index
addi t1, x0, 64				# loop limit
__memset_2:					# for(t0=0; t0<64; t0=t0+4)
sw x0, 0x50(t0)			# Rxbuffer
addi t0, t0, 4	#from c.addi t0, 4
bltu t0, t1, __memset_2

addi t0, x0, 0	#from c.li t0, 0					# Rxbuffer[t0]; equiv: int i = 0;
addi t1, x0, 64				# 64 byte limit
lui t2, 0xcb735				# ~50ms delay; Formula: (50MHz*50ms)/(3 instructions in loop)
srli t2, t2, 12				# align to LSB
uart_read_rxbuffer:
beq s7, x0, __rxbuffer	# check if data has been received; if s7==0, no data recvd yet;
# Store recvd data to Rxbuffer
addi s7, x0, 0	#from c.li s7, 0				# reset s7 to 0
sb s4, 0x50(t0)			# Rxbuffer[t0] = RXData;
addi t0, t0, 1	#from c.addi t0, 1			# t0++;

#; if 64 bytes have been stored already, return to caller
bgeu t0, t1, uart_read_ret

# Reinitialize delay counter to restart the 'timer'
lui t2, 0xcb735
srli t2, t2, 12

__rxbuffer:
addi t2, t2, -1	#from c.addi t2, -1			# decrement; if constant > 0, keep looping
bne t2, x0, uart_read_rxbuffer

uart_read_ret:
lw ra, 0(x2)	#from c.lwsp ra, 0				# reload ra from stack
addi sp, sp, 4	#from c.addi sp, 4
jalr x0, ra, 0	#from c.jr ra						# return to calling function

spi_write: 						# equivalent: void spi_write(char *data, int ss)
# args: a2 = data, a3 = ss
# NOTE: data is 2 bytes
# Register usage:
# s3 -> SPI Output control

# Check first if a transaction is still in progress
lbu s3, 0x4(gp)				# load SPI Output Control
addi t0, x0, 1	#from c.li t0, 1					# for comparing w/ BUSY field

spi_write_wait:
beq s3, t0, spi_write_wait	# loop until SPI is not BUSY; ISR will update s3

# Set data & SS
sh a2, 0x4(x0)				# store data to SPI Data In

andi a3, a3, 0x3	#from c.andi a3, 0x3				# make sure to take only bit1 & bit0
slli a3, a3, 5	#from c.slli a3, 5				# shift slave select to SS field
lw t0, 0x8(x0)				# load SPI Input Control
andi t0, t0, -97			# set SS field to 0
or t0, t0, a3				# insert new SS to Input control
ori t0, t0, 3				# set ON = 1, EN = 1
sw t0, 0x8(x0)				# store back to SPI Input Control

lbu s3, 0x4(gp)				# load SPI Output Control
addi t0, x0, 1	#from c.li t0, 1					# for checking BUSY
spi_write_waitbusy:			# wait until SPI has started the transaction. ISR will update s3
bne s3, t0, spi_write_waitbusy

lw t0, 0x8(x0)				# load SPI Input control
addi t0, t0, -1	#from c.addi t0, -1				# set EN = 0
sw t0, 0x8(x0)				# store back to SPI Input Control

jalr x0, ra, 0	#from c.jr ra						# jump back to calling function

spi_read: 						# equivalent: int spi_read(int ss)
# args: a2 = ss
# return value: a0 = valid data
# Register usage:
# s3 -> SPI Output Control
# s6 -> SPI Data Out
# NOTE: when only a read is performed in a transaction, "send" 0x00FF to the slave device

# check if a transaction is still in progress
lbu s3, 0x4(gp)				# load SPI Output Control
addi t0, x0, 1	#from c.li t0, 1					# for comparing w/ BUSY field

spi_read_wait:
beq s3, t0, spi_read_wait	# loop until BUSY is not asserted; ISR will update s3

# set slave select & data
addi t0, x0, 0xff			# 0xff
sh t0, 0x4(x0)				# store 0x00FF to SPI Data In

andi a2, a2, 0x3	#from c.andi a2, 0x3				# make sure to take only first two bits from arg
slli a2, a2, 5	#from c.slli a2, 5				# shift to SS field
lw t0, 0x8(x0)				# load SPI Input Control
andi t0, t0, -97			# set SS field to 0
or t0, t0, a2				# insert new SS to input control
ori t0, t0, 3				# set ON = 1, EN = 1
sw t0, 0x8(x0)				# store back to Input control

lbu s3, 0x4(gp)				# load SPI Output Control
addi t0, x0, 1	#from c.li t0, 1					# for checking BUSY
spi_read_waitbusy:			# wait until SPI has started the transaction. ISR will update s3
bne s3, t0, spi_read_waitbusy

lw t0, 0x8(x0)				# load SPI Input control
addi t0, t0, -1	#from c.addi t0, -1				# set EN = 0
sw t0, 0x8(x0)				# store back to SPI Input Control

addi sp, sp, -4	#from c.addi sp, -4				# push ra to stack
sw ra, 0(x2)	#from c.swsp ra, 0
jal x1, nop_13	#from c.jal nop_13
lw ra, 0(x2)	#from c.lwsp ra, 0				# reload ra from stack
addi sp, sp, 4	#from c.addi sp, 4

# Wait until valid data is received
lbu s3, 0x4(gp)				# load SPI output control
addi t0, x0, 2	#from c.li t0, 2					# for comparing w/ DONE field
spi_read_datawait:
bne s3, t0, spi_read_datawait	# wait until DONE is asserted; ISR will assert s3

add a0, x0, s6	#from c.mv a0, s6					# load SPI Output Data as return value
jalr x0, ra, 0	#from c.jr ra						# jump back to calling function

# LOW-LEVEL SUBROUTINES (Subroutines that don't call other subroutines)
strcmp:							# equivalent: int strcmp(char *str1, char *str2)
# args: a2 = *str1, a3 = *str2
# ret: a0 = 0 if strings are equal, 1 otherwise
# subroutine compares strings by byte
addi t2, x0, 0xd	#from c.li t2, 0xd				# for checking '\r
__strcmp_loop:
lbu t0, 0(a2)			# load from str1
lbu t1, 0(a3)			# load from str2

addi a0, x0, 1	#from c.li a0, 1				# set a0 = 1 in case bytes are not equal
bne t0, t1, strcmp_ret	# if bytes are not equal, break from loop
addi a0, x0, 0	#from c.li a0, 0				# reset a0 = 0; skipped if t0!=t1

beq t0, x0, strcmp_ret	# if t0=='\0', break loop
beq t0, t2, strcmp_ret	# if t0=='\r', break loop
beq t1, x0, strcmp_ret	# if t0=='\0', break loop
beq t1, t2, strcmp_ret	# if t0=='\r', break loop

addi a2, a2, 1	#from c.addi a2, 1			# increment *str1
addi a3, a3, 1	#from c.addi a3, 1			# increment *str2
jal x0, __strcmp_loop	#from c.j __strcmp_loop

strcmp_ret:
jalr x0, ra, 0	#from c.jr ra						# return a0;

strlen: 						# equivalent: unsigned int strlen(char *str)
# args: a2 = *str
# ret: a0 = strlen
# in this case, strings can also end w/ '\r' (0x0D)
addi a0, x0, 0	#from c.li a0, 0					# loop index; equivalent: int count = 0;

strlen_loop:
# loop until char == '\0'
lbu t1, 0(a2)				# load char
beq t1, x0, __strlen		# if char =='\0', break from loop
addi a2, a2, 1	#from c.addi a2, 1				# increment str pointer
addi a0, a0, 1	#from c.addi a0, 1				# increment count
jal x0, strlen_loop	#from c.j strlen_loop

__strlen:
jalr x0, ra, 0	#from c.jr ra						# return a0

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

add a0, x0, a2	#from c.mv a0, a2					# default: return same value as arg
addi t0, x0, 0x9			# assert Backlight & RS
slli a0, a0, 4	#from c.slli a0, 4				# shift to <11:8>
or a0, a0, t0
jal x0, __char_code_ret	#from c.j __char_code_ret

__char_code_setddram:
addi a0, x0, 0xC0			# SETDDRAM to 0x40
addi t0, x0, 0x8			# assert Backlight
slli a0, a0, 4	#from c.slli a0, 4				# shift to <11:8>
or a0, a0, t0

__char_code_ret:
jalr x0, ra, 0	#from c.jr ra						# return to calling function


# -- Delay subroutines --
delay_100us:
# Formula: (50MHz * delay)/2
addi t0, x0, 0x4e2
slli t0, t0, 1	#from c.slli t0, 1

delay_100us_loop:
addi t0, t0, -1	#from c.addi t0, -1				# decrement
bne t0, x0, delay_100us_loop# if constant is not yet 0, keep looping

jalr x0, ra, 0	#from c.jr ra						# return to caller

delay_1ms:
# Formula: (50MHz * delay)/2
lui t0, 0x061a8
srli t0, t0, 12

delay_1ms_loop:
addi t0, t0, -1	#from c.addi t0, -1
bne t0, x0, delay_1ms_loop

jalr x0, ra, 0	#from c.jr ra

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
lui t0, 0x17d78
srli t0, t0, 4
addi t0, t0, 0x40

delay_1s_loop:
addi t0, t0, -1	#from c.addi t0, -1
bne t0, x0, delay_1s_loop

jalr x0, ra, 0	#from c.jr ra


# NOP 13
nop_13:
# use 13 NOPs. This is not used for forwarding or other hazards within the core.
# rather, it's used to allow the protocol controller (mcont.v) to be able
# to read from Input Control & Data in at least once
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
