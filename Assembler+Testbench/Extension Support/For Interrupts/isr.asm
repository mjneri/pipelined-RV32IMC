#.data 0x00004000
#	.word 0x1

#interrupt code
#.text
#main:
addi x1, x0, 0x400   #button
addi x2, x0, 0x401   #switch
addi x3, x0, 0x402   #LED

slli x1, x1, 2
slli x2, x2, 2
slli x3, x3, 2

lb x10, 0(x1)
lb x11, 0(x2)
lb x12, 0(x3)

addi x4, x0, 0x1
addi x5, x0, 0x2
addi x6, x0, 0x4
addi x7, x0, 0x8

beq x4, x10, btn1
beq x5, x10, btn2
beq x6, x10, btn3
beq x7, x10, btn4

jal x0, check_sw

btn1:
xor x20, x4, x12
sb x20, 0(x3)
jal x0, end

btn2:
xor x21, x5, x12
sb x21, 0(x3)
jal x0, end

btn3:
xor x22, x6, x12
sb x22, 0(x3)
jal x0, end

btn4:
xor x23, x7, x12
sb x23, 0(x3)
jal x0, end

check_sw:
beq x4, x11, sw1
beq x5, x11, sw2
beq x6, x11, sw3
jal x0, end
# beq x7, x11, sw4

sw1:
xor x24, x4, x12
sb x24, 0(x3)
jal x0, end

sw2:
xor x25, x5, x12
sb x25, 0(x3)
jal x0, end

sw3:
xor x26, x6, x12
sb x26, 0(x3)
jal x0, end

# sw4:
# xor x27, x7, x12
# sb x27, 0(x3)
# jal x0, end


end:
uret


