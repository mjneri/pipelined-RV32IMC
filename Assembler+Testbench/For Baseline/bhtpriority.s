# Test program for checking how the BHT handles prioritized writes.
.text
main:
	addi a0, x0, 20
start:
	# Due to how the BHT handles priority, what should happen here
	# is that the prediction bits for beq will not be updated
	# at least once.
	beq x0, x0, target		# ALWAYS TAKEN
	bne x0, x0, target		# ALWAYS NOT TAKEN
target:
	addi a0, a0, -1			# Decrement a0
	beq a0, x0, inf			# Jump to inf once a0 == x0
	jal x0, start			# jump back to start
inf:
	jal x0, inf