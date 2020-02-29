#Branches + jumps
addi x9, x9, 1

#BEQZ
beqz x8, store1	#taken
addi x9, x9, 10
loop1:
beqz x9, loop2	#not taken
beqz x8, store2

#BNEZ
loop2:
bnez x9, store3	#taken
addi x9, x9, 10
loop3:
bnez x8, loop4	#not taken
beqz x8, store4

#JUMP
loop4:
j store5
addi x9, x9, 10

#JAL
loop5:
jal x1, store6
addi x9, x9, 10

#JALR
loop6:
addi x2, x1, 16
jalr x1, x2, 0
addi x9, x9, 10
addi x9, x9, 1
sw x9, 24(x15)

#JR
loop7:
addi x1, x1, 24
jalr x0, x1, 0
addi x9, x9, 10

loop8:
j end

store1:
sw x9, 0(x15)
beqz x8, loop1
addi x9, x9, 10

store2:
addi x9, x9, 1
sw x9, 4(x15)
beqz x8, loop2
addi x9, x9, 10

store3:
addi x9, x9, 1
sw x9, 8(x15)
beqz x8, loop3
addi x9, x9, 10

store4:
addi x9, x9, 1
sw x9, 12(x15)
beqz x8, loop4
addi x9, x9, 10

store5:
addi x9, x9, 1
sw x9, 16(x15)
j loop5
addi x9, x9, 10

store6:
addi x9, x9, 1
sw x9, 20(x15)
j loop6
addi x9, x9, 10

end:
addi x9, x9, 10
sw x9, 32(x15)
