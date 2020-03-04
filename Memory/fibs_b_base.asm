addi x5, x0, 184
sw x0, 0(x0)
addi x1, x0, 1
sw x1, 4(x0)
addi x4, x0, 8
lw x1, -8(x4)
lw x2, -4(x4)
add x3, x2, x1
sw x3, 0(x4)
addi x4, x4, 4
beq x4, x5, Exit_B
jal x0, Fibs_B
sw x4, 0(x0)
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
addi x5, x0, 184
sw x0, 0(x0)
addi x1, x0, 1
sw x1, 4(x0)
addi x4, x0, 8
lw x1, -8(x4)
lw x2, -4(x4)
add x3, x2, x1
sw x3, 0(x4)
addi x4, x4, 4
beq x4, x5, Exit_B
jal x0, Fibs_B
sw x4, 0(x0)
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
