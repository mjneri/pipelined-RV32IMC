addi:
c.addi x1, 1 # x1 = 1
c.addi x2, -1 # x2 = -1 
c.addi x3, -1 # x3 = 0  (p + n)
c.addi x4, 15 # x4 = 16 (p + p)
c.addi, x5, -3 # x5 = -4 (n + n)
sw x1, 0(x0)
sw x2, 4(x0)
sw x3, 8(x0)
sw x4, 12(x0)
sw x5, 16(x0)

sub:
c.addi x8, 1
c.addi x9, -1
c.addi x10, -3
c.addi x11, 15
c.addi x12, 9
c.sub x8, x9 # x8 = 2 (p - n)
c.sub x9, x9 # x7 = 0 (n - n)
c.sub x10, x8 # x8 = -5 (n - p)
c.sub x11, x10 # x9 = 20 (p - n)
c.sub x12, x11 # x10 = -11 (p - p)
sw x8, 20(x0)
sw x9, 24(x0)
sw x10, 28(x0)
sw x11, 32(x0)
sw x12, 36(x0)

xor:
c.addi x8, -3
c.addi x9, 2
c.addi x10, 5
c.xor x9, x8 # x9 = -3
c.xor x10, x8 # x10 = -1
sw x9, 40(x0)
sw x10, 44(x0)

or:
c.addi x8, 2
c.addi x9, 3
c.addi x10, -1
c.or x9, x8 # x9 = 1
c.or x10, x8 # x10 = -1
sw x9, 48(x0)
sw x10, 52(x0)

and:
c.addi x8, -3   # x8 = -2
c.and x9, x8 # x9 = 0 
c.and x10, x8 # x10 = -2
sw x9, 56(x0)
sw x10, 60(x0)

slli:
c.slli x1, 4 # x1 = 16
c.slli x2, 4 # x2 = 0xfffffff0
sw x1, 64(x0)
sw x2, 68(x0)

mv:
c.addi x18, 31
c.mv x19, x18 # x19 = 31
sw x19, 72(x0)

add:
c.addi x20, 10
c.addi x21, 30
c.addi x22, -31
c.addi x14, -5
c.addi x10, 7
c.addi x4, 15
c.add x20, x14 # x20 = 5
c.add x21, x10 # x21 = 35
c.add x22, x4 # x22 = -1
sw x20, 76(x0)
sw x21, 80(x0)
sw x22, 84(x0)

_beqz:
c.beqz x8, _beqz # not taken
# c.addi x8, 2
c.andi x8, 0
c.beqz x8, _bnez # taken
c.addi x8, 12

_bnez:
c.addi x8, 10 # x8 = 10
sw x8, 88(x0)
c.andi x8, 0
c.bnez x8, _bnez # not taken
c.addi x8, 1
c.bnez x8, _jump # taken
sw x8, 92(x0) # x8 = 1
_jump:
c.addi x8, 12 # x8 = 13
sw x8, 96(x0)
c.addi x8, 12 # x8 = 25
c.j _jr
c.addi x8, -25

_jr: # jump to address in x1
sw x8, 100(x0) # x8 = 25
addi x1, x0, 218 # x1 = 218
c.jr x1
addi x1, x0, 0

lwsp:
sw x1, 104(x0) # x1 = 218
addi x2, x0, 0
c.lwsp x8, 20 # x8 = 35

c.jal jalr
jalr:
addi x1, x1, 8 # x1 = 242
c.jalr x1
c.addi x1, 10

swsp:
c.swsp x8, 27

___jump:
c.j ___jump
