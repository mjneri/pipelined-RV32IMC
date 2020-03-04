c.addi x5, 184
c.addi x1, 1
c.addi x12, 8
c.lw x9, -8(x12)
c.lw x10, -4(x12)
c.sw x11, 0(x12)
c.addi x12, 4
c.beqz x15, Exit_C
c.jal Fibs_C
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.addi x5, 184
c.addi x1, 1
c.addi x12, 8
c.lw x9, -8(x12)
c.lw x10, -4(x12)
c.sw x11, 0(x12)
c.addi x12, 4
c.beqz x15, Exit_C
c.jal Fibs_C
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
c.nop
