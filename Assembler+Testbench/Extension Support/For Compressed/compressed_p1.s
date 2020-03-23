#C.ADDI
c.andi x15, 0           # set up x15 for later use as 0
c.addi x8, 1
c.addi x9, 2
c.addi x10, -1
c.addi x11, -2
c.sw x8, 0(x15)			#x8 = 1	
c.sw x9, 1(x15)			#x9 = 2
c.sw x10, 2(x15)			#x10 = 0xffffffff
c.sw x11, 3(x15)		#x11 = 0xfffffffe

#C.LW
c.lw x12, 0(x15)
c.lw x13, 1(x15)
c.lw x14, 2(x15)
c.lw x11, 3(x15)
c.sw x11, 4(x15)		#x15 = 0xfffffffe --> 0x16
c.sw x14, 5(x15)		#x14 = 0xffffffff --> 0x20
c.sw x13, 6(x15)		#x13 = 2 --> 0x24
c.sw x12, 7(x15)		#x12 = 1 --> 0x28

#C.NOP
c.nop
c.nop

#C.JAL/C.J/C.JR
c.jal plus
c.addi x13, 2
c.j end_jal
plus:
c.addi x13, 1
c.jr x1
end_jal:
c.sw x13, 8(x15)			#x13 = 5

#C.LI
c.li x12, 0
c.li x13, 1
c.li x14, -1
c.li x11, 31
c.sw x12, 9(x15)			#x12 = 0	
c.sw x13, 10(x15)			#x13 = 1
c.sw x14, 11(x15)			#x14 = 0xffffffff
c.sw x11, 12(x15)			#x11 = 0x1f

#C.LUI
c.lui x12, 2
c.lui x13, 1
c.lui x14, -1
c.lui x11, 31
c.sw x12, 13(x15)			#x12 = 0x00002000
c.sw x13, 14(x15)			#x13 = 0x00001000
c.sw x14, 15(x15)			#x14 = 0xfffff000
c.sw x11, 16(x15)			#x15 = 0x0001f000

#C.ADDI4SPN
c.addi4spn x8, 2
c.addi4spn x9, -1
c.sw x8, 17(x15)			#x8 = (value of x2/sp) + 8
c.sw x9, 18(x15)			#x9 = (value of x2/sp) - 4

#C.ADDI16SP
c.addi16sp 1
sw x2, 76(x0)			#x2 = (value of x2) + 16
c.addi16sp -1
sw x2, 80(x0)			#x2 = (value of x2) - 16

#C.SRLI
c.li x8, 8
c.li x9, 16
c.li x10, 5
c.srli x8, 3
c.srli x9, 4
c.srli x10, 0
c.sw x8, 21(x15)			#x8 = 1
c.sw x9, 22(x15)			#x9 = 1
c.sw x10, 23(x15)		#x10 = 5

#C.SRAI
c.li x8, 16
# c.li x9, 32
auipc x9, 0x80000
c.li x10, 5
c.srai x8, 4
c.srai x9, 31
c.srai x10, 0
sw x8, 96(x0)			#x8 = 1
sw x9, 100(x0)		#x9 = 0xffffffff
sw x10, 104(x0)		#x10 = 5

#C.ANDI
c.li x8, 21
c.li x9, 14
c.li x10, 7
c.andi x8, 0x3f
c.andi x9, 0
c.andi x10, 1
sw x8, 108(x0)		#x8 = 21
sw x9, 112(x0)		#x9 = 0
sw x10, 116(x0)		#x9 = 1
c.nop
nop