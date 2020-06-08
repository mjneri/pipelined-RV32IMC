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
#		s5 -> I2C Data Out
#		s6 -> SPI Data Out
#		s7 -> UART data has been received
#		--
#		a0-a1 -> return values
#		a2-a7 -> subroutine arguments
#		t0-t6 -> local subroutine registers (not saved between calls)
#		ISR stores ax & tx registers to stack before running.

.text
init:
# store temp registers & args in stack
# similar to NOP 13, "wait" for at least 13 cycles before loading PROTOCOLMEM contents
# addi sp, sp, -60			# formula: sp - (# of registers to save)*4
addi sp, sp, -28	#from c.addi sp, -28
sw t0, 0(x2)	#from c.swsp t0, 0
sw t1, 4(x2)	#from c.swsp t1, 1
sw t2, 8(x2)	#from c.swsp t2, 2
sw t3, 12(x2)	#from c.swsp t3, 3
sw t4, 16(x2)	#from c.swsp t4, 4
sw t5, 20(x2)	#from c.swsp t5, 5
sw t6, 24(x2)	#from c.swsp t6, 6
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop

isr:
# Load Data Out registers
lbu s4, 0x10(gp)			# UART Data Out
lbu s6, 0x8(gp)				# SPI Data Out

# Load Output Control registers
lhu s1, 0xc(gp)				# UART Output Control
lbu s2, 0x18(gp)			# I2C Output Control
lbu s3, 0x4(gp)				# SPI Output Control

# Turn off SPI controller
andi t0, s3, 1				# get BUSY field for SPI
bne t0, x0, __isr			# if SPI is still BUSY, don't turn off SPI controller

# This is done due to how e_clk in the SPI controller works.
# By turning off the controller, e_clk starts running at 25MHz again, allowing
# it to capture EN. If we leave ON = 1, e_clk will stay running at the prescale frequency,
# which lessens the chance of e_clk capturing EN.
lw t0, 0x8(x0)				# load SPI Input Control
xori t0, t0, 2				# set ON = 0
sw t0, 0x8(x0)				# store back to Input Control

__isr:
# Update s7 status for uart_read() & update s1 for uart_write()
andi s7, s1, 0x100			# get RDDONE field from UART Output Control & store to s7
andi s1, s1, 0xc0			# get TRMT & TXBF fields from UART Output Control only; used by uart_write() for checking TXBUFFER status

eret:
# reload temp registers
lw t0, 0(x2)	#from c.lwsp t0, 0
lw t1, 4(x2)	#from c.lwsp t1, 1
lw t2, 8(x2)	#from c.lwsp t2, 2
lw t3, 12(x2)	#from c.lwsp t3, 3
lw t4, 16(x2)	#from c.lwsp t4, 4
lw t5, 20(x2)	#from c.lwsp t5, 5
lw t6, 24(x2)	#from c.lwsp t6, 6
addi sp, sp, 28	#from c.addi sp, 28

uret
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
