#testbench for baseline processor - IBS types
#instructions ordered properly
#no hazards as of now
#NOP = addi x0, x0, 0

#LUI
lui x1, 0x4

addi x0, x0, 0
addi x0, x0, 0

#ADDI
addi x10, x0, 66
addi x11, x1, 66

addi x0, x0, 0
addi x0, x0, 0

sw x10, 0(x0)
sw x11, 4(x0)

#SLTI
slti x12, x1, -1
slti x13, x1, 14

addi x0, x0, 0
addi x0, x0, 0

sw x12, 8(x0)
sw x13, 12(x0)

#SLTIU
sltiu x10, x1, -2
sltiu x11, x1, 20

addi x0, x0, 0
addi x0, x0, 0

sw x10, 16(x0)
sw x11, 20(x0)

#XORI
xori x12, x1, 14

addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

sw x12, 24(x0)

#ORI
ori x10, x1, 8

addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

sw x10, 28(x0)

#ANDI
andi x11, x1, 12

addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

sw x11, 32(x0)

#SLLI
slli x12, x1, 2
slli x13, x1, 4

addi x0, x0, 0
addi x0, x0, 0

sw x12, 36(x0)
sw x13, 40(x0)

#SRLI
srli x10, x1, 1
srli x11, x1, 2

addi x0, x0, 0
addi x0, x0, 0

sw x10, 44(x0)
sw x11, 48(x0)

#SRAI
srai x12, x1, 3
srai x13, x1, 5

addi x0, x0, 0
addi x0, x0, 0

sw x12, 52(x0)
sw x13, 56(x0)

#LB
lb x10, 0(x0)

#LBU
lbu x14, 16(x0)

#LH
lh x11, 2(x0)

#LHU
lhu x13, 16(x0)

#LW
lw x12, 16(x0)

#SB
sb x10, 60(x0)
sb x14, 61(x0)

#SH
sh x11, 62(x0)
sh x13, 64(x0)

#SW
sw x12, 68(x0)


#BRANCH INSTRUCTIONS
#beq, bne, blt, bge, bltu, bgeu

addi x22, x0, 5
addi x21, x0, 5
addi x10, x0, 5
addi x11, x0, 5
addi x12, x0, 3
addi x13, x0, 5
addi x14, x0, 5
addi x15, x0, 5


beq x10, x0, beqtest1
addi x10, x10, 1

beqtest1:

beq x11, x11, beqtest2
addi x11, x11, 1

beqtest2:

addi x11, x0, 2

loop1:
addi x12, x12, 1
bne x12, x22, loop1


loop2:
addi x13, x13, 1
blt x13, x1, loop2

addi x13, x0, 10

loop3:
addi x14, x14, -1
bge x14, x1, loop3

addi x14, x0, 1

loop4:
addi x15, x15, 1
bltu x15, x1, loop4

addi x15, x0, 10

loop5:
addi x22, x22, -1
bgeu x22, x1, loop5



addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
