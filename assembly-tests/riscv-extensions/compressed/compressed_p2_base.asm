addi:
addi x1, x1, 1	#from c.addi x1, 1 # x1 = 1
addi x2, x2, -1	#from c.addi x2, -1 # x2 = -1
addi x3, x3, -1	#from c.addi x3, -1 # x3 = 0  (p + n)
addi x4, x4, 15	#from c.addi x4, 15 # x4 = 16 (p + p)
addi x5, x5, -3	#from c.addi, x5, -3 # x5 = -4 (n + n)
sw x1, 0(x0)
sw x2, 4(x0)
sw x3, 8(x0)
sw x4, 12(x0)
sw x5, 16(x0)

sub:
addi x8, x8, 1	#from c.addi x8, 1
addi x9, x9, -1	#from c.addi x9, -1
addi x10, x10, -3	#from c.addi x10, -3
addi x11, x11, 15	#from c.addi x11, 15
addi x12, x12, 9	#from c.addi x12, 9
sub x8, x8, x9	#from c.sub x8, x9 # x8 = 2 (p - n)
sub x9, x9, x9	#from c.sub x9, x9 # x7 = 0 (n - n)
sub x10, x10, x8	#from c.sub x10, x8 # x8 = -5 (n - p)
sub x11, x11, x10	#from c.sub x11, x10 # x9 = 20 (p - n)
sub x12, x12, x11	#from c.sub x12, x11 # x10 = -11 (p - p)
sw x8, 20(x0)
sw x9, 24(x0)
sw x10, 28(x0)
sw x11, 32(x0)
sw x12, 36(x0)

xor:
addi x8, x8, -3	#from c.addi x8, -3
addi x9, x9, 2	#from c.addi x9, 2
addi x10, x10, 5	#from c.addi x10, 5
xor x9, x9, x8	#from c.xor x9, x8 # x9 = -3
xor x10, x10, x8	#from c.xor x10, x8 # x10 = -1
sw x9, 40(x0)
sw x10, 44(x0)

or:
addi x8, x8, 2	#from c.addi x8, 2
addi x9, x9, 3	#from c.addi x9, 3
addi x10, x10, -1	#from c.addi x10, -1
or x9, x9, x8	#from c.or x9, x8 # x9 = 1
or x10, x10, x8	#from c.or x10, x8 # x10 = -1
sw x9, 48(x0)
sw x10, 52(x0)

and:
addi x8, x8, -3	#from c.addi x8, -3   # x8 = -2
and x9, x9, x8	#from c.and x9, x8 # x9 = 0
and x10, x10, x8	#from c.and x10, x8 # x10 = -2
sw x9, 56(x0)
sw x10, 60(x0)

slli:
slli x1, x1, 4	#from c.slli x1, 4 # x1 = 16
slli x2, x2, 4	#from c.slli x2, 4 # x2 = 0xfffffff0
sw x1, 64(x0)
sw x2, 68(x0)

mv:
addi x18, x18, 31	#from c.addi x18, 31
add x19, x0, x18	#from c.mv x19, x18 # x19 = 31
sw x19, 72(x0)

add:
addi x20, x20, 10	#from c.addi x20, 10
addi x21, x21, 30	#from c.addi x21, 30
addi x22, x22, -31	#from c.addi x22, -31
addi x14, x14, -5	#from c.addi x14, -5
addi x10, x10, 7	#from c.addi x10, 7
addi x4, x4, 15	#from c.addi x4, 15
add x20, x20, x14	#from c.add x20, x14 # x20 = 5
add x21, x21, x10	#from c.add x21, x10 # x21 = 35
add x22, x22, x4	#from c.add x22, x4 # x22 = -1
sw x20, 76(x0)
sw x21, 80(x0)
sw x22, 84(x0)

_beqz:
beq x8, x0, _beqz	#from c.beqz x8, _beqz # not taken
# c.addi x8, 2
andi x8, x8, 0	#from c.andi x8, 0
beq x8, x0, _bnez	#from c.beqz x8, _bnez # taken
addi x8, x8, 12	#from c.addi x8, 12

_bnez:
addi x8, x8, 10	#from c.addi x8, 10 # x8 = 10
sw x8, 88(x0)
andi x8, x8, 0	#from c.andi x8, 0
bne x8, x0, _bnez	#from c.bnez x8, _bnez # not taken
addi x8, x8, 1	#from c.addi x8, 1
bne x8, x0, _jump	#from c.bnez x8, _jump # taken
sw x8, 92(x0) # x8 = 1
_jump:
addi x8, x8, 12	#from c.addi x8, 12 # x8 = 13
sw x8, 96(x0)
addi x8, x8, 12	#from c.addi x8, 12 # x8 = 25
jal x0, _jr	#from c.j _jr
addi x8, x8, -25	#from c.addi x8, -25

_jr: # jump to address in x1
sw x8, 100(x0) # x8 = 25
addi x1, x0, 218 # x1 = 218
jalr x0, x1, 0	#from c.jr x1
addi x1, x0, 0

lwsp:
sw x1, 104(x0) # x1 = 218
addi x2, x0, 0
lw x8, 80(x2)	#from c.lwsp x8, 20 # x8 = 35

jal x1, jalr	#from c.jal jalr
jalr:
addi x1, x1, 8 # x1 = 242
jalr x1, x1	#from c.jalr x1
addi x1, x1, 10	#from c.addi x1, 10

swsp:
sw x8, 108(x2)	#from c.swsp x8, 27

___jump:
jal x0, ___jump	#from c.j ___jump
