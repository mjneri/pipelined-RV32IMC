#Compressed Instructions
#ADDI, SW, LW, LI, LUI, ADDI4SPN, ADDI16SP, SRLI, SRAI, SLLI, ANDI 

#ADDI pt1
addi x8, x8, 1	#0p
addi x9, x9, -1	#0n

#SW
sw x8, 0(x15)
sw x9, 4(x15)

#ADDI pt2
addi x8, x8, 20	#pp
addi x9, x9, -20	#nn
sw x8, 8(x15)
sw x9, 12(x15)
addi x8, x8, -12	#pn
addi x9, x9, 12	#np
sw x8, 16(x15)
sw x9, 20(x15)

#LW
lw x11, 0(x15)
lw x12, 4(x15)
lw x13, 8(x15)
lw x14, 12(x15)
sw x11, 24(x15)
sw x12, 28(x15)
sw x13, 32(x15)
sw x14, 36(x15)

#LI
addi x11, x0, 31
addi x12, x0, 0
addi x13, x0, 1
addi x14, x0, -1
sw x11, 40(x15)
sw x12, 44(x15)
sw x13, 48(x15)
sw x14, 52(x15)

#LUI
lui x11, 2
lui x12, 1
lui x13, -5	#not supported
sw x11, 56(x15)
sw x12, 60(x15)
sw x13, 64(x15)	#expected wrong answer

#ADDI4SPN
addi x8, x2, 4
addi x9, x2, 100
sw x8, 68(x15)
sw x9, 72(x15)

#ADDI16SP
addi x2, x2, 16
sw x2, 76(x15)
addi x2, x2, -16
sw x2, 80(x15)

#SRLI
addi x8, x0, 8
addi x9, x0, -16
addi x10, x0, 0	
srli x8, x8, 3	#pos
srli x9, x9, 4	#neg
srli x10, x10, 5	#zero
sw x8, 84(x15)
sw x9, 88(x15)
sw x10, 92(x15)

#SRAI
li x8, 8
li x9, -16
srai x8, x8, 4	#pos
srai x9, x9, 5	#neg
srai x10, x10, 3	#zero
sw x8, 96(x15)
sw x9, 100(x15)
sw x10, 104(x15)

#SLLI
li x1, 16
li x2, -5
li x3, 0
slli x1, x1, 4	#shift pos
slli x2, x2, 4	#shift neg
slli x3, x3, 8	#shift zero
sw x1, 108(x15)
sw x2, 112(x15)
sw x3, 116(x15)

#ANDI
addi x8, x0, 21
addi x9, x0, 14
addi x10, x0, 7
andi x8, x8, 63	#pos
andi x9, x9, 0	#neg
andi x10, x10, -1	#zero
sw x8, 120(x15)
sw x9, 124(x15)
sw x10, 128(x15)
