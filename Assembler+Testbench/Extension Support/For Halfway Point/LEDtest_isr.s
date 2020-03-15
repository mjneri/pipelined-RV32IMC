# This test code is used to demonstrate interrupt
# functionality using buttons & LEDs on the Arty7 FPGA.
# The 'main' program is a 'running lights' program (switches values every half second)
# while the ISR simply pauses or reverses the direction of
# the LEDs depending on the button pressed.
# based on the memory mapped addresses:
# BTN: 0x400 (word address)
# LED: 0x402 (word address)
#
# BTN[0]: set direction to right
# BTN[1]: pause
# BTN[2]: resume
# BTN[3]: set direction to left
#
# The registers used in the ISR are registers
# not used in the main program

isr:
	c.lwsp a5, 0			# load value of FPGAIO[0] to get which button was pressed
	c.li t1, 1

	beq a5, t1, btn0		# BTN[0] was pressed

	c.slli t1, 1
	beq a5, t1, btn1		# BTN[1] was pressed

	c.slli t1, 1
	beq a5, t1, btn2		# BTN[2] was pressed

	c.slli t1, 1
	beq a5, t1, btn3		# BTN[3] was pressed

	c.j end					# no buttons were pressed

btn0:
	c.li a0, 1				# set direction to right
	c.j end
btn1:
	c.li a1, 0				# pause the LEDs
	c.j end
btn2:
	c.li a1, 1				# resume
	c.j end
btn3:
	c.li a0, 0				# set direction to left
end:
	uret					# end the ISR