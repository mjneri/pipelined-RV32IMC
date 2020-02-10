# Inst(2R) -> Inst(2R)
addi x0, x0, -1
nop
nop
nop
slti x1, x0, 1
nop
nop
sltiu x2, x1, 2
nop
xori x3, x2, 0x7FF
ori x4, x3, 0x123
nop
andi x5, x4, 0x369
nop
nop
slli x6, x5, 2
nop
nop
nop
srli x7, x6, 4

# Inst(3R) -> Inst(3R)
sra x8, x3, x2 
nop
nop
nop
add x9, x8, x7
nop
nop
sub x10, x9, x8
nop
sll x11, x10, x1
slt x12, x12, x11
nop
sltu x13, x12, x11
nop
nop
xor x14, x11, x12
nop
nop
nop
srl x15, x14, x2

sw x0, 0(x0)
sw x1, 4(x0)
sw x2, 8(x0)
sw x3, 12(x0)
sw x4, 16(x0)
sw x5, 20(x0)
sw x6, 24(x0)
sw x7, 28(x0)
sw x8, 32(x0)
sw x9, 36(x0)
sw x10, 40(x0)
sw x11, 44(x0)
sw x12, 48(x0)
sw x13, 52(x0)
sw x14, 56(x0)
sw x15, 60(x0)

# L -> S
lw x16, 48(x0)
nop
nop
nop
sw x16, 64(x0)
lw x17, 52(x0)
nop
nop
sw x17, 68(x0)
lw x18, 56(x0)
nop
sw x18, 72(x0)
lw x19, 60(x0)
sw x19, 76(x0)

# L -> Inst -> S
lw x20, 48(x0)
nop
nop
nop
addi x20, x20, -100
sw x20, 80(x0)
lw x21, 52(x0)
nop
nop
addi x21, x21, -100
sw x21, 84(x0)
lw x22, 56(x0)
nop
addi x22, x22, -100
sw x22, 88(x0)
lw x23, 60(x0)
addi x23, x23, -100
sw x23, 92(x0)

# Inst -> L -> S

addi x24, x0, 48
nop
nop
nop
lw x24, 0(x24)
sw x24, 96(x0)
addi x25, x0, 48
nop
nop
lw x25, 4(x25)
sw x25, 100(x0)
addi x26, x0, 48
nop
lw x26, 8(x26)
sw x26, 104(x0)
addi x27, x0, 48
lw x27, 12(x27)
sw x27, 108(x0)
addi x28, x0, 60
lw x28, 8(x28)
nop
sw x28, 112(x0)
addi x29, x0, 60
lw x29, 12(x29)
nop
nop
sw x29, 116(x0)


jal x30, Save_PC
Save_PC:
sw x30, 120(x0)
lw x31, 120(x0)
jalr x0, x31, 12
xor x31, x29, x30
sw x31, 124(x0)

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
nop
nop
