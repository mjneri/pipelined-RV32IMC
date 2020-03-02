addi x1, x0, 12
addi x2, x0, 8
addi x3, x0, 20
addi x4, x0, 31
addi x5, x0, 18
addi x6, x0, 5
addi x7, x0, 4
addi x8, x0, 20
addi x9, x0, 3


loop1:
addi x1, x1, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bne x1, x0, loop1
sw x1, 0(x0)

loop2:
addi x2, x2, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
sll x2, x2, x0
beq x11, x0, loop2
sw x2, 4(x0)

loop3:
addi x3, x3, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
srli x3, x3, 1 
blt x3, x4, loop3
sh x3, 6(x0)

loop4:
addi x6, x6, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bge x6, x5, loop4
sb x6, 9(x0) 

loop5:
addi x7, x7, 1

# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bltu x7, x8, loop5
sh x7, 10(x0)

loop6:
addi x9, x9, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bgeu x8, x9, loop6
sw x9, 12(x0)


addi x20, x0, -1
loop7:
srli x20, x20, 1
bne x20, x0, loop7

# ADE1BOSS
lui x21, 0xade1b
addi x21, x21, 0x055
addi x22, x0, 0x3ff
slli x22, x22, 2
sw x21, 0(x22)
sw x0, 0(x22)


# infinite loop
inf:
jal x0, inf