.text
main:
	addi x1, x0, 50
	addi x2, x0, 140
	addi x3, x0, 52
	addi x4, x0, 53
	addi x5, x0, 54
	addi x6, x0, 55
	addi x7, x0, 56
	addi x8, x0, 57
	addi x10, x0, 58
	addi x11, x0, 59
	addi x12, x0, 50
	addi x13, x0, 51
	addi x14, x0, 52
	addi x15, x0, 53
	addi x16, x0, 54
	addi x17, x0, 55
	addi x18, x0, 56
	addi x19, x0, 59
	addi x20, x0, 57
	addi x21, x0, 58
	addi x22, x0, 57
	addi x23, x0, 59
	addi x24, x0, 52
	addi x25, x0, 54
	addi x26, x0, 52
	addi x27, x0, 54
	addi x28, x0, 51
	addi x29, x0, 52
	lui x30, 0x0003
	addi x31, x0, 56
	
	#lui x1, 0xdead
	#add x2, x1, x0
	#sw x2, 0(x0)
	
	#add x1, x2, x3
	#addi x0, x0, 0
	#lui x2, 0xaaa08
	#sw x2, 0(x0)
	
	#sw x2, 0(x0)
	#lw x10, 0(x0)
	#jalr x1, x10, 0
	#addi x11, x5, 100
	#sw x11, 4(x0)
	
	sw x2, 0(x0)
	lw x10, 0(x0)
	addi x1, x10, 1
	sw x1, 4(x0)
end:
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
