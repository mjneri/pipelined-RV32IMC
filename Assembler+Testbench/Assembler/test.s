Base:
lui a1, 0x1F
auipc a2, 0xF1
jal a3, 11
jalr a4, a5, 0
beq t0, t1, 32
bne t0, t1, 33
blt t0, t1, 34
bge t0, t1, 35
bltu t0, t1, 36
bgeu t0, t1, 37
lb t1, 0(s1)
lh t1, 0(s1)
lw t1, 0(s1)
lbu t1, 0(s1)
lhu t1, 0(s1)
sb t1, 0(s1)
sh t1, 0(s1)
sw t1, 0(s1)
addi t0, t1, 0x0F0
slti t0, t1, 0x0F0
sltiu t0, t1, 0x0F0
xori t0, t1, 0x0F0
ori t0, t1, 0x0F0
andi t0, t1, 0x0F0
slli t0, t1, 0x0F0
srli t0, t1, 0x0F0
srai t0, t1, 0x0F0
add t0, t1, t2
sub t0, t1, t2
sll t0, t1, t2
slt t0, t1, t2
sltu t0, t1, t2
xor t0, t1, t2
srl t0, t1, t2
sra t0, t1, t2
or t0, t1, t2
and t0, t1, t2
Multiplication:
mul t3, t4, t5
mulh t3, t4, t5
mulhsu t3, t4, t5
mulhu t3, t4, t5
Compressed:
c.lw t1, 0(s1)
c.sw t1, 0(s1)
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
c.jalr 0x100
c.add t0, t1
c.swsp t5, 0x100