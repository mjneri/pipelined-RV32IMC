Base:
lui a1, 0xF0F0
auipc a2, 0x0F0F0F
jal a3, Base
jalr a4, a5, 32
beq t0, t1, Base
bne t0, t1, Base
blt t0, t1, Base
bge t0, t1, Base
bltu t0, t1, Base
bgeu t0, t1, Base
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
