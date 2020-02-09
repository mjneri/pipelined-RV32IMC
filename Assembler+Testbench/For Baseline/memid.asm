# MEM > ID test cases
# 1 NOP IN BETWEEN
# X's in excel sheets test cases not included
# (include adjacent Load+JALR w/ no NOP in between to test stalls)


lui x1, 0x1
lui x2, 0x2
lui x3, 0x3
lui x4, 0x19 #25
lui x5, 0xFFCD #-50
lui x6, 0x29 #41
lui x7, 0x24


# R-type > R-type
add x10, x1, x2
addi x0, x0, 0
sub x11, x10, x2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 0(x0) ##

# R-type > I-type
sub x12, x4, x3
addi x0, x0, 0
addi x13, x12, 2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x13, 4(x0) ##

# R-type > JALR
add x14, x6, x1
addi x0, x0, 0
jalr x15, 22(x14)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x15, 8(x0) ##

# R-type > Loads
add x10, x1, x3
addi x0, x0, 0
lw x11, 4(x10)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 12(x0) ##

# R-type > B-type 
add x12, x0, x1
addi x0, x0, 0
bne x12, x0, pass
sub x12, x12, x1

pass:
sub x13, x6, x3
addi x0, x0, 0
beq x13, x13, pass2
sll x14, x13, x1

pass2:
# R-type > S-type
add x10, x6, x6 
addi x0, x0, 0
sw x10, 16(x0)

##############################################################

# I-type > R-type
addi x11, x0, 12
addi x0, x0, 0
sub x12, x11, x2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x12, 20(x0)

# I-type > I-type
addi x10, x0, -15
addi x0, x0, 0
slti x11, x10, -14 
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 24(x0)

# I-type > JALR
slli x12, x4, 1
addi x0, x0, 0
jalr x13, 282(x12)
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
addi x0, x0, 0
addi x0, x0, 0

# I-type > Loads
addi x10, x0, 12
addi x0, x0, 0
lw x14, 0(x10)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x14, 28(x0) 

# I-type > B-type 
slti x15, x4, 44
addi x0, x0, 0
beq x15, x1, pass3
slli x16, x15, 1

pass3:
addi x17, x0, 1
addi x0, x0, 0
bne x17, x0, pass4

pass4:

# I-type > S-type
srli x18, x7, 2
addi x0, x0, 0
sw x18, 32(x0)


##############################################################

# LUI > R-type
lui x10, 0x5
addi x0, x0, 0
or x11, x4, x10
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 36(x0)

# LUI > I-type
lui x12, 0x2
addi x0, x0, 0
slli x13, x12, 2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x13, 40(x0)

# LUI > JALR
lui x14, 0x11c
addi x0, x0, 0
jalr x15, 316(x14)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# LUI > Loads
lui x10, 0x14
addi x0, x0, 0
lw x11, 4(x10)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 44(x0)

# LUI > B-type 
lui x12, 0x2
addi x12, x12, 0
beq x12, x2, pass5
addi x12, x12, 0

pass5:

# LUI > S-type
lui x13, 0x4
addi x10, x10, 0
sw x12, 44(x13)

##############################################################

# AUIPC > R-type
auipc x1, 0x2
addi x0, x0, 0
and x14, x6, x1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x14, 52(x0)

lui x1, 0x1
# AUIPC > I-type
auipc x1, 0x6
addi x0, x0, 0
srli x15, x1, 2 
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x14, 56(x0)

# AUIPC > JALR
auipc x2, 0x2
addi x0, x0, 0
jalr x15, 20(x2)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

lui x2, 0x2
# AUIPC > Loads
auipc x2, 0x3
addi x0, x0, 0
lw x16, 0(x2)
sw x16, 60(x0)

# AUIPC > B-type 
auipc x3, 0x1
addi x0, x0, 0
bne x3, x0, pass6
addi x3, x3, 1

pass6:
lui x1, 0x1
lui x3, 0x3
# AUIPC > S-type
auipc x3, 0x2
addi x0, x0, 0
sw x3, 64(x0)

##############################################################

# JAL > R-type
jal x10, jump1
addi x0, x0, 0
add x10, x10, x0

jump1:
addi x0, x0, 0

xor x10, x10, x4
sw x10, 68(x0)

# JAL > I-type
jal x11, jump2
addi x0, x0, 0
addi x12, x11, 1

jump2:
addi x0, x0, 0
srai x11, x11, 3
sw x11, 72(x0)

# JAL > JALR
jal x12, jump3
addi x0, x0, 0
sub x10, x10, x0

jump3:
addi x0, x0, 0
jalr x13, 4(x12)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

# JAL > Loads
jal x14, jump4
addi x0, x0, 0

jump4:
addi x0, x0, 0
lw x15, -28(x14)
sw x15, 76(x0)

# JAL > B-type 
jal x16, jump5

jump5:
addi x0, x0, 0
bne x16, x0, pass7
sra x16, x16, x1

pass7:
sw x16, 80(x0)

# JAL > S-type
jal x17, jump6:
#srai x17, x17, 2

jump6:
addi x0, x0, 0
sw x17, 84(x0)

##############################################################

# Loads > R-type
lw x10, 4(x0)
addi x0, x0, 0 
slt x11, x0, x10
sw x11, 120(x0)

# Loads > I-type
lw x12, 8(x0)
addi x0, x0, 0
slli x13, x12, 2
sw x13, 124(x0)

jal x10, jumpa
jumpa:
# Loads > JALR
lw x14, 12(x0)
addi x0, x0, 0 
jalr x15, 8(x10)
addi x0, x0, 0 
addi x0, x0, 0 
addi x0, x0, 0

# Loads > Loads
lw x16, 16(x0)
addi x0, x0, 0
lw x17, 0(x16)
sw x17, 128(x0)

# Loads > B-type
lw x10, 20(x0)
addi x0, x0, 0
bne x10, x0, pass10
addi x0, x0, 0
pass10:
sw x10, 132(x0)

# Loads > S-type
lw x11, 24(x0)
addi x0, x0, 0
sw x11, 136(x0)

##############################################################

jal x16, jumpx
jumpx:
# JALR > R-type
jalr x17, 4(x16)
addi x0, x0, 0
slt x18, x0, x17
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x18, 88(x0)

# JALR > I-type
jalr x10, 4(x17)
addi x0, x0, 0
slli x11, x10, 299 
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 96(x0)

# JALR > JALR
jalr x12, 28(x10)
addi x0, x0, 0
jalr x13, 4(x12)
sw x13, 100(x0)

# JALR > Loads
jalr x14, 12(x12)
addi x0, x0, 0
lh x15, 22(x0)
sh x15, 102(x0)

# JALR > B-type 
jalr x16, 12(x14)
addi x0, x0, 0
bne x16, x0, pass8:
addi x16, x16, -7

pass8:
beq x16, x16, pass9:
addi x16, x16, 2

pass9:
sw x16, 104(x0)

# JALR > S-type
jalr x17, 24(x16)
addi x0, x0, 0
sw x17, 108(x0)
sw x16, 112(x0)


# LOAD + JALR
lw x10, 16(x0)
jalr x11, (x10)
addi x0, x0, 0

