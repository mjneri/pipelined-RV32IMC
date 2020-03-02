addi x1, x0, 5
slti x2, x1, 6
slti x3, x1, -1
sltiu x4, x1, 6
sltiu x5, x1, 4
xori x6, x1, 5
ori x7, x1, 10
andi x8, x1, 15
slli x9, x1, 4
srli x10, x9, 4
addi x11, x0, -5
srai x12, x11, 4
addi x13, x0, 0xFF
jal x1, beqtest1
#jalr x2, 12(x3)
sb x13, 0(x0)
sh x13, 4(x0)
sw x13, 8(x0)
lb x14, 8(x0)
lh x15, 8(x0)
lw x16, 8(x0)
lbu x17, 8(x0)
lhu x18, 8(x0)

addi x19, x0, 5
beq x19, x0, beqtest1
addi x19, x19, 1
beqtest1:

addi x20, x0, 5
beq x20, x1, beqtest2
addi x20, x20, 1
beqtest2:

addi x21, x0, 1
loop1:
addi x21, x21, 1
bne x21, x1, loop1

addi x22, x0, 1
loop2:
addi x22, x22, 1
blt x22, x1, loop2

addi x23, x0, 10
loop3:
addi x23, x23, -1
bge x23, x1, loop3

addi x24, x0, 1
loop4:
addi x24, x24, 1
bltu x24, x1, loop4

addi x25, x0, 10
loop5:
addi x25, x25, -1
bgeu x25, x1, loop5
