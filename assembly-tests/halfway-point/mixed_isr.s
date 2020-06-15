# MIXED TEST 1 - ISR EDITION
# MIX OF BASE I, M, AND C INSTRUCTIONS

# SHOULD BEGIN STORES AT 1000 AS OFFSET



c.jal storehere 

c.jal anything

c.jal loadhere


# SUBROUTINE FOR STORES
storehere:
        sw x1, 1000(x0)
        sw x2, 1004(x0)
        sw x3, 1008(x0)
        sw x4, 1012(x0)
        sw x5, 1016(x0)
        sw x6, 1020(x0)
        sw x7, 1024(x0)
        sw x8, 1028(x0)
        sw x9, 1032(x0)
        sw x10, 1036(x0)
        sw x11, 1040(x0)
        sw x12, 1044(x0)
        sw x13, 1048(x0)
        sw x14, 1052(x0)
        sw x15, 1056(x0)
        sw x16, 1060(x0)
        sw x17, 1064(x0)
        sw x18, 1068(x0)
        sw x19, 1072(x0)
        sw x20, 1076(x0)
        sw x21, 1080(x0)
        sw x22, 1084(x0)
        sw x23, 1088(x0)
        sw x24, 1092(x0)
        sw x25, 1096(x0)
        sw x26, 1100(x0)
        sw x27, 1104(x0)
        sw x28, 1108(x0)
        sw x29, 1112(x0)
        sw x30, 1116(x0)
        sw x0, 1120(x0)
        c.jr x1


anything:
        addi x15, x0, 3
        addi x3, x0, 0x402
        slli x3, x3, 2  

        running:
                c.addi x15, -1
                addi x5, x0, 1
               
                sw x5, 0(x3)

                addi x4, x0, 0x1a0        
                lui x4, 0xcca
                # addi x4, x0, 10 
                loop1:
                c.addi x4, -1
                bne x4, x0, loop1

                add x5, x0, x0
                #srli x5, x5, 1
                sw x5, 0(x3)

                addi x4, x0, 0x1a0        
                lui x4, 0xcca
                # addi x4, x0, 10 
                loop2:
                c.addi x4, -1
                bne x4, x0, loop2

        c.bnez x15, running

        sw x0, 0(x3)

        c.jr x1

loadhere:
        lw x1, 1000(x0)
        lw x2, 1004(x0)
        lw x3, 1008(x0)
        lw x4, 1012(x0)
        lw x5, 1016(x0)
        lw x6, 1020(x0)
        lw x7, 1024(x0)
        lw x8, 1028(x0)
        lw x9, 1032(x0)
        lw x10, 1036(x0)
        lw x11, 1040(x0)
        lw x12, 1044(x0)
        lw x13, 1048(x0)
        lw x14, 1052(x0)
        lw x15, 1056(x0)
        lw x16, 1060(x0)
        lw x17, 1064(x0)
        lw x18, 1068(x0)
        lw x19, 1072(x0)
        lw x20, 1076(x0)
        lw x21, 1080(x0)
        lw x22, 1084(x0)
        lw x23, 1088(x0)
        lw x24, 1092(x0)
        lw x25, 1096(x0)
        lw x26, 1100(x0)
        lw x27, 1104(x0)
        lw x28, 1108(x0)
        lw x29, 1112(x0)
        lw x30, 1116(x0)
        lw x0, 1120(x0)
        lui x21, 0xade1b
        addi x21, x21, 0x055
        addi x22, x0, 0x3ff
        slli x22, x22, 2
        sw x21, 0(x22)
        sw x0, 0(x22)

        uret
        # ADELBOSS



