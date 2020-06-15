# This program is used to test infinite loops that execute after
# a branch instruction. Ideally, even if the infinite loop is
# loaded into the pipeline already, if the branch instruction
# results in a correction of the pc address, the infinite loop
# should not cause the clock gates to close.
.text
main:
	c.li t0, 0
	c.addi t1, 9

loop:
	c.addi t0, 1
	bltu t0, t1, loop

inf:
	c.j inf
	c.nop
	c.nop
	c.nop
	c.nop