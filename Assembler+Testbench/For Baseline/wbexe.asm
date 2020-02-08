# WB > EXE test cases
# 1 NOP IN BETWEEN
# X's in excel sheets test cases not included
# (include adjacent Load + other inst w/ no NOP in between to test stalls)

# R-type > R-type
# R-type > I-type
# R-type > Loads
# R-type > B-type 
# R-type > S-type

# I-type > R-type
# I-type > I-type
# I-type > Loads
# I-type > B-type 
# I-type > S-type

# JALR > R-type
# JALR > I-type
# JALR > Loads
# JALR > B-type 
# JALR > S-type

# Loads > R-type
# Loads > I-type
# Loads > Loads
# Loads > B-type 
# Loads > S-type

# LUI > R-type
# LUI > I-type
# LUI > Loads
# LUI > B-type 
# LUI > S-type

# AUIPC > R-type
# AUIPC > I-type
# AUIPC > Loads
# AUIPC > B-type 
# AUIPC > S-type

# JAL > R-type
# JAL > I-type
# JAL > JALR
# JAL > Loads
# JAL > B-type 
# JAL > S-type