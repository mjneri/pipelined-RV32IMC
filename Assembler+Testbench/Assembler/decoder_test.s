##### COMPRESSED DECODER CHECK #####

### rs1', rs2', rd' registers ###
# x8 ~ x15
# s0 ~ s1, a0 ~ a5

label:
# Compressed instruction
c.lw x8, 32(x9)
# Equivalent base instruction
lw x8, 128(x9)

# this repeats

# sw
c.sw x10, 32(x10)
sw x10, 128(x10)

# j
c.j label
jal x0, label

# jal
c.jal label
jal x1, label

#jr
c.jr x6
jalr x0, 0(x6)

# jalr
c.jalr x6
jalr x1, 0(x6)

# beqz
c.beqz x11, label
beq x11, x0, label

# bnez
c.bnez x11, label
bne x11, x0, label

# li
c.li x20, 25
addi x20, x0, 25

# lui
c.lui x20, 4
lui x20, 4

# addi
c.addi x15, 7
addi x15, x15, 7

# addi16sp
c.addi16sp 1
addi x2, x2, 16

# addi4spn
c.addi4spn x12, 1
addi x12, x2, 4

# srli
c.srli x11, 5
srli x11, x11, 5

# srai
c.srai x11, 5
srai x11, x11, 5

# andi
c.andi x11, 5
andi x11, x11, 5

# mv
c.mv x18, x19
add x18, x0, x19

# add
c.add x18, x19
add x18, x18, x19

# and
c.and x10, x9
and x10, x10, x9

# or
c.or x10, x9
or x10, x10, x9

# xor
c.xor x10, x9
xor x10, x10, x9

# sub
c.sub x10, x9
sub x10, x10, x9

# nop
c.nop
nop