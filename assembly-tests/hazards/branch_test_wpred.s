addi x1, x0, 12
addi x2, x0, 8
addi x3, x0, 20
addi x4, x0, 31
addi x5, x0, 18
addi x6, x0, 5
addi x7, x0, 4
addi x8, x0, 20
addi x9, x0, 3
lui x30, 0xc0e19
addi x31, x0, 0x400
slli x31, x31, 1
add x30, x30, x31

loop1:
addi x1, x1, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bne x1, x0, loop1
jal x0, loop2
sw x1, 0(x0)

loop2:
addi x2, x2, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
sll x2, x2, x0
beq x2, x0, loop2
jal x0, loop3
sw x2, 4(x0)

loop3:
addi x3, x3, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
#srli x3, x3, 1 
blt x3, x4, loop3
jal x0, loop4
sw x3, 8(x0)

loop4:
addi x6, x6, -1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bge x6, x5, loop4
jal x0, loop5
sw x6, 12(x0) 

loop5:
addi x7, x7, 1

# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bltu x7, x8, loop5
jal x0, loop6
sw x7, 16(x0)

loop6:
addi x9, x9, 1
# addi x0, x0, 0
# addi x0, x0, 0
# addi x0, x0, 0
bgeu x8, x9, loop6
jal x0, loop7a
sw x9, 20(x0)

loop7a:
addi x20, x0, -1
loop7:
srli x20, x20, 1
bne x20, x0, loop7
jal x0, loopend
sw x5, 24(x0)

# ADE1BOSS
loopend:
sw x30, 28(x0)
sw x30, 32(x0)
sw x30, 36(x0)
sw x30, 40(x0)
sw x30, 44(x0)
sw x30, 48(x0)
sw x30, 52(x0)

lui x21, 0xade1b
addi x21, x21, 0x055
addi x22, x0, 0x3ff
slli x22, x22, 2
sw x21, 0(x22)
sw x0, 0(x22)


# infinite loop
inf:
jal x0, inf
