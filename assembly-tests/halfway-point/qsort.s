# This test uses quicksort to sort an array of integers.
# The implementation is largely based on 
# https://github.com/bharathkarumudi/MIPS/blob/master/quicksort.asm
# When running this program, make sure to include qsort data.dmp
# in the processor data memory.
.text # Defines the start of the code section for the program 
main:
addi t0, x0, 0		# Moves the address of datamem into register t0.
addi sp, x0, 1023	# Sets stack pointer to point at data-addr 0x3ff(word address)
slli sp, sp, 2		# shift sp by 2 bits to generate byte address
addi a0, t0, 0		# Set argument 1 to the array.
addi a1, x0, 0		# Set argument 2 to (low = 0)
addi a2, x0, 512	# Set argument 3 to (high = 512, last index in array)
jal ra, quicksort	# Call quick sort
jal x0, terminate	# Terminate program run by going to infinite loop


swap:				#swap method

	addi sp, sp, -12	# Make stack room for three

	sw a0, 0(sp)		# Store a0
	sw a1, 4(sp)		# Store a1
	sw a2, 8(sp)		# store a2

	slli t1, a1, 2 	#t1 = 4a
	add t1, a0, t1	#t1 = arr + 4a
	lw s3, 0(t1)		#s3  t = array[a]

	slli t2, a2, 2		#t2 = 4b
	add t2, a0, t2	#t2 = arr + 4b
	lw s4, 0(t2)		#s4 = arr[b]

	sw s4, 0(t1)		#arr[a] = arr[b]
	sw s3, 0(t2)		#arr[b] = t 


	addi sp, sp, 12	#Restoring the stack size
	jalr x0, ra, 0			#jump back to the caller
	


partition: 			#partition method

	addi sp, sp, -16	#Make room for 5

	sw a0, 0(sp)		#store a0
	sw a1, 4(sp)		#store a1
	sw a2, 8(sp)		#store a2
	sw ra, 12(sp)		#store return address
	
	addi s1, a1, 0		#s1 = low
	addi s2, a2, 0		#s2 = high

	slli t1, s2, 2		# t1 = 4*high
	add t1, a0, t1		# t1 = arr + 4*high
	lw t2, 0(t1)		# t2 = arr[high] //pivot

	addi t3, s1, -1 	#t3, i=low -1
	addi t4, s1, 0		#t4, j=low
	addi t5, s2, -1	#t5 = high - 1

	forloop: 
		slt t6, t5, t4	#t6=1 if j>high-1, s10=0 if j<=high-1
		bne t6, x0, endfor	#if t6=1 then branch to endfor

		slli t1, t4, 2		#t1 = j*4
		add t1, t1, a0	#t1 = arr + 4j
		lw s10, 0(t1)		#s10 = arr[j]

		slt s11, t2, s10	#s11 = 1 if pivot < arr[j], 0 if arr[j]<=pivot
		bne s11, x0, endfif	#if s11=1 then branch to endfif
		addi t3, t3, 1	#i=i+1

		addi a1, t3, 0		#a1 = i
		addi a2, t4, 0		#a2 = j
		jal ra, swap		#swap(arr, i, j)
		
		addi t4, t4, 1	#j++
		jal x0, forloop

	    endfif:
		addi t4, t4, 1	#j++
		jal x0, forloop		#junp back to forloop

	endfor:
		addi a1, t3, 1		#a1 = i+1
		addi a2, s2, 0			#a2 = high
		add tp, x0, a1		#tp = i+1 return (i + 1);
		jal ra, swap			#swap(arr, i + 1, high);

		lw ra, 12(sp)			#return address
		addi sp, sp, 16		#restore the stack
		jalr x0, ra, 0				#junp back to the caller

quicksort:				#quicksort method
	addi sp, sp, -16		# store 4 entries to the "stack"

	sw a0, 0(sp)			# a0
	sw a1, 4(sp)			# low
	sw a2, 8(sp)			# high
	sw ra, 12(sp)			# return address

	addi t0, a2, 0			#saving high in t0

	slt t1, a1, t0		# t1=1 if low < high, else 0
	beq t1, x0, endif		# if low >= high, endif

	jal ra, partition			# call partition 
	addi s0, tp, 0			# pivot, s0=tp

	lw a1, 4(sp)			#a1 = low
	addi a2, s0, -1		#a2 = pi -1
	jal ra, quicksort			#call quicksort

	addi a1, s0, 1		#a1 = pi + 1
	lw a2, 8(sp)			#a2 = high
	jal ra, quicksort			#call quicksort

 endif:

 	lw a0, 0(sp)			#restore a0
 	lw a1, 4(sp)			#restore a1
 	lw a2, 8(sp)			#restore a2
 	lw ra, 12(sp)			#restore return address
 	addi sp, sp, 16			#restore the stack
 	jalr x0, ra, 0
	
terminate:
	lui x25, 0xade1b
	addi x25, x25, 0x055
	addi x26, x0, 0x3ff
	slli x26, x26, 2
	sw x25, 0(x26)

inf: jal x0, inf