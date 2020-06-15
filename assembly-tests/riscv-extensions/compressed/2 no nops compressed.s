#Compressed Instructions
#MV, LWSP, SWSP, SUB, XOR, OR, AND, ADD

#MV
c.addi x18, 31
c.addi x16, -31
c.mv x19, x18
c.mv x8, x16
sw x19, 0(x15)
c.sw x8, 4(x15)

#LWSP & SWSP
addi x2, x0, 0
c.lwsp x8, 1
sw x8, 8(x15)
c.swsp x8, 3
addi x2, x0, 4
c.lwsp x9, 0
sw x9, 16(x15)
c.swsp x9, 4

#SUB
c.addi x8, 1
c.addi x9, -1
c.addi x10, -6
c.addi x11, 15
c.addi x12, 9
c.sub x8, x9 # x8 = 2 (p - n)
c.sub x9, x9 # x7 = 0 (n - n)
c.sub x10, x8 # x8 = -5 (n - p)
c.sub x11, x10 # x9 = 20 (p - n)
c.sub x12, x11 # x10 = -11 (p - p)
c.sw x8, 24(x15)
sw x9, 28(x15)
c.sw x10, 32(x15)
c.sw x11, 36(x15)
sw x12, 40(x15)

#XOR
c.li x8, -3
c.li x9, 2
c.li x10, 5
c.li x11, -4
c.li x12, 7
c.xor x9, x10 #pp
c.xor x10, x8 #pn
c.xor x8, x12 #np
c.xor x11, x11 #nn
c.sw x9, 44(x15)
c.sw x10, 48(x15)
c.sw x8, 52(x15)
c.sw x11, 56(x15)

#OR
c.addi x8, 2
c.addi x9, 3
c.addi x10, -4
c.addi x11, -7
c.or x9, x8 #pp
c.or x10, x8 #np
c.or x8, x11 #pn
c.or x11, x11 #nn
sw x9, 60(x15)
sw x10, 64(x15)
sw x8, 68(x15)
sw x11, 72(x15)

#AND
c.li x8, 2
c.li x9, 3
c.li x10, -4
c.li x11, -5
c.and x9, x8  #pp
c.and x10, x8 #np
c.and x8, x11 #pn
c.and x11, x11 #nn
sw x9, 76(x15)
sw x10, 80(x15)
sw x8, 84(x15)
sw x11, 88(x15)

#ADD
c.addi x20, 10
c.addi x21, 30
c.addi x22, -31
c.addi x14, -5
c.lw x10, 44(x15)
c.addi x4, 15
c.add x20, x14 #pn
c.add x21, x10 #pp
c.add x22, x4 #np
c.add x14, x22 #nn
sw x20, 92(x15)
sw x21, 96(x15)
sw x22, 100(x15)
sw x14, 104(x15)