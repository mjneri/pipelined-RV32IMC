.data 0

.word 1024

.data 0x20

.word -80

.data 0x80
.asciz "00000000000000000000000000000000000000"

.text
main:
#addi sp, sp, -4
#lui t1, 0x0
#addi t1, zero, 1
#addi t2, zero, 0x24
#sw t1, 0(sp)
#sw t2, 4(sp)
#jal itoa
#addi t1, zero, -178
#addi t2, zero, 0x4
#addi sp, sp, -8
#sw t1, 0(sp)
#sw t2, 4(sp)
#jal itoa

addi sp, sp, -8
addi t1, zero, 0x80
sw t1, 0(sp)
jal atoi
sw a7, 0x60

f_loop:
jal zero, f_loop

itoa:
# int length = itoa(int input, char *output)
# inputs:
# sp address: input integer
# sp + 4 address: pointer to result
# outputs:
# a7: length of result


# registers
# a7			# string length
addi t5, zero, 10	# constant 10 for division
addi t0, zero, 32	# internal loop counter
# t0, t2, t6 set as arbitrary registers
# t4 set as minimum value (-2^31) flag

lw t3, 0(sp)		# load input
lw t1, 4(sp)		# load output address -- equivalent to c.lwsp t1, 1

# check special case (0x80000000 = -2^31)
lui t4, 0x80000
bne t3, t4, skip_floor
addi t2, zero, 0x2d
sw t2, 0(t1)		# write '-' to string
addi t1, t1, 1		
addi t3, t3, 1		# add 1 to allow an absolute value
sub t3, zero, t3
addi t4, zero, 1	# set minimum value flag
jal zero, itoa_pos_skip
skip_floor:

# check sign bit
addi t6, t3, 0
srli t6, t6, 31
beqz t6, itoa_pos_skip

addi t2, zero, 0x2d
sw t2, 0(t1)		# write '-' to string
addi t1, t1, 1		# increment pointer
sub t3, zero, t3	# get absolute value of number

itoa_pos_skip:

# division loop
addi t6, zero, 0	# initialize counter to 0
digit_loop:
rem t2, t3, t5		# get t3 % 10
addi t6, t6, 1
addi sp, sp, -1
sb t2, 0(sp)
div t3, t3, t5		# divide current t3 by 10
bnez t3, digit_loop

save_loop:
lb t2, 0(sp)
addi t2, t2, 0x30	# add 0x30 to get ASCII value
sb t2, 0(t1)
addi sp, sp, 1
addi t1, t1, 1
addi t6, t6, -1
bnez t6, save_loop

# handle special case (add 1 to absolute value)
beqz t4, skip_special_case
addi t2, t2, 1
sb t2, -1(t1)
skip_special_case:

# get length
lw t3, 4(sp)
sub a7, t3, t1

jalr zero, ra, 0

atoi:
# int output = atoi(char *input)
# error behavior currently just returning -1 on any handled error, and undefined behavior for any uncaught overflows
# input:
# sp address: pointer to string
# output
# a7: integer output

addi a7, zero, 0
# temporary registers (t0 ~ t5)
addi t0, zero, 10	# multiplier and length of longest possible integer string, a very useful number in many contexts
addi t1, zero, 0	# length counter
addi t2, zero, 0x2D	# '-' constant, reused later on as a temp register
lw t3, 0(sp)		# address of string
addi t5, zero, 0	# negative flag

# check sign
lb t4, 0(t3)		# first character
bne t2, t4, atoi_pos_skip
addi t3, t3, 1		# increment pointer
addi t5, zero, 1	# set negative flag

atoi_pos_skip:
addi t2, zero, 0x30	# set minimum constant
atoi_loop:
bgt t1, t0, atoi_error_exit	# error if past 10 characters (overflow)
lb t4, 0(t3)
beqz t4, atoi_loop_end	# exit on null character
blt t4, t2, atoi_error_exit	# invalid character
addi t4, t4, -48		# extract numeric value from potential ASCII digits
bge t4, t0, atoi_error_exit	# also an invalid character outside these bounds

# check if negative flag is set
beqz t5, atoi_skip_negation
sub t4, zero, t4	# negate the value
atoi_skip_negation:

mul a7, a7, t0		# multiply current sum by multiplier
add a7, a7, t4		# add new digit to current sum

addi t1, t1, 1
addi t3, t3, 1
jal zero, atoi_loop

atoi_loop_end:


# exit since a7 already has the value
jalr zero, ra, 0

atoi_error_exit:
addi a7, zero, -1
jalr zero, ra, 0
