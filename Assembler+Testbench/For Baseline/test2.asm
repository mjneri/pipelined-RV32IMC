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


#BRANCH INSTRUCTIONS
