#testbench for baseline processor - IBS types
#NOP = addi x0, x0, 0

#LUI
lui x1, 0x4
lui x20, 0x2

# addi x0, x0, 0
# addi x0, x0, 0

#ADDI
addi x10, x0, 66
addi x11, x1, 66

# addi x0, x0, 0
# addi x0, x0, 0

sw x10, 0(x20)
sw x11, 4(x20)

#SLTI
slti x12, x1, -1
slti x13, x1, 14

# addi x0, x0, 0
# addi x0, x0, 0

sw x12, 8(x20)
sw x13, 12(x20)

#SLTIU
sltiu x10, x1, -2
sltiu x11, x1, 20

# addi x0, x0, 0
# addi x0, x0, 0

sw x10, 16(x20)
sw x11, 20(x20)

#XORI
xori x12, x1, 14

# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

sw x12, 24(x20)

#ORI
ori x10, x1, 8

# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

sw x10, 28(x20)

#ANDI
andi x11, x1, 12

# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0

sw x11, 32(x20)

#SLLI
slli x12, x1, 2
slli x13, x1, 4

# addi x0, x0, 0
# addi x0, x0, 0

sw x12, 36(x20)
sw x13, 40(x20)

#SRLI
srli x10, x1, 1
srli x11, x1, 2

# addi x0, x0, 0
# addi x0, x0, 0

sw x10, 44(x20)
sw x11, 48(x20)

#SRAI
srai x12, x1, 3
srai x13, x1, 5

# addi x0, x0, 0
# addi x0, x0, 0

sw x12, 52(x20)
sw x13, 56(x20)

#LB
lb x10, 0(x20)
addi x1, x10, 2         //  forwarding test 1
sb x1, 80(x20)

#LBU
lbu x14, 16(x20)

#LH
lh x11, 2(x20)

#LHU
lhu x13, 16(x20)

#LW
lw x12, 16(x20)
addi x24, x12, -2       //  forwarding test 2
sw x24, 84(x20)

#SB
sb x10, 60(x20)
sb x14, 61(x20)

#SH
sh x11, 62(x20)
sh x13, 64(x20)

#SW
sw x12, 68(x20)

addi x1, x0, 3
addi x2, x0, 1
addi x3, x0, 2
addi x4, x0, 5
addi x5, x0, 4
addi x6, x0, 6
addi x7, x0, 4
addi x8, x0, 7
addi x9, x0, 3

loop1:
addi x10, x1, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bne x10, x0, loop1

loop2:
addi x11, x2, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
beq x11, x0, loop2

loop3:
addi x12, x3, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
blt x12, x4, loop3

loop4:
addi x13, x6, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bge x13, x5, loop4

loop5:
addi x14, x7, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bltu x14, x8, loop5

loop6:
addi x15, x9, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bgeu x8, x15, loop6

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
