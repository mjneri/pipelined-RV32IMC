#testbench for baseline processor - RUJ types
#NOP = addi x0, x0, 0



#LUI
#test numbers to be used
lui x1, 0x1
lui x2, 0x2
lui x3, 0x3
lui x4, 0x19 #25
lui x5, 0xFFCD #-50
lui x6, 0x29 #41
lui x7, 0xFFF4 #-12
lui x8, 0x0000AFC8 #45000
lui x9, 0xFD3A #-7100
lui x20, 0x2

sw x4, 0(x20)
sw x5, 4(x20)

#AUIPC
auipc x1, 0x0
auipc x2, 0x2
auipc x3, 0x3


#JAL
jal x1, end
sub x30, x3, x2

nop 
nop 
nop

end:
add x30, x2, x3

jal x3, end2:
addi x10, x3, x3

end2:

#JALR
addi x11, x0, 0x2
jalr x31, 0x6(x11)

addi x0, x0, 0
sw x31, 132(x20)

#ADD
#1 p + p
add x10, x8, x6 
#2 p + n
add x11, x4, x5

sw x10, 8(x20)
sw x11, 12(x20)

#3 n + p
add x12, x9, x8     
#4 n + n
add x13, x5, x7 

sw x12, 16(x20)
sw x13, 20(x20)

#5 n + 0
add x14, x9, x0

sw x14, 24(x20)

#SUB
#1 p - p
sub x10, x6, x4     
#2 p - n
sub x11, x8, x5     
#3 n - p
sub x12, x7, x4
#4 p - p resulting in negative
sub x13, x6, x8

sw x10, 28(x20)
sw x11, 32(x20)
sw x12, 36(x20)
sw x13, 40(x20)

#5 0 - p
sub x14, x0, x4
#6
sub x15, x0, x5

sw x14, 44(x20)
sw x15, 48(x20)

#SLL
sll x10, x4, x0
sll x11, x5, x1
sll x12, x6, x7
#addi x0, x0, 0 #NOP

sw x10, 52(x20)
sw x11, 56(x20)
sw x12, 60(x20)

#SLT
slt x13, x4, x4
sw x13, 64(x20)
slt x14, x4, x6
sw x14, 68(x20)
slt x15, x5, x4
slt x16, x0, x0
sw x15, 72(x20)
sw x16, 76(x20)
slt x17, x9, x5
sw x17, 80(x20)

#SLTU
sltu x10, x6, x8
sltu x11, x6, x4

sw x10, 84(x20)
sw x11, 88(x20)

lui x12, 0x70f0
lui x13, 0x7f0f
lui x14, 0x6090
lui x15, 0x6090
lui x16, 0x0

#XOR
xor x17, x12, x13
xor x18, x15, x16

addi x0, x0, 0 #NOP
addi x0, x0, 0 #NOP

sw x17, 92(x20)
sw x18, 96(x20)

lui x1, 0x11111
lui x2, 0x4
lui x3, 0x8
lui x4, 0xc
lui x5, 0x70f0
lui x6, 0x7f0f
lui x7, 0x6090
lui x8, 0x6090

#SRL
srl x10, x1, x2
srl x11, x1, x3

sw x10, 100(x20)
sw x11, 104(x20)

srl x12, x1, x4
srl x13, x1, x0

sw x12, 108(x20)
sw x13, 112(x20)

#SRA
sra x14, x1, x2
sra x15, x1, x0

#addi x0, x0, 0 #NOP
#addi x0, x0, 0 #NOP

sw x10, 116(x20)
sw x11, 120(x20)

#OR
or x10, x5, x6

#addi x0, x0, 0 #NOP
#addi x0, x0, 0 #NOP
#addi x0, x0, 0 #NOP

sw x10, 124(x20)

#AND
and x11, x5, x6
and x12, x7, x8

#addi x0, x0, 0 #NOP
#addi x0, x0, 0 #NOP

sw x11, 128(x20)


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

