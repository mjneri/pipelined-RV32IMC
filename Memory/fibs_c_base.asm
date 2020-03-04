addi x5, x0, 184
sw x0, 0(x0)
addi x1, x0, 1
sw x1, 4(x0)
addi x4, x0, 8
lw x1, -8(x4)
lw x2, -4(x4)
add x3, x2, x1
sw x3, 0(x4)
addi x4, x4, 4
beq x4, x5, Exit_B
jal x0, Fibs_B
sw x4, 0(x0)
nop
nop
nop
nop
nop
addi x12, x4, 16
c.addi converts to addi rd, rd, imm
c.addi converts to addi rd, rd, imm
sw x1, 4(x12)
c.addi converts to addi rd, rd, imm
c.lw converts to lw rd_, offset[6:2](rs1_)
c.lw converts to lw rd_, offset[6:2](rs1_)
add x11, x2, x1
c.sw converts to sw rs2_, offset[6:2](rs1_)
c.addi converts to addi rd, rd, imm
sub x15, x12, x5
c.beqz converts to beq rs1_, x0, label
c.jal converts to jal x1, label
sw x12, 0(x5)
c.nop converts to nop
c.nop converts to nop
c.nop converts to nop
c.nop converts to nop
c.nop converts to nop
c.nop converts to nop
c.nop converts to nop
c.nop converts to nop
c.nop converts to nop
c.nop converts to nop
