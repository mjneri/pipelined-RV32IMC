# This program is used to test infinite loops that execute after
# a branch instruction. Ideally, even if the infinite loop is
# loaded into the pipeline already, if the branch instruction
# results in a correction of the pc address, the infinite loop
# should not cause the clock gates to close.
.text
main:
addi t0, x0, 0	#from c.li t0, 0
addi t1, t1, 9	#from c.addi t1, 9

loop:
addi t0, t0, 1	#from c.addi t0, 1
bltu t0, t1, loop

inf:
jal x0, inf	#from c.j inf
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
