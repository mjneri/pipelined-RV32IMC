c.addi x8, 1
c.addi x9, 2
c.addi x10, -1
c.addi x11, -2
c.sw x8, 0(s0)
c.sw x9, 1(s0)
c.sw x10, 2(s0)
c.sw x11, 3(s0)
c.lw x12, 0(s0)
c.lw x13, 1(s0)
c.lw x14, 2(s0)
c.lw x15, 3(s0)
c.sw x15, 4(s0)
c.sw x14, 5(s0)
c.sw x13, 6(s0)
c.sw x12, 7(s0)
c.nop
c.nop
c.jal plus
c.addi x13, 2
c.j end_jal
plus:
c.addi x13, 1
c.jr x1
end_jal:
c.sw x13, 8(s0)
c.li x12, 0
c.li x13, 1
c.li x14, -1
c.li x15, 31
c.sw x12, 9(s0)
c.sw x13, 10(s0)
c.sw x14, 11(s0)
c.sw x15, 12(s0)
c.lui x12, 2
c.lui x13, 1
c.lui x14, -1
c.lui x15, 31
c.sw x12, 13(s0)
c.sw x13, 14(s0)
c.sw x14, 15(s0)
c.sw x15, 16(s0)
c.addi4spn x8, 1
c.addi4spn x9, -1
c.sw x8, 17(s0)
c.sw x9, 18(s0)
c.addi16sp 1
sw x2, 76(x0)
c.addi16sp -1
sw x2, 80(x0)
c.li x8, 8
c.li x9, 16
c.li x10, 5
c.srli x8, 3
c.srli x9, 4
c.srli x10, 0
c.sw x8, 21(s0)
c.sw x9, 22(s0)
c.sw x10, 23(s0)
c.li x8, 16
c.li x9, 32
c.li x10, 5
c.srai x8, 4
c.srai x9, 5
c.srai x10, 0
c.sw x8, 24(s0)
c.sw x9, 25(s0)
c.sw x10, 26(s0)
c.li x8, 21
c.li x9, 14
c.li x10, 7
c.andi x8, 0x3f
c.andi x9, 0
c.andi x10, 1
c.sw x8, 27(s0)
c.sw x9, 28(s0)
c.sw x10, 29(s0)
c.nop
