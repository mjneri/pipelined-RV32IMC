# ISR for lcd.s
.text
isr:
# store temp registers in stack
addi sp, sp, -60			# formula: sp - (# of registers to save)*4
sw t0, 0(x2)	#from c.swsp t0, 0
sw t1, 4(x2)	#from c.swsp t1, 1
sw t2, 8(x2)	#from c.swsp t2, 2
sw t3, 12(x2)	#from c.swsp t3, 3
sw t4, 16(x2)	#from c.swsp t4, 4
sw t5, 20(x2)	#from c.swsp t5, 5
sw t6, 24(x2)	#from c.swsp t6, 6
sw a0, 28(x2)	#from c.swsp a0, 7
sw a1, 32(x2)	#from c.swsp a1, 8
sw a2, 36(x2)	#from c.swsp a2, 9
sw a3, 40(x2)	#from c.swsp a3, 10
sw a4, 44(x2)	#from c.swsp a4, 11
sw a5, 48(x2)	#from c.swsp a5, 12
sw a6, 52(x2)	#from c.swsp a6, 13
sw a7, 56(x2)	#from c.swsp a7, 14

# Check if I2C interrupted
lw s1, 0x18(gp)				# load I2C output control
andi s1, s1, 1	#from c.andi s1, 1				# get BUSY field only so i2c_send() knows if I2C is still busy

eret:
# reload temp registers
lw t0, 0(x2)	#from c.lwsp t0, 0
lw t1, 4(x2)	#from c.lwsp t1, 1
lw t2, 8(x2)	#from c.lwsp t2, 2
lw t3, 12(x2)	#from c.lwsp t3, 3
lw t4, 16(x2)	#from c.lwsp t4, 4
lw t5, 20(x2)	#from c.lwsp t5, 5
lw t6, 24(x2)	#from c.lwsp t6, 6
lw a0, 28(x2)	#from c.lwsp a0, 7
lw a1, 32(x2)	#from c.lwsp a1, 8
lw a2, 36(x2)	#from c.lwsp a2, 9
lw a3, 40(x2)	#from c.lwsp a3, 10
lw a4, 44(x2)	#from c.lwsp a4, 11
lw a5, 48(x2)	#from c.lwsp a5, 12
lw a6, 52(x2)	#from c.lwsp a6, 13
lw a7, 56(x2)	#from c.lwsp a7, 14
addi sp, sp, 60

uret
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
nop	#from c.nop
