#LUI
lui x5, 0x11111
lui x6, 0xffffffff
lui x7, 0

#AUIPC
auipc x5, 0x1
auipc x6, 0x2
auipc x7, 0x3

#JAL
addi x8, x0, 1
jal x5, end

end:

#ADD
lui x9, 0x11111
add x6, x0, x0 #1

srai x7, x9, 20
add x10, x7, x5 #2

srai x6, x9, 12
srai x8, x7, 8 

add x12, x6, x8 #3
add x13, x11, x11 #4
add x14, x10, x10 #5

#SUB
lui x6, 0x10000
lui x9, 0x5
sub x5, x0, x0 #1

srai x7, x6, 28	

sub x8, x0, x7 #2

srai x10, x9, 12
sub x11, x10, x7 #3

#SLL
lui x5, 0x11111
lui x7, 0xc
lui x9, 0x14

sll x6, x5, x0 #1
srai x7, x7, 12

sll x8, x5, x7 #2
srai x9, x9, 12

sll x10, x5, x9 #3

#SLT
lui x6, 0x2
lui x5, 0x1
lui x11, 0xffffffff

srai x11, x11, 12
slt x7, x5, x5 #1
slt x8, x5, x6 #2
slt x9, x6, x5 #3
slt x10, x0, x0 #4
slt x12, x11, x5 #5

#SLTU
lui x5, 0x1
lui x6, 0xffffffff

srai x6, x6, 12

sltu x7, x6, x5 #1

#XOR

lui x12, 0x70f0
lui x13, 0x7f0f
lui x8, 0x70f0
lui x9, 0x70f0

xor x14, x12, x13 #1
xor x10, x8, x9 #2

#SRL
lui x5, 0x11111
lui x7, 0xc
lui x9, 0x14
lui x11, 0x1d
srl x6, x5, x0 #1
srai x7, x7, 12

srl x8, x5, x7 #2
srai x9, x9, 12

srl x10, x5, x9 #3
srai x11, x11, 12

srl x12, x5, x11 #4

#SRA
lui x5, 0xffffffff
lui x7, 0xc

srai x7, x7, 12

sra x6, x5, x0 #1
sra x8, x5, x7 #2

#OR
lui x5, 0x70f0
lui x6, 0x7f0f

or x7, x5, x6 #1

lui x8, 0x70f0
lui x9, 0x70f0

or x10, x8, x9 #2

#AND
lui x5, 0x70f0
lui x6, 0x7f0f
lui x8, 0x70f0
lui x9, 0x70f0

and x7, x5, x6
and x10, x8, x9


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