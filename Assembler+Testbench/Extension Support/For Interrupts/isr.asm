#interrupt code

lui x1, 0x400   #button
lui x2, 0x401   #switch
lui x3, 0x402   #LED

lw x10, 0(x1)
beq x10, x20, branch1


branch1:
sb x10, 0(x3)
sb x10, 1(x3)