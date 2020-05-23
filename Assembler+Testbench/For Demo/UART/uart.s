# This test code is to demonstrate UART functionality of the
# Pipelined RV32IMC + Protocol controllers
#
# An external device sends a command to the FPGA, and outputs
# a corresponding answer.
# Commands:
# ADD XXX,YYY -> add
# SUB XXX,YYY -> sub
# DIV XXX,YYY -> div
# REM XXX,YYY -> rem
# MUL XXX,YYY -> mul
# MHU XXX,YYY -> mulhu
# ==========================
# 3 digits per operand only. Expected inputs are unsigned
# Received data is stored starting at addr 0x100:
# 0x100: "COM[]" (contains ADD , SUB , etc.)
# 0x104: "XXX,"
# 0x108: "YYY"
# 13 bytes are expected, including \r\n
# ==========================
# Register usage:
#		s0 -> x0 for compressed instructions
# 		s1 -> # of bytes received
#		s4 -> TXBF
#		a0 -> UART Input control
#		a1 -> UART Data In
#		a2 -> Data received
#		a3 -> == 1 if 13 bytes received, 0 otherwise
#		a4 -> string to be compared to received data
#		a5 -> subroutine return value
#		a6 -> Input integer XXX
#		a7 -> Input integer YYY
#		t0-t6 -> local subroutine registers (not saved between calls)
# ==========================
# NOTE: when addressing strings (.ascii), LSByte corresponds to first character in the string.

.data 0x1C
	.ascii "ADD "	# 0x1c
	.ascii "SUB "	# 0x20
	.ascii "DIV "	# 0x24
	.ascii "REM "	# 0x28
	.ascii "MUL "	# 0x2c
	.ascii "0123"	# 0x30
	.ascii "4567"	# 0x34
	.ascii "89 ,"	# 0x38
	.ascii "Comm"	# 0x3c
	.ascii "and "	# 0x40
	.ascii "Inva"	# 0x44
	.ascii "lid."	# 0x48
	.ascii "\r\n"	# 0x4c
	.word 0x12		# 0x50; string length of "Command Invalid.\r\n"

.text
init:
	addi sp, x0, 0x3FF			# Stack pointer address
	c.slli sp, 2
	addi gp, x0, 0x400			# set gp to point to PROTOCOLMEM addresses
	c.slli gp, 2
	c.li s0, 0					# s0 = 0 for compressed instructions
setup:
	# Settings: 9600bps, no parity, 1 stop bit
	addi t0, x0, 0x145
	c.slli t0, 4
	c.addi t0, 7				# t0 = 5207 -> baudcontrol for 9600bps
	c.mv a0, t0
	c.slli a0, 8				# shift to baudcontrol field
	c.sw a0, 4(s0)				# store to UART Input control

command_wait:
	c.beqz a3, command_wait		# wait until 13 bytes have been received
	c.li a3, 0					# if loop is broken, reset a3 to 0

command_check:
	# check which command was sent
	# NOTE: make a subroutine to comvert ASCII to integer
	lw a2, 0x100(x0)			# Load command (stored in 0x100)
	c.lw a4, 7(s0)				# Load "ADD "
	beq a2, a4, command_ADD		# go to ADD

	c.lw a4, 8(s0)				# Load "SUB "
	beq a2, a4, command_SUB		# go to SUB

	c.lw a4, 9(s0)				# Load "DIV "
	beq a2, a4, command_DIV		# go to DIV

	c.lw a4, 10(s0)				# Load "REM "
	beq a2, a4, command_REM		# go to REM

	c.lw a4, 11(s0)				# Load "MUL "
	beq a2, a4, command_MUL		# go to MUL

	# If no commands match the input, command is invalid
	c.j command_invalid			# go to INVALID

command_ADD:
	# a6 -> Input integer XXX
	# a7 -> Input integer YYY
	lw a2, 0x104(x0)			# Load "XXX," store in 0x104
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "XXX," to stack
	c.jal atoi					# call atoi()
	blt a5, x0, command_invalid	# check if return value is -1. If yes, command is invalid
	c.mv a6, a5					# move to a6

	lw a2, 0x108(x0)			# Load "YYY", stored in 0x108
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "YYY" to stack
	c.jal atoi					# convert to integer
	blt a5, x0, command_invalid	# if return = -1, command is invalid
	c.mv a7, a5					# move to a7

	add t0, a6, a7				# get sum
	addi t1, x0, 0x60			# point to 0x60, where the string will be stored
	c.addi sp, -8
	c.swsp t0, 0				# push sum to stack
	c.swsp t1, 4				# push string address to stack
	c.jal itoa					# convert sum to string

	addi t1, x0, 0x60			# point to 0x60, where the ASCII converted answer is stored
	c.li t0, 8					# set string length to 8 bytes (0x60 -> 0x67)
	c.addi sp, -8
	c.swsp t1, 0				# push addr to stack
	c.swsp t0, 4				# push strlen to stack
	c.jal uart_send				# send the answer through UART

	c.j command_wait			# wait for a new command

command_SUB:
	# a6 -> Input integer XXX
	# a7 -> Input integer YYY
	lw a2, 0x104(x0)			# Load "XXX," store in 0x104
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "XXX," to stack
	c.jal atoi					# call atoi()
	blt a5, x0, command_invalid	# check if return value is -1. If yes, command is invalid
	c.mv a6, a5					# move to a6

	lw a2, 0x108(x0)			# Load "YYY", stored in 0x108
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "YYY" to stack
	c.jal atoi					# convert to integer
	blt a5, x0, command_invalid	# if return = -1, command is invalid
	c.mv a7, a5					# move to a7

	sub t0, a6, a7				# get difference
	addi t1, x0, 0x70			# point to 0x70, where the string will be stored
	c.addi sp, -8
	c.swsp t0, 0				# push difference to stack
	c.swsp t1, 4				# push string address to stack
	c.jal itoa					# convert difference to string

	addi t1, x0, 0x70			# point to 0x70, where the ASCII converted answer is stored
	c.li t0, 8					# set string length to 8 bytes (0x70 -> 0x77)
	c.addi sp, -8
	c.swsp t1, 0				# push addr to stack
	c.swsp t0, 4				# push strlen to stack
	c.jal uart_send				# send the answer through UART

	c.j command_wait			# wait for a new command

command_DIV:
	# a6 -> Input integer XXX
	# a7 -> Input integer YYY
	lw a2, 0x104(x0)			# Load "XXX," store in 0x104
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "XXX," to stack
	c.jal atoi					# call atoi()
	blt a5, x0, command_invalid	# check if return value is -1. If yes, command is invalid
	c.mv a6, a5					# move to a6

	lw a2, 0x108(x0)			# Load "YYY", stored in 0x108
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "YYY" to stack
	c.jal atoi					# convert to integer
	blt a5, x0, command_invalid	# if return = -1, command is invalid
	c.mv a7, a5					# move to a7

	divu t0, a6, a7				# get quotient
	addi t1, x0, 0x80			# point to 0x80, where the string will be stored
	c.addi sp, -8
	c.swsp t0, 0				# push quotient to stack
	c.swsp t1, 4				# push string address to stack
	c.jal itoa					# convert quotient to string

	addi t1, x0, 0x80			# point to 0x80, where the ASCII converted answer is stored
	c.li t0, 8					# set string length to 8 bytes (0x80 -> 0x87)
	c.addi sp, -8
	c.swsp t1, 0				# push addr to stack
	c.swsp t0, 4				# push strlen to stack
	c.jal uart_send				# send the answer through UART

	c.j command_wait			# wait for a new command

command_REM:
	# a6 -> Input integer XXX
	# a7 -> Input integer YYY
	lw a2, 0x104(x0)			# Load "XXX," store in 0x104
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "XXX," to stack
	c.jal atoi					# call atoi()
	blt a5, x0, command_invalid	# check if return value is -1. If yes, command is invalid
	c.mv a6, a5					# move to a6

	lw a2, 0x108(x0)			# Load "YYY", stored in 0x108
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "YYY" to stack
	c.jal atoi					# convert to integer
	blt a5, x0, command_invalid	# if return = -1, command is invalid
	c.mv a7, a5					# move to a7

	remu t0, a6, a7				# get remainder
	addi t1, x0, 0x90			# point to 0x90, where the string will be stored
	c.addi sp, -8
	c.swsp t0, 0				# push remainder to stack
	c.swsp t1, 4				# push string address to stack
	c.jal itoa					# convert remainder to string

	addi t1, x0, 0x90			# point to 0x90, where the ASCII converted answer is stored
	c.li t0, 8					# set string length to 8 bytes (0x90 -> 0x97)
	c.addi sp, -8
	c.swsp t1, 0				# push addr to stack
	c.swsp t0, 4				# push strlen to stack
	c.jal uart_send				# send the answer through UART

	c.j command_wait			# wait for a new command

command_MUL:
	# a6 -> Input integer XXX
	# a7 -> Input integer YYY
	lw a2, 0x104(x0)			# Load "XXX," store in 0x104
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "XXX," to stack
	c.jal atoi					# call atoi()
	blt a5, x0, command_invalid	# check if return value is -1. If yes, command is invalid
	c.mv a6, a5					# move to a6

	lw a2, 0x108(x0)			# Load "YYY", stored in 0x108
	c.addi sp, -4				# push args to stack
	c.swsp a2, 0				# store "YYY" to stack
	c.jal atoi					# convert to integer
	blt a5, x0, command_invalid	# if return = -1, command is invalid
	c.mv a7, a5					# move to a7

	mul t0, a6, a7				# get product
	addi t1, x0, 0x110			# point to 0x110, where the string will be stored
	c.addi sp, -8
	c.swsp t0, 0				# push product to stack
	c.swsp t1, 4				# push string address to stack
	c.jal itoa					# convert product to string

	addi t1, x0, 0x110			# point to 0x110, where the ASCII converted answer is stored
	c.li t0, 8					# set string length to 8 bytes (0x110 -> 0x117)
	c.addi sp, -8
	c.swsp t1, 0				# push addr to stack
	c.swsp t0, 4				# push strlen to stack
	c.jal uart_send				# send the answer through UART

	c.j command_wait			# wait for a new command

command_invalid:
	addi t1, x0, 0x3c			# point to 0x3c, where "Command Invalid." is stored
	lw t0, 0x50(x0)				# get string length
	c.addi sp, -8
	c.swsp t1, 0				# push addr to stack
	c.swsp t0, 4				# push strlen to stack
	c.jal uart_send				# send the answer through UART

	c.j command_wait			# wait for a new command

# ======================================================
# SUBROUTINES
# ======================================================

atoi:
	# equivalent: int atoi(char *str)
	# Subroutine that converts received ASCII to integer
	# t6 -> argument from caller
	# t0 -> byte from argument
	# t1-t6 -> temp registers
	# a5 -> return value
	# NOTE: ASCII for digits = 0x30 -> 0x39
	c.lwsp t6, 0				# pop argument from the stack
	c.addi sp, 4				# increment stack pointer

	c.li t2, 0xA				# set t2 to constant 10, to be used for mul
	c.li t3, 0					# set t3 to 0, to be used for shifting a2
	addi t4, x0, 0x30			# set t4 to 0x30 ('0')
	addi t5, t4, 0xA			# set t5 to 0x40
	c.li a5, 0					# initialize to 0
	c.li t1, 24					# set t1 to 24, to be used for the loop condition

	atoi_forloop:
	# Iterate through all characters of string and update a5
	# Loop 3 times since only 3 digits need to be converted to integer
	# equivalent: for(t3 = 0; t3 < 24; t3 = t3+8)
	srl t0, t6, t3				# shift t6 by t3 bits to the right
	andi t0, t0, 0xFF			# take only LSByte

	bgeu t3, t1, atoi_return	# check if t3 >= 24; if yes, break loop

	bltu t0, t4, atoi_error		# check if ASCII value < 0x30
	bgeu t0, t5, atoi_error		# check if ASCII value > 0x39

	# a5 = (a5*10) + (t0 - 0x30)
	mul a5, a5, t2				# a5*10
	sub t0, t0, t4				# t0 - 0x30
	add a5, a5, t0				# (a5*10) + (t0 - 0x30)

	c.addi t3, 8				# increment t3 by 8 (so t6 is shifted by at least 1 byte)
	c.j atoi_forloop			# loop again

	atoi_error:
	addi a5, x0, -1				# return -1
	
	atoi_return:
	c.jr ra						# jump back to caller

itoa:
	# equivalent: char *itoa(int hex, char *addr)
	# Subroutine that converts hex digits to ASCII
	# Note: there are 8 hex digits in a word
	# t0 -> hex digit from argument
	# t1-t6 -> temp registers
	# NOTE: ASCII for digits = 0x30 -> 0x39
	# ASCII for alpha = 0x41 -> 0x46
	c.lwsp t3, 0				# pop answer from stack
	c.lwsp t4, 4				# pop address from stack
	c.addi sp, 8

	addi t1, x0, 0xA			# set t1 to 0xA
	c.li t2, 8					# set t2 to 8, to be used to loop 8 times
	c.li a5, 0					# initialize to 0

	c.li t5, 0					# initialize to 0, to be used for loop
	c.li t6, 0					# to be used for shifting t3

	itoa_forloop:
	# equivalent: for(t5 = 0; t5 < t2; t5++)
	srl t0, t3, t6				# shift t3 right by t6 bits
	andi t0, t0, 0xF			# get only least significant hex digit
	bgeu t5, t2, itoa_return	# if t5 >= t2, break loop
	blt t0, t1, itoa_num		# if hex digit is less than 0xA, convert to numeric ASCII
	c.addi t0, 0x7				# add 0x7 offset; (t0 + 0x37 = alpha IF t0 >= 0xA)
		itoa_num:
		addi t0, t0, 0x30		# add 0x30 offset to convert to num character
	
	sb t0, 0(t4)				# store ASCII to datamem based on char *addr
	c.addi t6, 4				# increment t6 by 4
	c.addi t5, 1				# increment t5
	c.addi t4, 1				# point to next byte address

	itoa_return:
	c.jr ra						# return to caller
	
uart_send:
	# equivalent: void uart_send(char *addr, int strlen)
	# Subroutine that sends the answer through UART
	# a0 -> UART Input control
	# a1 -> UART Data In
	# t0-t6 -> local subroutine registers (not saved between calls)
	# s4 -> TXBF
	# ==========================
	# NOTE: when addressing strings (.ascii), LSByte corresponds to first character in the string.
	c.lwsp t3, 0				# pop addr from stack
	c.lwsp t4, 4				# pop strlen from stack
	c.addi sp, 8				# update sp
	
	# Get address of last char in string
	c.addi t4, -1
	c.add t4, t3

	# Check if transmit buffer is full
	#; if TXBF is asserted, program will loop here until the ISR deasserts it
	uart_txbufcheck:
	beq s4, x0, uart_txbufcheck	# wait until TXBF is not asserted anymore

	# Load characters to be sent
	lbu a1, 0(t3)				# load character from address pointed to by t3
	c.sw a1, 3(s0)				# store to UART Data In (addr 0xC)
	c.addi a0, 1				# set EN = 1 in UART Input Control
	c.sw a0, 4(s0)				# store to input control
	c.jal nop_13				# NOP for 13 cycles until mcont.v reads from input control
	c.addi a0, -1				# set EN = 0
	c.sw a0, 4(s0)				# store back to input control
	c.jal nop_13				# NOP for 13 cycles
	
	lbu s4, 0xD(gp)				# get TXBF from Output control
	andi s4, s4, 0x40

	beq t3, t4, uart_return		# if t3 is pointing to last char, return to caller
	c.addi t3, 1				# increment t3
	c.j uart_send				# repeat until all bytes are sent

	uart_return:
	c.jr ra


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