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
addi a0, x0, 0	#from c.li a0, 0				# a0 contains the 'direction'; 0 = left, 1 = right
# when the edge LEDs are reached, the running lights
# simply 'restarts' at the other edge LED.
# default direction is left

addi a1, x0, 1	#from c.li a1, 1				# a1 contains the LEDs run state. 1 = running, 0 = paused.
addi a2, x0, 1	#from c.li a2, 1				# a2 contains the LEDs currently on. LED[0] on by default

addi sp, x0, 0x400		# sp contains the address of FPGAIO (starting at word-address 0x400)
slli sp, sp, 2	#from c.slli sp, 2

sw a2, 8(x2)	#from c.swsp a2, 2			# turn on LED[0]

delay_init:
lui s0, 0x00beb			# s0 contains the delay constant
addi t0, x0, 0x610		# set to 0.5s * 50MHz
slli t0, t0, 1	#from c.slli t0, 1
add s0, s0, t0	#from c.add s0, t0

delay:
addi s0, s0, -1	#from c.addi s0, -1			# decrement
bne s0, x0, delay	#from c.bnez s0, delay		# if s0 == 0, go to next part of code

beq a1, x0, delay_init	#from c.beqz a1, delay_init	# check run state. if paused, repeat the loop
beq a0, x0, shiftleft	#from c.beqz a0, shiftleft	# check direction

shiftright:
addi t0, x0, 1	#from c.li t0, 1
beq a2, t0, sr_wrap		# if LED[0] is on, turn on LED[3] next. Else, shift right
srli a2, a2, 1	#from c.srli a2, 1			# shift right
jal x0, store	#from c.j store

sr_wrap:
addi a2, x0, 8	#from c.li a2, 8				# turn on LED[3]
jal x0, store	#from c.j store

shiftleft:
addi t0, x0, 8	#from c.li t0, 8
beq a2, t0, sl_wrap		# if LED[3] is on, turn on LED[0] next. Else, shift left
slli a2, a2, 1	#from c.slli a2, 1			# shift left
jal x0, store	#from c.j store

sl_wrap:
addi a2, x0, 1	#from c.li a2, 1

store:
sw a2, 8(x2)	#from c.swsp a2, 2
jal x0, delay_init	#from c.j delay_init			# go back to looping
