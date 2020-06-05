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
#		s11 -> WRDONE&RDDONE status of previous interrupt
#		--
#		a0-a1 -> return values
#		a2-a7 -> subroutine arguments
#		t0-t6 -> local subroutine registers (not saved between calls)
#		ISR stores ax & tx registers to stack before running.

.text
init:
	# store temp registers & args in stack
	addi sp, sp, -60			# formula: sp - (# of registers to save)*4
	c.swsp t0, 0
	c.swsp t1, 1
	c.swsp t2, 2
	c.swsp t3, 3
	c.swsp t4, 4
	c.swsp t5, 5
	c.swsp t6, 6
	c.swsp a0, 7
	c.swsp a1, 8
	c.swsp a2, 9
	c.swsp a3, 10
	c.swsp a4, 11
	c.swsp a5, 12
	c.swsp a6, 13
	c.swsp a7, 14

isr:
	# Load Data Out registers
	lbu s4, 0x10(gp)			# UART Data Out
	lbu s6, 0x8(gp)				# SPI Data Out

	# Load Output Control registers
	lhu s1, 0xc(gp)				# UART Output Control
	lbu s2, 0x18(gp)			# I2C Output Control
	lbu s3, 0x4(gp)				# SPI Output Control

	# Turn off SPI controller
	# This is done due to how e_clk in the SPI controller works.
	# By turning off the controller, e_clk starts running at 25MHz again, allowing
	# it to capture EN. If we leave ON = 1, e_clk will stay running at the prescale frequency,
	# which lessens the chance of e_clk capturing EN.
	lw t0, 0x8(x0)				# load SPI Input Control
	xori t0, t0, 2				# set ON = 0
	sw t0, 0x8(x0)				# store back to Input Control

	# Check previous UART interrupt status to determine whether s7 should be asserted
	c.li s7, 0					# reset s7
	c.mv t2, s11				# copy s11 contents to t2
	andi t2, t2, 0x100			# get RDDONE from s11
	bne t2, x0, __isr			# if RDDONE was asserted from the previous interrupt, then current interrupt is due to WRDONE.
								# Don't update s7

	andi s7, s1, 0x100			# get RDDONE field from UART Output Control & store to s7

	__isr:
	# update s1 to contain updated TRMT & TXBF
	andi s1, s1, 0xc0			# get TRMT & TXBF fields from UART Output Control only; used by uart_write() for checking TXBUFFER status

	lw s11, 0xC(gp)				# load Output control
	andi s11, s11, 0x101		# get updated RDDONE & WRDONE

eret:
	# reload temp registers
	c.lwsp t0, 0
	c.lwsp t1, 1
	c.lwsp t2, 2
	c.lwsp t3, 3
	c.lwsp t4, 4
	c.lwsp t5, 5
	c.lwsp t6, 6
	c.lwsp a0, 7
	c.lwsp a1, 8
	c.lwsp a2, 9
	c.lwsp a3, 10
	c.lwsp a4, 11
	c.lwsp a5, 12
	c.lwsp a6, 13
	c.lwsp a7, 14
	addi sp, sp, 60

	uret
	c.nop
	c.nop
	c.nop
	c.nop