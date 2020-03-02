#Compressed Instructions
#MV, LWSP, SWSP, SUB, XOR, OR, AND, ADD

#MV
addi x18, x18, 31
addi x16, x16, -31
mv x19, x18
mv x8, x16
sw x19, 0(x15)
sw x8, 4(x15)

#LWSP & SWSP
addi x2, x0, 0
lw x8, 4(x2)	#lwsp
sw x8, 8(x15)
sw x8, 12(x2)	#swsp
addi x2, x0, 4
lw x9, 0(x2)	#lwsp
sw x9, 16(x15)
sw x9, 16(x2)	#swsp

#SUB
addi x8, x8, 1
addi x9, x9, -1
addi x10, x10, -6
addi x11, x11, 15
addi x12, x12, 9
sub x8, x8, x9	#p-n
sub x9, x9, x9	#n-n
sub x10, x10, x8	#n-p
sub x11, x11, x10	#p-n
sub x12, x12, x11	#p-p
sw x8, 24(x15)
sw x9, 28(x15)
sw x10, 32(x15)
sw x11, 36(x15)
sw x12, 40(x15)

#XOR
addi x8, x0, -3
addi x9, x0, 2
addi x10, x0, 5
addi x11, x0, -4
addi x12, x0, 7
xor x9, x9, x10	#pp
xor x10, x10, x8	#pn
xor x8, x8, x12	#np	
xor x11, x11, x11	#nn
sw x9, 44(x15)
sw x10, 48(x15)
sw x8, 52(x15)
sw x11, 56(x15)

#OR
addi x8, x8, 2
addi x9, x9, 3
addi x10, x10, -4
addi x11, x11, -7
or x9, x9, x8	#pp
or x10, x10, x8	#np
or x8, x8, x11	#pn
or x11, x11, x11	#nn
sw x9, 60(x15)
sw x10, 64(x15)
sw x8, 68(x15)
sw x11, 72(x15)

#AND
li x8, 2
li x9, 3
li x10, -4
li x11, -5
and x9, x9, x8	#pp
and x10, x10, x8	#np
and x8, x8, x11	#pn
and x11, x11, x11	#nn
sw x9, 76(x15)
sw x10, 80(x15)
sw x8, 84(x15)
sw x11, 88(x15)

#ADD
addi x20, x20, 10
addi x21, x21, 30
addi x22, x22, -31
addi x14, x14, -5
lw x10, 44(x15)
addi x4, x4, 15
add x20, x20, x14	#pn
add x21, x21, x10	#pp
add x22, x22, x4	#np
add x14, x14, x22	#nn
sw x20, 92(x15)
sw x21, 96(x15)
sw x22, 100(x15)
sw x14, 104(x15)