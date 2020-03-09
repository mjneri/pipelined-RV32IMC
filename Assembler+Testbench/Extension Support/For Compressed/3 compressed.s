#Branches + jumps
c.addi x9, 1

#BEQZ
c.beqz x8, store1
c.addi x9, 10
loop1:
c.beqz x9, loop2
c.beqz x8, store2

#BNEZ
loop2:
c.bnez x9, store3
c.addi x9, 10
loop3:
c.bnez x8, loop4
c.beqz x8, store4

#JUMP
loop4:
c.j store5
c.addi x9, 10

#JAL
loop5:
c.jal store6
c.addi x9, 10

#JALR
loop6:
c.mv x2, x1
c.addi x2, 10
c.jalr x2
c.addi x9, 10
c.addi x9, 1
c.sw x9, 6(x15)

#JR
loop7:
c.addi x1, 12
c.jr x1
c.addi x9, 10

loop8:
c.j end

store1:
c.sw x9, 0(x15)
c.beqz x8, loop1
c.addi x9, 10

store2:
c.addi x9, 1
c.sw x9, 1(x15)
c.beqz x8, loop2
c.addi x9, 10

store3:
c.addi x9, 1
c.sw x9, 2(x15)
c.beqz x8, loop3
c.addi x9, 10

store4:
c.addi x9, 1
c.sw x9, 3(x15)
c.beqz x8, loop4
c.addi x9, 10

store5:
c.addi x9, 1
c.sw x9, 4(x15)
c.j loop5
c.addi x9, 10

store6:
c.addi x9, 1
c.sw x9, 5(x15)
c.j loop6
c.addi x9, 10

end:
c.addi x9, 10
c.sw x9, 8(x15)
