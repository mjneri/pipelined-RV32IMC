# This test code is used to demonstrate interrupt
# functionality using buttons & LEDs on the Arty7 FPGA.
# The 'main' program is a 'running lights' program (switches values every half second)
# while the ISR simply pauses or reverses the direction of
# the LEDs depending on the button pressed.
# based on the memory mapped addresses (FPGAIO):
# BTN: 0x400 (word address)
# LED: 0x402 (word address)
#
# BTN[0]: set direction to right
# BTN[1]: pause
# BTN[2]: resume
# BTN[3]: set direction to left

init:
	c.li a0, 0				# a0 contains the 'direction'; 0 = left, 1 = right
							# when the edge LEDs are reached, the running lights
							# simply 'restarts' at the other edge LED.
							# default direction is left
	
	c.li a1, 1				# a1 contains the LEDs run state. 1 = running, 0 = paused.
	c.li a2, 1				# a2 contains the LEDs currently on. LED[0] on by default
	
	addi sp, x0, 0x400		# sp contains the address of FPGAIO (starting at word-address 0x400)
	c.slli sp, 2

	c.swsp a2, 2			# turn on LED[0]

delay_init:
	lui s0, 0x00beb			# s0 contains the delay constant
	addi t0, x0, 0x610		# set to 0.5s * 50MHz
	c.slli t0, 1
	c.add s0, t0

delay:
	c.addi s0, -1			# decrement
	c.bnez s0, delay		# if s0 == 0, go to next part of code

	c.beqz a1, delay_init	# check run state. if paused, repeat the loop
	c.beqz a0, shiftleft	# check direction

shiftright:
	c.li t0, 1
	beq a2, t0, sr_wrap		# if LED[0] is on, turn on LED[3] next. Else, shift right
	c.srli a2, 1			# shift right
	c.j store

	sr_wrap:
	c.li a2, 8				# turn on LED[3]
	c.j store

shiftleft:
	c.li t0, 8
	beq a2, t0, sl_wrap		# if LED[3] is on, turn on LED[0] next. Else, shift left
	c.slli a2, 1			# shift left
	c.j store

	sl_wrap:
	c.li a2, 1

store:
c.swsp a2, 2
c.j delay_init			# go back to looping