# This test code is to demonstrate SPI functionality of the
# Pipelined RV32IMC + Protocol controllers
# NOTE: The SPI Controller for this project can only send
# 2 bytes per transaction. Interrupts are also triggered at the end of every transaction.
# =========================================================
# Demo setup:
# ESP8266 <---> CORE <---> Arduino Uno
# ESP8266: Slave 2
# Arduino: Slave 3
# Program flow:
# 1. CORE sends 2 byte packages to both slaves in ASCII (ES (ESP), AU (Arduino)).
# 2. If both slaves receive the correct package, they send a reply: (0xAA).
#  	 If reply matches expected data, send command to both slaves to turn on their built-in LEDs (EL, AL)
# 	 Else, send "XX"
# =========================================================
# Register usage:
#		s0 -> SPI BUSY
#		s1 -> SPI DONE
#		s2 -> SPI Data Out
#		sp -> Stack pointer; points to word address 0x3FF
#		gp -> points to PROTOCOLMEM address (0x400)
#		a0-a1 -> return values
# 		a2-a7 -> subroutine arguments

.text
init:
addi sp, x0, 0x3FF			# stack pointer addr
slli sp, sp, 2	#from c.slli sp, 2
addi gp, x0, 0x400			# PROTOCOLMEM addr
slli gp, gp, 2	#from c.slli gp, 2

spi_setup:
# Settings: 100kbps, cpha = 0, cpol = 0 (shift@negedge, sample@posedge), ord = 0 (send MSB first)
addi t0, x0, 124			# 100kbps prescale
slli t0, t0, 8	#from c.slli t0, 8				# shift to prescale field
# c.addi t0, 0xc				# ord = 0, cpha=1, cpol=1
sw t0, 0x8(x0)				# store to SPI Input Control

main:
# First part: CORE sends 2 byte packages to ESP8266 & Arduino
# Send to ESP first
lui a2, 0x04553				# send "ES"
srli a2, a2, 12	#from c.srli a2, 12				# shift s.t. LSB is at bit0
addi a3, x0, 2	#from c.li a3, 2					# select slave 2
jal x1, spi_write	#from c.jal spi_write				# call spi_write(a2, a3)

# Send to Arduino
lui a2, 0x04155				# send "AU"
srli a2, a2, 12	#from c.srli a2, 12				# shift s.t. LSB is at bit0
addi a3, x0, 3	#from c.li a3, 3					# select slave 3
jal x1, spi_write	#from c.jal spi_write				# call spi_write(a2, a3)

# Second part: read reply from ESP8266 & Arduino & send command to turn on builtin LED
# Get ESP reply
addi a2, x0, 2	#from c.li a2, 2					# select slave 2
jal x1, spi_read	#from c.jal spi_read				# call spi_read
addi t0, x0, 0xAA			# "0xAA"

lui a2, 0x0454C				# "EL"
beq a0, t0, main1			# check if data matches expected. If yes, skip "XX"
lui a2, 0x05858				# "XX"
main1:
srli a2, a2, 12	#from c.srli a2, 12				# shift s.t. LSB at bit0
addi a3, x0, 2	#from c.li a3, 2					# select slave 2
jal x1, spi_write	#from c.jal spi_write				# call spi_write(a2, a3)

# Get Arduino reply
addi a2, x0, 3	#from c.li a2, 3					# select slave 3
jal x1, spi_read	#from c.jal spi_read				# call spi_read(a2)
addi t0, x0, 0xAA			# 0xAA

lui a2, 0x0414C				# "AL"
beq a0, t0, main2			# check if data matches expected. If yes, skip "XX"
lui a2, 0x05858				# "XX"
main2:
srli a2, a2, 12	#from c.srli a2, 12				# shift s.t. LSB at bit0
addi a3, x0, 3	#from c.li a3, 3					# select slave 3
jal x1, spi_write	#from c.jal spi_write

inf:
jal x0, inf	#from c.j inf

# =========================================================
# 						SUBROUTINES
# =========================================================
spi_write:
# equivalent: void spi_write(char *data, int ss)
# args: a2 = data, a3 = ss
# NOTE: data is 2 bytes
# Register usage:
# s0 -> asserted if SPI is BUSY

# Check first if a transaction is still in progress
lbu s0, 0x4(gp)				# load SPI Output Control
andi s0, s0, 1	#from c.andi s0, 1				# get BUSY field only

spi_write_wait:
bne s0, x0, spi_write_wait	#from c.bnez s0, spi_write_wait	# loop until SPI is not BUSY; ISR will deassert s0

# Set data & SS
sh a2, 0x4(x0)				# store data to SPI Data In

andi a3, a3, 0x3	#from c.andi a3, 0x3				# make sure to take only bit1 & bit0
slli a3, a3, 5	#from c.slli a3, 5				# shift slave select to SS field
lw t0, 0x8(x0)				# load SPI Input Control
andi t0, t0, -97			# set SS field to 0
or t0, t0, a3				# insert new SS to Input control
ori t0, t0, 3				# set ON = 1, EN = 1
sw t0, 0x8(x0)				# store back to SPI Input Control

addi t1, x0, 1	#from c.li t1, 1					# for checking BUSY
spi_write_waitbusy:			# SPI output control is polled until BUSY is asserted, so we are certain that e_clk
lbu t0, 0x4(gp)				# has captured EN & the transaction has started.
bne t0, t1, spi_write_waitbusy

lw t0, 0x8(x0)				# load SPI Input control
addi t0, t0, -1	#from c.addi t0, -1				# set EN = 0
sw t0, 0x8(x0)				# store back to SPI Input Control

addi sp, sp, -4	#from c.addi sp, -4				# push ra to stack
sw ra, 0(x2)	#from c.swsp ra, 0
jal x1, nop_13	#from c.jal nop_13
lw ra, 0(x2)	#from c.lwsp ra, 0				# reload ra from stack
addi sp, sp, 4	#from c.addi sp, 4

jalr x0, ra, 0	#from c.jr ra						# jump back to calling function

spi_read:
# equivalent: int spi_read(int ss)
# args: a2 = ss
# return value: a0 = valid data
# Register usage:
# s0 -> asserted if SPI is BUSY
# s1 -> asserted if SPI is DONE
# NOTE: when only a read is performed in a transaction, "send" 0 to the slave device

# check if a transaction is still in progress
lbu s0, 0x4(gp)				# load SPI Output Control
andi s0, s0, 1	#from c.andi s0, 1				# get BUSY field only

spi_read_wait:
bne s0, x0, spi_read_wait	#from c.bnez s0, spi_read_wait	# loop until BUSY is not asserted; ISR will set s0 to 0

# set slave select & data
sw x0, 0x4(x0)				# store 0 to SPI Data In

andi a2, a2, 0x3	#from c.andi a2, 0x3				# make sure to take only first two bits from arg
slli a2, a2, 5	#from c.slli a2, 5				# shift to SS field
lw t0, 0x8(x0)				# load SPI Input Control
andi t0, t0, -97			# set SS field to 0
or t0, t0, a2				# insert new SS to input control
ori t0, t0, 3				# set ON = 1, EN = 1
sw t0, 0x8(x0)				# store back to Input control

addi t1, x0, 1	#from c.li t1, 1					# for checking BUSY
spi_read_waitbusy:			# SPI output control is polled until BUSY is asserted, so we are certain that e_clk
lbu t0, 0x4(gp)				# has captured EN & the transaction has started.
bne t0, t1, spi_read_waitbusy

lw t0, 0x8(x0)				# load SPI Input control
addi t0, t0, -1	#from c.addi t0, -1				# set EN = 0
sw t0, 0x8(x0)				# store back to SPI Input Control

addi sp, sp, -4	#from c.addi sp, -4				# push ra to stack
sw ra, 0(x2)	#from c.swsp ra, 0
jal x1, nop_13	#from c.jal nop_13
lw ra, 0(x2)	#from c.lwsp ra, 0				# reload ra from stack
addi sp, sp, 4	#from c.addi sp, 4

# Wait until valid data is received
lbu s1, 0x4(gp)				# load SPI output control
andi s1, s1, 2	#from c.andi s1, 2				# get DONE field only
spi_read_datawait:
beq s1, x0, spi_read_datawait#	#from c.beqz s1, spi_read_datawait# wait until DONE is asserted; ISR will assert s1

add a0, x0, s2	#from c.mv a0, s2					# load SPI Output Data as return value
jalr x0, ra, 0	#from c.jr ra						# jump back to calling function


nop_13:
# use "13 NOPs". This is not used for forwarding or other hazards within the core.
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