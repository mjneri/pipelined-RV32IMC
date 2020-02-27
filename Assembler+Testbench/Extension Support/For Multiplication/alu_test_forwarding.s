.data
	.word 0x00e5448c
	.word 0x03a821e4
	.word 0x0551a154
	.word 0x0c41ab3d 
	.word 0x0c5422eb
	.word 0x0da17277
	.word 0x1238be66
	.word 0x12af2ebe 
	.word 0x12d1f4a1
	.word 0x12f1768a
	.word 0x1309cb3d
	.word 0x15bad385 
	.word 0x160f19e9 
	.word 0x1828a0b7
	.word 0x1d0e98b9
	.word 0x1e9eddf4 
	.word 0x202f02ef
	.word 0x21ea1544
	.word 0x238518ec 
	.word 0x29995b68
	.word 0x2cbeac42
	.word 0x3000c4b6
	.word 0x31b23d85
	.word 0x3349a512
	.word 0x37bfaac6 
	.word 0x467f1162
	.word 0x482a14e0
	.word 0x48d6eaf6
	.word 0x4d971b08
	.word 0x4dfa75a5
	.word 0x4e577e18
	.word 0x4f1fee83 
	.word 0x4fad95a0
	.word 0x5260d006
	.word 0x59639144
	.word 0x5b25e98f
	.word 0x5b845ede 
	.word 0x5c8020ae
	.word 0x5fe68ebd 
	.word 0x603be2c4 
	.word 0x69cad450
	.word 0x6f6e3ff1
	.word 0x715fe9b9
	.word 0x74409991
	.word 0x7652f1ab
	.word 0x7653916a
	.word 0x79a12fa3
	.word 0x7adcaddc
	.word 0x7ed8b59b
	.word 0x84552d83

	.word 0x84683c3a
	.word 0x8792cddf
	.word 0x88518773
	.word 0x95d43fff
	.word 0x95feba48
	.word 0x982df7cb
	.word 0x9864986f
	.word 0x98722ce3
	.word 0x9a5a09e3
	.word 0x9e2b168b
	.word 0xa060b798
	.word 0xa127490d 
	.word 0xa63ed8a5
	.word 0xa6bd2b12
	.word 0xa81b2ef3 
	.word 0xa8cfde6e 
	.word 0xaa8727ed
	.word 0xab12cdf2
	.word 0xae749648 
	.word 0xb1bcf0d1
	.word 0xb61e8544
	.word 0xb72ed5ba
	.word 0xba65db40 
	.word 0xbdcc30e7
	.word 0xc0615d3a 
	.word 0xc174c6a1
	.word 0xc327aada
	.word 0xc432e6aa 
	.word 0xc465829c
	.word 0xc4ec187a
	.word 0xc7101407
	.word 0xc80e5e2c
	.word 0xc8b6a253
	.word 0xcc3e7f03 
	.word 0xcce34c0f
	.word 0xcfd1a82c
	.word 0xd38717b4
	.word 0xd7fa4426
	.word 0xdb2aa5f7
	.word 0xdbda578d
	.word 0xde770e16
	.word 0xe0bd7479
	.word 0xe0d47180 
	.word 0xe2ae681c 
	.word 0xe3b2d408 
	.word 0xe3e57441
	.word 0xe842972d
	.word 0xed35aaa0
	.word 0xf5f1e3e6
	.word 0xf6092104

.text
main:
	addi x20, x0, 0
	addi x21, x0, 200
	addi x22, x0, 400
	addi x31, x0, 50

loop:
	lw x1, 0(x20)
	lw x2, 0(x21)

	add x3, x1, x2
	div x4, x3, x2
	and x5, x4, x3
	or x6, x5, x4
	xor x7, x6, x5
	slt x8, x7, x6
	remu x9, x8, x7
	sll x10, x9, x8
	srl x11, x10, x9
	sra x12, x11, x10
	mul x13, x12, x11
	rem x14, x13, x12
	mulhsu x15, x14, x13
	mulhu x16, x15, x14
	sub x17, x16, x15
	divu x18, x17, x16
	mulh x19, x18, x17
	sltu x23, x19, x18

	sw x3, 0(x22)
	sw x4, 4(x22)
	sw x5, 8(x22)
	sw x6, 12(x22)
	sw x7, 16(x22)
	sw x8, 20(x22)
	sw x9, 24(x22)
	sw x10, 28(x22)
	sw x11, 32(x22)
	sw x12, 36(x22)
	sw x13, 40(x22)
	sw x14, 44(x22)
	sw x15, 48(x22)
	sw x16, 52(x22)
	sw x17, 56(x22)
	sw x18, 60(x22)
	sw x19, 64(x22)
	sw x23, 68(x22)

	addi x20, x20, 4
	addi x21, x21, 4
	addi x22, x22, 72
	addi x31, x31, -1
	bne x31, x0, loop

	lui x25, 0xade1b
	addi x25, x25, 0x055
	addi x26, x0, 0x3ff
	slli x26, x26, 2
	sw x25, 0(x26)
	
end:	jal x0, end
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
	addi x0, x0, 0
