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
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
bne x10, x0, loop1

loop2:
addi x11, x2, -1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
beq x11, x0, loop2

loop3:
addi x12, x3, 1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
blt x12, x4, loop3

loop4:
addi x13, x6, -1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
bge x13, x5, loop4

loop5:
addi x14, x7, 1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
bltu x14, x8, loop5

loop6:
addi x15, x9, 1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
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