# Test program for RISC-V
.data 0x000001c0
	# Constants -> test the following cases for each input: both positive, both negative, one positive one negative
	# for add, sub, slt, addi, and slti
	# these should be able to test whether negative values are used correctly
	# Notes: should also test the following:
	# Add/i: x + 0, 0 + x, -x + 0, 0 + (-x), 0 + 0, 7fff ffff + 1(overflow), 8000 0000 + (-1) (underflow) ( +7 cases)
	# Sub: x - 0, 0 - x, -x - 0, 0 - (-x), 0 - 0, 8000 0000 - 1 (underflow), 7fff ffff - (-1) (overflow) ( +7 cases)
	# Slt/i: x < 0, 0 < x, -x < 0, 0 < -x ( +4 cases)
	.word 113
	.word 105
	.word 197
	.word -113
	.word -105
	.word -197
	.word 0x7fffffff
	.word 0x80000000
	.word 1
	.word -1
	
.text
main:
	#lw & sw test (6 cases)
	lw x9, 0x1c0(x0)
	lw x10, 0x1c4(x0)
	lw x11, 0x1c8(x0)
	lw x12, 0x1cc(x0)
	lw x13, 0x1d0(x0)
	lw x14, 0x1d4(x0)
	
	sw x14, 0(x0)
	sw x13, 4(x0)
	sw x12, 8(x0)
	sw x11, 12(x0)
	sw x10, 16(x0)
	sw x9, 20(x0)
	
	#test addition (12 cases) (++, --, +-, -+)
	add x16, x9, x10
	sw x16, 24(x0)
	add x16, x9, x11
	sw x16, 28(x0)
	add x16, x9, x9
	sw x16, 32(x0)
	add x16, x12, x14
	sw x16, 36(x0)
	add x16, x12, x13
	sw x16, 40(x0)
	add x16, x12, x12
	sw x16, 44(x0)
	add x16, x9, x12
	sw x16, 48(x0)
	add x16, x9, x14
	sw x16, 52(x0)
	add x16, x9, x13
	sw x16, 56(x0)
	add x16, x12, x11
	sw x16, 60(x0)
	add x16, x12, x10
	sw x16, 64(x0)
	add x16, x12, x9
	sw x16, 68(x0)
	
	#test subtraction (12 cases) (++, --, +-, -+)
	sub x16, x9, x10
	sw x16, 72(x0)
	sub x16, x9, x11
	sw x16, 76(x0)
	sub x16, x9, x9
	sw x16, 80(x0)
	sub x16, x12, x14
	sw x16, 84(x0)
	sub x16, x12, x13
	sw x16, 88(x0)
	sub x16, x12, x12
	sw x16, 92(x0)
	sub x16, x9, x12
	sw x16, 96(x0)
	sub x16, x9, x14
	sw x16, 100(x0)
	sub x16, x9, x13
	sw x16, 104(x0)
	sub x16, x12, x11
	sw x16, 108(x0)
	sub x16, x12, x10
	sw x16, 112(x0)
	sub x16, x12, x9
	sw x16, 116(x0)
	
	#test slt (12 cases) (++, --, +-, -+)
	slt x16, x9, x10
	sw x16, 120(x0)
	slt x16, x9, x11
	sw x16, 124(x0)
	slt x16, x9, x9
	sw x16, 128(x0)
	slt x16, x12, x14
	sw x16, 132(x0)
	slt x16, x12, x13
	sw x16, 136(x0)
	slt x16, x12, x12
	sw x16, 140(x0)
	slt x16, x9, x12
	sw x16, 144(x0)
	slt x16, x9, x14
	sw x16, 148(x0)
	slt x16, x9, x13
	sw x16, 152(x0)
	slt x16, x12, x11
	sw x16, 156(x0)
	slt x16, x12, x10
	sw x16, 160(x0)
	slt x16, x12, x9
	sw x16, 164(x0)
	
	#test addi (12 cases) (++, --, +-, -+)
	addi x16, x9, 105
	sw x16, 168(x0)
	addi x16, x9, 197
	sw x16, 172(x0)
	addi x16, x9, 113
	sw x16, 176(x0)
	addi x16, x12, -197
	sw x16, 180(x0)
	addi x16, x12, -105
	sw x16, 184(x0)
	addi x16, x12, -113
	sw x16, 188(x0)
	addi x16, x9, -113
	sw x16, 192(x0)
	addi x16, x9, -197
	sw x16, 196(x0)
	addi x16, x9, -105
	sw x16, 200(x0)
	addi x16, x12, 197
	sw x16, 204(x0)
	addi x16, x12, 105
	sw x16, 208(x0)
	addi x16, x12, 113
	sw x16, 212(x0)
	
	#test slti (15 cases) (++, --, +-, -+)
	slti x16, x9, 105
	sw x16, 216(x0)
	slti x16, x9, 197
	sw x16, 220(x0)
	slti x16, x9, 113
	sw x16, 224(x0)
	slti x16, x12, -197
	sw x16, 228(x0)
	slti x16, x12, -105
	sw x16, 232(x0)
	slti x16, x12, -113
	sw x16, 236(x0)
	slti x16, x9, -113
	sw x16, 240(x0)
	slti x16, x9, -197
	sw x16, 244(x0)
	slti x16, x9, -105
	sw x16, 248(x0)
	slti x16, x12, 197
	sw x16, 252(x0)
	slti x16, x12, 105
	sw x16, 256(x0)
	slti x16, x12, 113
	sw x16, 260(x0)
	
	# test beq (12 cases)
	# if the values are equal, the 2nd sw call should be skipped.
	sw x9, 264(x0)
	beq x9, x10, beq1
	sw x10, 264(x0)
beq1:
	sw x10, 268(x0)
	beq x9, x11, beq2
	sw x11, 268(x0)	
beq2:
	sw x11, 272(x0)
	beq x9, x9, beq3
	sw x12, 272(x0)	
	
beq3:
	sw x12, 276(x0)
	beq x12, x14, beq4
	sw x13, 276(x0)		
beq4:
	sw x13, 280(x0)
	beq x12, x13, beq5
	sw x14, 280(x0)
beq5:
	sw x14, 284(x0)
	beq x12, x12, beq6
	sw x9, 284(x0)
	
beq6:
	sw x9, 288(x0)
	beq x9, x12, beq7
	sw x10, 288(x0)
beq7:
	sw x10, 292(x0)
	beq x9, x14, beq8
	sw x11, 292(x0)
beq8:
	sw x11, 296(x0)
	beq x9, x13, beq9
	sw x12, 296(x0)
	
beq9:
	sw x12, 300(x0)
	beq x12, x11, beq10
	sw x13, 300(x0)
beq10:
	sw x13, 304(x0)
	beq x12, x10, beq11
	sw x14, 304(x0)
beq11:
	sw x14, 308(x0)
	beq x12, x9, bne1
	sw x9, 308(x0)
	
	# test bne (12 cases)
	# same with the beq test. if the values are NOT equal, the 2nd sw should be skipped
bne1:
	sw x9, 312(x0)
	bne x9, x10, bne2
	sw x10, 312(x0)
bne2:
	sw x10, 316(x0)
	bne x9, x11, bne3
	sw x11, 316(x0)	
bne3:
	sw x11, 320(x0)
	bne x9, x9, bne4
	sw x12, 320(x0)	
	
bne4:
	sw x12, 324(x0)
	bne x12, x14, bne5
	sw x13, 324(x0)		
bne5:
	sw x13, 328(x0)
	bne x12, x13, bne6
	sw x14, 328(x0)
bne6:
	sw x14, 332(x0)
	bne x12, x12, bne7
	sw x9, 332(x0)
	
bne7:
	sw x9, 336(x0)
	bne x9, x12, bne8
	sw x10, 336(x0)
bne8:
	sw x10, 340(x0)
	bne x9, x14, bne9
	sw x11, 340(x0)
bne9:
	sw x11, 344(x0)
	bne x9, x13, bne10
	sw x12, 344(x0)
	
bne10:
	sw x12, 348(x0)
	bne x12, x11, bne11
	sw x13, 348(x0)
bne11:
	sw x13, 352(x0)
	bne x12, x10, bne12
	sw x14, 352(x0)
bne12:
	sw x14, 356(x0)
	bne x12, x9, addendum
	sw x9, 356(x0)

	# test additional add cases
addendum:	
	add x16, x9, x0	# x + 0
	sw x16, 360(x0)
	add x16, x0, x9	# 0 + x
	sw x16, 364(x0)
	add x16, x12, x0	# -x + 0
	sw x16, 368(x0)
	add x16, x0, x12	# 0 + -x
	sw x16, 372(x0)
	add x16, x0, x0	# 0 + 0
	sw x16, 376(x0)
	
	# test addi cases
	addi x16, x9, 0	# x + 0
	sw x16, 380(x0)
	addi x16, x0, 113 # 0 + x
	sw x16, 384(x0)
	addi x16, x12, 0	# -x + 0
	sw x16, 388(x0)
	addi x16, x0, -113	# 0 + -x
	sw x16, 392(x0)
	addi x16, x0, 0	# 0 + 0
	sw x16, 396(x0)
	
	# test sub cases
	sub x16, x9, x0	# x - 0
	sw x16, 400(x0)
	sub x16, x0, x9	# 0 -x
	sw x16, 404(x0)
	sub x16, x12, x0	# -x - 0
	sw x16, 408(x0)
	sub x16, x0, x12	# 0 - -x
	sw x16, 412(x0)
	sub x16, x0, x0	# 0 - 0
	sw x16, 416(x0)
	
	# test slt cases
	slt x16, x9, x0	# x < 0
	sw x16, 420(x0)
	slt x16, x0, x9	# 0 < x
	sw x16, 424(x0)
	slt x16, x12, x0	# -x < 0
	sw x16, 428(x0)
	slt x16, x0, x12	# 0 < -x
	sw x16, 432(x0)
	
	# test slti cases
	slti x16, x9, 0	# x < 0
	sw x16, 436(x0)
	slti x16, x0, 113	# 0 < x
	sw x16, 440(x0)
	slti x16, x12, 0	# -x < 0
	sw x16, 444(x0)
	slti x16, x0, -113	# 0 < -x
	sw x16, 448(x0)
	
	# test sll
	slli x16, x9, 1
	sw x16, 452(x0)
	slli x16, x10, 31
	sw x16, 456(x0)
	
	# test srl
	srli x16, x11, 1
	sw x16, 460(x0)
	srli x16, x12, 31
	sw x16, 464(x0)
	
	#test jump
	sw x11, 468(x0)
	jal x0, j_test
	sw x12, 468(x0)
	
	# test jal
j_test:
	jal x31, jal_test
	sw x14, 480(x0)
	jal x0, end
	
	# test jr
jal_test:
	sw x13, 472(x0)
	sw x31, 476(x0)
	lw x30, 476(x0)
	jalr x0, x30, 0 #jalr x0, 0(x30)
	sw x0, 476(x0)
	
end:
	jal x0, end
