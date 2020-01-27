#testbench for baseline processor - RUJ types
#instructions ordered properly
#no hazards as of now
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

sw x4, 8192(x0)
sw x5, 8196(x0)

#AUIPC
auipc x1, 0x1
auipc x2, 0x2
auipc x3, 0x3

sw x1, 8200(x0)
sw x2, 8204(x0)
sw x3, 8208(x0)

#ADD
#1 p + p
add x10, x8, x6 
#2 p + n
add x11, x4, x5
#3 n + p
add x12, x9, x8     
#4 n + n
add x13, x5, x7 
#5 n + 0
add x14, x9, x0

sw x10, 8212(x0)
sw x11, 8216(x0)
sw x12, 8220(x0)
sw x13, 8224(x0)
sw x14, 8228(x0)

#SUB
#1 p - p
sub x10, x6, x4     
#2 p - n
sub x11, x8, x5     
#3 n - p
sub x12, x7, x4
#4 p - p resulting in negative
sub x13, x6, x8
#5 0 - p
sub x14, x0, x4
#6
sub x15, x0, x5

sw x10, 8232(x0)
sw x11, 8236(x0)
sw x12, 8240(x0)
sw x13, 8244(x0)
sw x14, 8248(x0)
sw x15, 8252(x0)

#SLL
sll x10, x4, x0
sll x11, x5, x1
sll x12, x6, x7
addi x0, x0, 0 #NOP

sw x10, 8256(x0)
sw x11, 8260(x0)
sw x12, 8264(x0)

#SLT
slt x13, x4, x4
slt x14, x4, x6
slt x15, x5, x4
slt x16, x0, x0
slt x17, x9, x5

sw x13, 8268(x0)
sw x14, 8272(x0)
sw x15, 8276(x0)
sw x16, 8280(x0)
sw x17, 8284(x0)

#SLTU
sltu x10, x6, x8
sltu x11, x6, x4

lui x12, 0x70f0
lui x13, 0x7f0f
lui x14, 0x6090
lui x15, 0x6090
lui x16, 0x0

sw x10, 12372(x0)
sw x11, 12376(x0)


#XOR
xor x17, x12, x13
xor x18, x15, x16

addi x0, x0, 0 #NOP
addi x0, x0, 0 #NOP

sw x17, 8288(x0)
sw x18, 8292(x0)

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
srl x12, x1, x4
srl x13, x1, x0

sw x10, 8296(x0)
sw x11, 8300(x0)
sw x12, 8304(x0)
sw x13, 8308(x0)

#SRA
sra x14, x1, x2
sra x15, x1, x0

addi x0, x0, 0 #NOP
addi x0, x0, 0 #NOP

sw x10, 8312(x0)
sw x11, 8316(x0)

#OR
or x10, x5, x6

addi x0, x0, 0 #NOP
addi x0, x0, 0 #NOP
addi x0, x0, 0 #NOP

sw x10, 8320(x0)

#AND
and x11, x5, x6
and x12, x7, x8

addi x0, x0, 0 #NOP
addi x0, x0, 0 #NOP

sw x11, 8324(x0)


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

#JUMP INSTRUCTIONS
