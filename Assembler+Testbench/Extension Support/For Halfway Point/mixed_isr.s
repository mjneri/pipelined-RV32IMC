# MIXED TEST 1 - ISR EDITION
# MIX OF BASE I, M, AND C INSTRUCTIONS

# SHOULD BEGIN STORES AT 1000 AS OFFSET



c.jal storehere 


# SUBROUTINE FOR STORES
storehere:
sw x1, 1000(x31)
sw x2, 1004(x31)
sw x3, 1008(x31)
sw x4, 1012(x31)
sw x5, 1016(x31)
sw x6, 1020(x31)
sw x7, 1024(x31)
sw x8, 1028(x31)
sw x9, 1032(x31)
sw x10, 1036(x31)
sw x11, 1040(x31)
sw x12, 1044(x31)
sw x13, 1048(x31)
sw x14, 1052(x31)
sw x15, 1056(x31)
sw x16, 1060(x31)
sw x17, 1064(x31)
sw x18, 1068(x31)
sw x19, 1072(x31)
sw x20, 1076(x31)
sw x21, 1080(x31)
sw x22, 1084(x31)
sw x23, 1088(x31)
sw x24, 1092(x31)
sw x25, 1096(x31)
sw x26, 1100(x31)
sw x27, 1104(x31)
sw x28, 1108(x31)
sw x29, 1112(x31)
sw x30, 1116(x31)
sw x31, 1120(x31)










# END
# lui x21, 0xade1b
# addi x21, x21, 0x055
# addi x22, x0, 0x3ff
# slli x22, x22, 2
# sw x21, 0(x22)
# sw x0, 0(x22)


