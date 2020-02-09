# WB > ID test cases
# 2 NOPS IN BETWEEN
# X's in excel sheets test cases not included

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
addi x0, x0, 0
sub x11, x10, x2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 0(x0) ##

# R-type > I-type
sub x12, x4, x3
addi x0, x0, 0
addi x0, x0, 0
addi x13, x12, 2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x13, 4(x0) ##

# R-type > JALR
add x14, x6, x1
addi x0, x0, 0
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
addi x0, x0, 0
lw x11, 4(x10)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 12(x0) ##

# R-type > B-type
add x12, x0, x1
addi x0, x0, 0
addi x0, x0, 0
bne x12, x0, pass
sub x12, x12, x1

pass:
sub x13, x6, x3
addi x0, x0, 0
addi x0, x0, 0
beq x13, x13, pass2
sll x14, x13, x1

pass2:

# R-type > S-type
add x10, x6, x6 
addi x0, x0, 0
addi x0, x0, 0
sw x10, 16(x0)

##############################################################

# I-type > R-type
addi x11, x0, 12
addi x0, x0, 0
addi x0, x0, 0
sub x12, x11, x2
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x12, 20(x0)

# I-type > I-type
addi x10, x0, -15
addi x0, x0, 0
addi x0, x0, 0
slti x11, x10, -14 
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x11, 24(x0)

# I-type > JALR
slli x12, x4, 1
addi x0, x0, 0
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
addi x0, x0, 0
lw x14, 0(x10)
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
sw x14, 28(x0) 

# I-type > B-type 
slti x15, x4, 44
addi x0, x0, 0
addi x0, x0, 0
beq x15, x1, pass3
slli x16, x15, 1

pass3:
addi x17, x0, 1
addi x0, x0, 0
addi x0, x0, 0
bne x17, x0, pass4

pass4:

# I-type > S-type
srli x18, x7, 2
addi x0, x0, 0
addi x0, x0, 0
sw x18, 32(x0)

##############################################################

# Loads > R-type
# Loads > I-type
# Loads > JALR
# Loads > Loads
# Loads > B-type 
# Loads > S-type

##############################################################

# LUI > R-type
# LUI > I-type
# LUI > JALR
# LUI > Loads
# LUI > B-type 
# LUI > S-type

##############################################################

# AUIPC > R-type
# AUIPC > I-type
# AUIPC > JALR
# AUIPC > Loads
# AUIPC > B-type 
# AUIPC > S-type

##############################################################

# JAL > R-type
# JAL > I-type
# JAL > JALR
# JAL > Loads
# JAL > B-type 
# JAL > S-type

##############################################################

# JALR > R-type
# JALR > I-type
# JALR > JALR
# JALR > Loads
# JALR > B-type 
# JALR > S-type