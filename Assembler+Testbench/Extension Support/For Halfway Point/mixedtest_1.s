# MIXED TEST 1
# MIX OF BASE I AND C INSTRUCTIONS



.data 0x0
        .word 0xb       # 0
        .word 0x19
        .word 0x17
        .word 0x71
        .word 0x6b
        .word 0x1a4     # 20
        .word 0xc5
        .word 0xc350
        .word 0x1
        .word 0xa455    # 36
        .word 0x1a5



.text
        addi x31, x0, 0
        c.lw x1, 0(x31)
        c.sw x1, 200(x31)

        # AUIPC

        # LOADS
        # lw
        # lh
        # lb
        # lhu
        # lbu
        # lui
        # c.lw
        # c.lwsp
        # c.lui
        # c.li

        # STORES
        # sw
        # sh
        # sb
        # c.sw
        # c.swsp

        # ADDS
        # add
        # addi
        # c.add
        # c.addi
        # c.addi16sp

        # SUBS
        # sub
        # c.sub

        # MUL
        # mul
        # mulh
        # mulhsu
        # mulhu

        # DIV
        # div
        # divu
        # rem
        # remu


        # SHIFTS
        # sll
        # slli
        # srl
        # srli
        # sra
        # srai
        # c.srli
        # c.srai

        # SLTs
        # slt
        # slti
        # sltu
        # sltiu

        # LOGIC OPERATIONS
        # and
        # or
        # xor
        # andi
        # ori
        # xori

        # MV

        # BRANCHES
        # beq
        # bne
        # blt
        # bge
        # bltu
        # bgeu
        # c.beqz
        # c.bnez

        # JUMPS
        # jal
        # jalr
        # c.j
        # c.jr
        # c.jal
        # c.jalr 