# This program sends a string over UART
# ISR for this program is just URET

# start storing data at 0x1c onwards (0x0-0x18 are reserved for protocol controllers)
# String is stored little-endian (first letter is at LSByte)

.data 0x1C
.ascii "The quick brown fox jumps over the lazy dog!\r\n"

.text:
init:
addi sp, x0, 0x400			# PROTOCOLMEM address (word-aligned)
slli sp, sp, 2	#from c.slli sp, 2
addi s0, x0, 0	#from c.li s0, 0					# s0 = x0 for compressed instructions
addi a2, x0, 0x1c	#from c.li a2, 0x1c				# string address in datamem; also serves as byte index
addi a3, a2, 46				# address of last char in string

uart_setup:
# settings:
# 9600 baudrate
# no parity
# 1 stop bit
lui t0, 0x1457				# 9600 bps baudrate
srli t0, t0, 4				# shift to baudcontrol field
add a0, x0, t0	#from c.mv a0, t0					# move t0 contents to a0
sw a0, 16(s0)	#from c.sw a0, 4(s0)				# store to UART Input control

uart_send:
# Check if transmit buffer is full
jal x1, nop_13	#from c.jal nop_13				# NOP for 13 cycles so mcont.v has time to update TXBUFFER status in datamem
lw t0, 12(x2)	#from c.lwsp t0, 3				# load UART output control (0x403)
andi t0, t0, 0x40			# take only TXBF field of output control; if t0==0, TXBUFFER is not full yet
bne t0, x0, uart_send		# if t0 != 0, TXBUFFER is full, loop back until buffer is not full

# Load a character to be sent
lbu t0, 0(a2)				# load a character from datamem
sb t0, 0xc(x0)				# Store to UART Data In

lw a0, 16(s0)	#from c.lw a0, 4(s0)				# Load input control
addi a0, a0, 1	#from c.addi a0, 1				# set EN = 1
sw a0, 16(s0)	#from c.sw a0, 4(s0)				# store back to input control
jal x1, nop_13	#from c.jal nop_13				# NOP for 13 cycles so mcont.v has time to read from input control

addi a0, a0, -1	#from c.addi a0, -1				# set EN = 0
sw a0, 16(s0)	#from c.sw a0, 4(s0)				# store back to input control
jal x1, nop_13	#from c.jal nop_13				# NOP for 13 cycles
beq a2, a3, inf				# if byte index has reached last char, go to infinite loop
addi a2, a2, 1	#from c.addi a2, 1				# increment byte index
jal x0, uart_send	#from c.j uart_send				# go back to uart_send

inf:
jal x0, inf	#from c.j inf


# use "13 NOPs". This is not used for forwarding or other hazards within the core.
# rather, it's used to allow the protocol controller (mcont.v) to be able
# to read from UART Input control & UART Data In at least once
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
