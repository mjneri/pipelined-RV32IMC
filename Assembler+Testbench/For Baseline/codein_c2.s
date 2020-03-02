c.addi x1, 1
c.addi x2, -1
c.addi x3, -1
c.addi x4, 15
c.addi x5, -3
sw x1, 0(x0)
sw x2, 4(x0)
sw x3, 8(x0)
sw x4, 12(x0)
sw x5, 16(x0)
c.addi x8, 1
c.addi x9, -1
c.addi x10, -3
c.addi x11, 15
c.addi x12, 9
c.sub x8, x9
c.sub x9, x9
c.sub x10, x8
c.sub x11, x10
c.sub x12, x11
sw x8, 20(x0)
sw x9, 24(x0)
sw x10, 28(x0)
sw x11, 32(x0)
sw x12, 36(x0)
c.addi x8, -3
c.addi x9, 2
c.addi x10, 5
c.xor x9, x8
c.xor x10, x8
sw x9, 40(x0)
sw x10, 44(x0)
c.addi x8, 2
c.addi x9, 3
c.addi x10, -1
c.or x9, x8
c.or x10, x8
sw x9, 48(x0)
sw x10, 52(x0)
c.addi x8, -3
c.and x9, x8
c.and x10, x8
sw x9, 56(x0)
sw x10, 60(x0)
c.slli x1, 4
c.slli x2, 4
sw x1, 64(x0)
sw x2, 68(x0)
c.addi x18, 31
c.mv x19, x18
sw x19, 72(x0)
c.addi x20, 10
c.addi x21, 30
c.addi x22, -31
c.addi x14, -5
c.addi x10, 7
c.addi x4, 15
c.add x20, x14
c.add x21, x10
c.add x22, x4
sw x20, 76(x0)
sw x21, 80(x0)
sw x22, 84(x0)
_beqz:
#c.beqz x8, _beqz
c.addi x8, 2
#c.beqz x0, _bnez
c.addi x8, 12
_bnez:
c.addi x8, 10
sw x8, 88(x0)
c.addi x8, -10
#c.bnez x8, _bnez
c.addi x8, 1
#c.bnez x22, _jump
c.addi x8, -1
_jump:
c.addi x8, 12
sw x8, 92(x0)
c.addi x8, 12
#c.j _jr
c.addi x8, -25
_jr:
sw x8, 96(x0)
addi x1, x0, 220
c.jr x1
addi x1, x0, 0
sw x1, 100(x0)
addi x2, x0, 0
c.lwsp x8, 20
addi x1, x0, 238
c.jalr x1
c.addi x1, 10
c.swsp x8, 26
___jump:
#c.j ___jump
