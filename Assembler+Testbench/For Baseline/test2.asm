#testbench for baseline processor - IBS types
#instructions ordered properly
#no hazards as of now
#NOP = addi x0, x0, 0

#LUI
lui x1, 0x4
lui x20, 0x2

addi x0, x0, 0
addi x0, x0, 0

#ADDI
addi x10, x0, 66
addi x11, x1, 66

addi x0, x0, 0
addi x0, x0, 0

sw x10, 0(x20)
sw x11, 4(x20)

#SLTI
slti x12, x1, -1
slti x13, x1, 14

addi x0, x0, 0
addi x0, x0, 0

sw x12, 8(x20)
sw x13, 12(x20)

#SLTIU
sltiu x10, x1, -2
sltiu x11, x1, 20

addi x0, x0, 0
addi x0, x0, 0

sw x10, 16(x20)
sw x11, 20(x20)

#XORI
xori x12, x1, 14

addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

sw x12, 24(x20)

#ORI
ori x10, x1, 8

addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

sw x10, 28(x20)

#ANDI
andi x11, x1, 12

addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

sw x11, 32(x20)

#SLLI
slli x12, x1, 2
slli x13, x1, 4

addi x0, x0, 0
addi x0, x0, 0

sw x12, 36(x20)
sw x13, 40(x20)

#SRLI
srli x10, x1, 1
srli x11, x1, 2

addi x0, x0, 0
addi x0, x0, 0

sw x10, 44(x20)
sw x11, 48(x20)

#SRAI
srai x12, x1, 3
srai x13, x1, 5

addi x0, x0, 0
addi x0, x0, 0

sw x12, 52(x20)
sw x13, 56(x20)

#LB
lb x10, 0(x20)

#LBU
lbu x14, 16(x20)

#LH
lh x11, 2(x20)

#LHU
lhu x13, 16(x20)

#LW
lw x12, 16(x20)

#SB
sb x10, 60(x20)
sb x14, 61(x20)

#SH
sh x11, 62(x20)
sh x13, 64(x20)

#SW
sw x12, 68(x20)


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

