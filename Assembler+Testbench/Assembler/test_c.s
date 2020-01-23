Compressed:
c.lw t1, 76(s1)
c.sw t1, 76(s1)
c.nop 22
c.addi t0, 0x1F
c.jal 0x100
c.li t1, 16
c.lui t1, 0x20
c.srli t2, 0x20
c.srai t2, 0x20
c.andi t2, 0x20
c.sub t0, t1
c.xor t0, t1
c.or t0, t1
c.and t0, t1
c.j 0x20
c.beqz t4, 0x20
c.bnez t4, 0x20
c.slli t2, 0x11
c.lwsp t2, 0x11
c.jr ra
c.mv  t0, t1
c.jalr ra
c.add t0, t1
c.swsp t5, 0x100