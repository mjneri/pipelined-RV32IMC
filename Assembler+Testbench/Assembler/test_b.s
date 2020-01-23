Base:
lui a1, 0xF0F0
auipc a2, 0x0F0F0F
jal a3, 32
jalr a4, a5, 31
beq t0, t1, 32
bne t0, t1, 32
blt t0, t1, 32
bge t0, t1, 32
bltu t0, t1, 32
bgeu t0, t1, 32
lb t1, 4(s1)
lh t1, 8(s1)
lw t1, 12(s1)
lbu t1, 16(s1)
lhu t1, 20(s1)
sb t1, 24(s1)
sh t1,28(s1)
sw t1, 32(s1)
addi t0, t1, 0x0F0
slti t0, t1, 0x0F0
sltiu t0, t1, 0x0F0
xori t0, t1, 0x0F0
ori t0, t1, 0x0F0
andi t0, t1, 0x0F0
slli t0, t1, 0x0F
srli t0, t1, 0x0F
srai t0, t1, 0x0F
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