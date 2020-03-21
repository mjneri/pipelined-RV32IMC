# MIXED TEST 1
# MIX OF BASE I, M, AND C INSTRUCTIONS



.data 0x0
        .word 0x10       # 0
        .word 0x19
        .word 0x17
        .word 0x71
        .word 0x6b
        .word 0x1a4     # 20
        .word 0xc5
        .word 0xc350
        .word 0xe0cc08
        .word 0xa455    # 36
        .word 0x1a5
        .word 0xeffec750 # 44



.text
        addi x1, x0, 0
        addi x2, x0, 0
        addi x3, x0, 0
        addi x4, x0, 0
        addi x5, x0, 0
        addi x6, x0, 0
        addi x7, x0, 0
        addi x8, x0, 0
        addi x9, x0, 0
        addi x10, x0, 0
        addi x11, x0, 0
        addi x12, x0, 0
        addi x13, x0, 0
        addi x14, x0, 0
        addi x15, x0, 0
        addi x16, x0, 0
        addi x17, x0, 0
        addi x18, x0, 0
        addi x19, x0, 0
        addi x20, x0, 0
        addi x21, x0, 0
        addi x22, x0, 0
        addi x23, x0, 0
        addi x24, x0, 0
        addi x25, x0, 0
        addi x26, x0, 0
        addi x27, x0, 0
        addi x28, x0, 0
        addi x29, x0, 0
        addi x30, x0, 0
        
        addi x31, x0, 0

        # AUIPC
        auipc x1, 0xe
        sw x1, 204(x31)

        auipc x10, 0xee
        sw x10, 208(x31)

        auipc x4, 0xc0e
        sw x4, 212(x31)

        auipc x5, 0xb055
        sw x5, 216(x31)

        auipc x6, 0xf00ba
        sw x6, 220(x31)

        # LOADS ########################################################################################
        # lui
        lui x7, 0xd
        sw x7, 224(x31)

        lui x8, 0xb1
        sw x8, 228(x31)

        lui x9, 0xfffaf
        sw x9, 232(x31)

        addi x9, x0, 0
        # lw
        lw x10, 0(x31)
        lw x11, -4(x10)
        c.sw x11, 3(x9)
        
        
        lw x12, 16(x31)
        c.sw x12, 4(x9)

        # lh
        lh x13, 22(x31)
        sh x13, 244(x31)

        lh x14, 46(x31)
        sh x14, 248(x31)

        # lb
        lb x15, 29(x31)
        sb x15, 250(x31)

        lb x16, 30(x31)
        c.sw x15, 8(x9)

        # lhu
        lhu x17, 44(x31)
        sh x17, 252(x31)

        lhu x18, 42(x31)
        sh x18, 254(x31)

        # lbu
        lbu x19, 32(x31)
        sb x19, 256(x31)
       
        lbu x20, 33(x31)
        sb x20, 257(x31)
       
        lbu x21, 34(x31)
        sb x21, 34(x31)
       
        lbu x22, 35(x31)
        sb x22, 259(x31)

        addi x12, x0, 0
        # c.lw
        c.lw x8, 0(x12)
        sw x8, 260(x12)

        c.lw x8, 4(x12)
        c.sw x8, 4(x12)

        addi x14, x0, 36
        c.lw x8, 0(x14)
        c.sw x8, 28(x12)

        # c.lwsp
        c.lwsp x8, 4
        c.swsp x8, 48

        addi x2, x0, 8  # REMINDER: X2 IS STACK POINTER
        c.lwsp x8, 0
        slli x27, x2, 2  
        c.swsp x8, 52

        addi x13, x0, 0
        # c.lui
        c.lui x9, 0xe
        c.sw x9, 20(x13)

        c.lui x10, 0x1a
        c.sw x10, 24(x13)

        # c.li
        c.li x11, 0xa
        c.sw x11, 28(x13)
       
        slt x14, x11, x10
       
        c.li x12, 0x1d
        c.sw x12, 30(x13)

        # STORES (included in the tests above ^)
        # sw
        # sh
        # sb
        # c.sw
        # c.swsp

        # ADDS #########################################################################################
        # add and c.add
        addi x6, x0, 72
        # + +
        lw x3, 4(x31)
        add x4, x3, x11
        sw x4, 288(x31)
        # + -
        c.add x4, x6
        sw x4, 292(x31)
        # - +
        add x7, x4, x3
        sw x7, 296(x31)
        # - -
        c.add x7, x4 
        sw x8, 300(x31)
        # x 0
        c.add x8, x31
        sw x8, 304(x31)
        # 0 x
        add x3, x31, x3
        sw x3, 308(x31)
        # 0 0
        add x4, x0, x0
        sw x4, 312(x31)
        c.add x4, x31
        sw x4, 312(x31)

        # addi and c.addi
        # + +
        addi x10, x0, 115
        sw x10, 316(x31)
        # + -
        addi x10, x10, -631
        sw x10, 320(x31)
        # - +
        c.addi x10, 17
        c.addi x10, 21
        sw x10, 324(x31)
        # - -
        addi x11, x10, -97
        c.addi x11, -2
        sw x10, 328(x31)
        # 0
        c.addi x11, 1
        addi x12, x11, 500
        sw x11, 332(x31)

        # c.addi16sp
        # +
        c.addi16sp 4
        sw x2, 336(x31)
        # -
        c.addi16sp -4
        sw x2, 340(x31)
        # 0
        addi x21, x2, 5
        # c.addi16sp 0
        sw x2, 344(x31)


        addi x12, x0, 0

        # SUBS ###################################################################################################
        c.lw x15, 1(x12)
        # sub and c.sub
        # + +
        sub x5, x4, x15
        sw x5, 348(x31)
        # + -
        c.sub x9, x11 
        sw x9, 352(x31)
        # - +
        lw x26, 16(x31)
        sub x6, x5, x26
        sw x6, 356(x31)
        # - -
        c.sub x10, x9
        sw x10, 360(x31)
        # x 0
        sub x6, x6, x31
        sw x6, 364(x31)

        addi x10, x0, 432
        addi x11, x0, 2010
        addi x12, x0, -121
        addi x13, x0, -1958

        # MULS ##############################################################################################
        # mul
        # + +
        mul x15, x10, x11
        sw x15, 368(x31)
        # + -
        mul x16, x15, x12
        sw x16, 372(x31)
        # - +
        mul x16, x16, x11 
        sw x16, 376(x31)
        # - -
        mul x17, x16, x13
        sw x17, 380(x31)
        # x 0
        mul x17, x17, x0
        mul x16, x0, x16
        sw x16, 384(x31)
        sw x17, 388(x31)
        
        # mulh
        # + +
        mulh x15, x11, x10
        sw x15, 392(x31)
        # + -
        mulh x16, x15, x13
        sw x16, 396(x31)
        # - +
        mulh x16, x16, x10 
        sw x16, 400(x31)
        # - -
        mulh x17, x16, x12
        sw x17, 404(x31)
        # x 0
        mulh x13, x13, x0
        mul x16, x0, x13
        sw x13, 408(x31)
        sw x16, 412(x31)

        # mulhsu
        # + +
        mulhsu x15, x10, x11
        sw x15, 416(x31)
        # + -
        mulhsu x16, x15, x12
        sw x16, 420(x31)
        # - +
        mulhsu x16, x16, x11 
        sw x16, 424(x31)
        # - -
        mulhsu x17, x16, x13
        sw x17, 428(x31)
        # x 0
        mulhsu x17, x17, x0
        mulhsu x16, x0, x16
        sw x16, 432(x31)
        sw x17, 436(x31)

        # mulhu
        # + +
        mulh x15, x11, x10
        sw x15, 440(x31)
        # + -
        mulh x16, x15, x13
        sw x16, 444(x31)
        # - +
        mulh x16, x16, x10 
        sw x16, 448(x31)
        # - -
        mulh x17, x16, x12
        sw x17, 452(x31)
        # x 0
        mulh x13, x13, x0
        mul x16, x0, x13
        sw x13, 456(x31)
        sw x16, 460(x31)

        addi x17, x0, 981
        c.addi x18, 31
        addi x19, x0, -271
        addi x20, x0, -2048
       
        c.addi x22, -4

        # DIVS #################################################################################################
        # div
        # + +
        lw x21, 8(x31)
        div x10, x18, x21
        sw x10, 464(x31)
        # + -
        div x11, x10, x22 
        sw x11, 468(x31)
        # - +
        div x12, x11, x21
        sw x12, 472(x31)
        # - -
        div x13, x12, x11
        sw x13, 476(x31)
        # 0 div by
        div x14, x0, x21
        sw x14, 480(x31)
        # div by 0
        div x14, x18, x14
        sw x14, 484(x31)
        # 0 0
        div x22, x0, x0
        sw x22, 488(x31)

        # divu
         # + +
        divu x10, x18, x21
        sw x10, 492(x31)
        # + -
        divu x11, x10, x22 
        sw x11, 496(x31)
        # - +
        divu x12, x11, x21
        sw x12, 500(x31)
        # - -
        divu x13, x12, x11
        sw x13, 504(x31)
        # 0 div by
        divu x14, x0, x21
        sw x14, 508(x31)
        # div by 0
        divu x14, x18, x14
        sw x14, 512(x31)
        # 0 0
        divu x22, x0, x0
        sw x22, 516(x31)

        c.addi x7, 13
        addi x8, x0, 200
        addi x9, x0, 3
        c.addi x10, 30
        c.addi x11, 5
        c.addi x12, -6
        c.addi x13, 18

        # rem
        rem x14, x10, x11
        sw x14, 520(x31)

        rem x15, x10, x12
        sw x15, 524(x31)

        rem x16, x12, x15
        sw x16, 528(x31)

        rem x17, x16, x9
        sw x17, 532(x31)

        rem x18, x12, x0
        sw x18, 536(x31)

        # remu
        remu x14, x10, x11
        sw x14, 540(x31)

        remu x15, x10, x12
        sw x15, 544(x31)

        lw x7, 4(x31)
        remu x16, x8, x7
        remu x17, x16, x9
        sw x17, 548(x31)
        sw x16, 552(x31)

        addi x8, x0, 0

        # SHIFTS #####################################################################################################################
        # sll
        c.addi x11, 3
        c.lw x10, 4(x8)
        sll x12, x10, x11
        sw x12, 556(x31)
        
        lw x13, 4(x31)
        sll x12, x10, x13
        c.addi x14, 2
        sw x12, 560(x31)
        
        sll x12, x12, x14
        sw x12, 564(x31)

        # slli and c.slli
        slli x12, x12, 5
        sw x12, 568(x31)

        addi x9, x0, 0
        c.lw x10, 7(x9) 
        c.slli x10, 12
        sw x10, 576(x31)
        
        slli x14, x10, 23
        sw x14, 572(x31)

        # srl
        c.addi x11, 3
        c.lw x10, 7(x9)
        srl x12, x10, x11
        sw x12, 576(x31)
        
        lw x13, 4(x31)
        srl x12, x10, x13
        c.addi x14, 2
        sw x12, 580(x31)
        
        srl x12, x12, x14
        sw x12, 584(x31)

        # srli and c.srli
        srli x12, x12, 5
        sw x12, 588(x31)

        addi x9, x0, 0
        c.lw x10, 11(x9) 
        c.srli x10, 18
        sw x10, 592(x31)
        
        srli x14, x10, 23
        sw x14, 596(x31)

        # sra
        c.addi x11, 3
        lw x10, 28(x31)
        sra x12, x10, x11
        sw x12, 600(x31)
        
        lw x13, 4(x31)
        sra x12, x10, x13
        c.addi x14, 2
        sw x12, 604(x31)
        
        sra x12, x12, x14
        sw x12, 608(x31)

        # srai and c.srai
        srai x12, x12, 5
        sw x12, 612(x31)

        lw x10, 44(x31) 
        c.srai x10, 10
        sw x10, 616(x31)
        
        srai x14, x10, 23
        sw x14, 620(x31)


        addi x15, x0, 1583
        c.addi x16, 31
        addi x17, x16, -787
        addi x18, x17, -32

        # SLTs #######################################################################################################################################################
        # slt
        # + > +
        slt x20, x15, x16
        sw x20, 624(x31)
        # + > -
        slt x21, x15, x17
        sw x21, 628(x31)
        # - > -
        slt x22, x17, x18
        sw x22, 632(x31)
        # + < +
        slt x23, x16, x15
        sw x23, 636(x31)
        # - < +
        slt x24, x17, x16
        sw x24, 640(x31)
        # - < -
        slt x25, x18, x17
        sw x25, 644(x31)
        # =
        slt x26, x17, x17
        sw x26, 648(x31)

        # slti
        # + > +
        slti x10, x15, 1582
        sw x10, 652(x31)
        # + > -
        slti x11, x15, -778
        sw x11, 656(x31)
        # - > -
        slti x12, x17, -741
        sw x12, 660(x31)
        # + < +
        slti x13, x16, 2000
        sw x13, 664(x31)
        # - < +
        slti x14, x18, 15
        sw x14, 668(x31) 
        # - < -
        slti x10, x18, 17
        sw x10, 672(x31)
        # =
        slti x11, x10, 10
        sw x10, 676(x31)

        # sltu
        # + > +
        sltu x20, x15, x16
        sw x20, 680(x31)
        # + > -
        sltu x21, x15, x17
        sw x21, 684(x31)
        # - > -
        sltu x22, x17, x18
        sw x22, 688(x31)
        # + < +
        sltu x23, x16, x15
        sw x23, 692(x31)
        # - < +
        sltu x24, x17, x16
        sw x24, 696(x31)
        # - < -
        sltu x25, x18, x17
        sw x25, 700(x31)
        # =
        sltu x26, x15, x15
        sw x26, 704(x31)

        # sltiu
        # + > +
        sltiu x10, x15, 2047
        sw x10, 708(x31)
        # + > -
        sltiu x11, x15, -778
        sw x11, 712(x31)
        # - > -
        sltiu x12, x17, -741
        sw x12, 716(x31)
        # + < +
        sltiu x13, x16, 2047
        sw x13, 720(x31)
        # - < +
        sltiu x14, x18, 15
        sw x14, 724(x31) 
        # - < -
        sltiu x10, x18, 17
        sw x10, 728(x31)
        # =
        sltiu x11, x10, 10
        sw x10, 732(x31)

        lw x8, 32(x31)
        lw x15, 28(x31)
        lw x20, 44(x31)
        # LOGIC OPERATIONS ###################################################################################################################################3
        # and and c.and
        and x10, x15, x8
        sw x10, 736(x31)
        
        addi x11, x0, 307
        c.and x11, x10
        sw x11, 740(x31)

        # or and c.or
        or x12, x20, x11
        sw x12, 744(x31)

        c.or x12, x8
        sw x12, 748(x31)

        # xor and c.xor
        xor x13, x20, x11
        sw x13, 752(x31)

        c.xor x13, x15
        sw x13, 756(x31)

        # andi and c.andi
        andi x14, x20, 2041
        sw x14, 760(x31)

        c.andi x14, 31
        sw x14, 764(x31) 

        # ori
        ori x8, x8, 1023
        sw x8, 768(x31)

        # xori
        xori x20, x8, 2020
        sw x20, 772(x31)

        # MV
        c.mv x19, x20
        c.mv x16, x19
        sw x16, 776(x31)

        # BRANCHES ############################################################################################################3
        # beq
        # bne
        # blt
        # bge
        # bltu
        # bgeu
        # c.beqz
        # c.bnez
        addi x1, x0, 12
        addi x3, x0, 20
        addi x4, x0, 31
        addi x5, x0, 18
        addi x6, x0, 5
        addi x7, x0, 4
        addi x8, x0, 20
        addi x9, x0, 3
        addi x10, x0, 8
        lui x30, 0xe19
        addi x31, x0, 0x400
        slli x31, x31, 1
        add x30, x30, x31

        addi x29, x0, 0

        loop1:
        addi x1, x1, -1
        bne x1, x0, loop1
        jal x0, loop2
        sw x1, 780(x29)

        loop2:
        addi x11, x11, -1
        sll x11, x11, x0
        beq x11, x0, loop2
        jal x0, loop3
        sw x11, 784(x29)

        loop3:
        addi x3, x3, 1
        blt x3, x4, loop3
        jal x0, loop4
        sw x3, 788(x29)

        loop4:
        addi x6, x6, -1
        bge x6, x5, loop4
        jal x0, loop5
        sw x6, 792(x29) 

        loop5:
        addi x7, x7, 1
        bltu x7, x8, loop5
        jal x0, loop6
        sw x7, 796(x29)

        loop6:
        addi x9, x9, 1
        bgeu x8, x9, loop6
        jal x0, loop7a
        sw x9, 800(x29)

        loop7a:
        addi x20, x0, 17
        loop7:
        srli x20, x20, 1
        bne x20, x0, loop7
        jal x0, loop8a
        sw x5, 804(x29)

        loop8a:
        addi x12, x0, 25 
        loop8:
        c.addi x12, -1
        c.bnez x12, loop8
        c.jal loop9a
        sw x12, 808(x29)

        loop9a:
        addi x13, x0, 20
        loop9:
        addi x13, x13, -1
        c.beqz x13, loopend
        c.bnez x13, loop9
        sw x13, 812(x29)

        # ADE1BOSS
        loopend:

        sw x30, 788(x29)
        sw x30, 792(x29)
        sw x30, 796(x29)
        sw x30, 800(x29)
        sw x30, 804(x29)
        sw x30, 808(x29)
        sw x30, 812(x29)
        sw x30, 816(x29)
        sw x30, 820(x29)
        
        addi x1, x0, 0
        addi x2, x0, 0
        addi x3, x0, 0
        addi x4, x0, 0
        addi x5, x0, 0
        addi x6, x0, 0
        addi x7, x0, 0
        addi x8, x0, 0
        addi x9, x0, 0
        addi x10, x0, 0
        addi x11, x0, 0
        addi x12, x0, 0
        addi x13, x0, 0
        addi x14, x0, 0
        addi x15, x0, 0
        addi x16, x0, 0

        # JUMPS
        # jal
        jal x5, jump1
        slli x5, x5, 8
        sw x5, 820(x29)
        
        jump1:
        sw x30, 824(x29)
        
        # c.jal
        addi x11, x0, 19
        here1:
        c.addi x11, -1
        c.bnez x11, here1
        c.jal jump2
        sw x11, 824(x29)

        jump2:
        sw x30, 828(x29)

        # c.j
        c.addi x12, 17
        here2:
        addi x12, x12, -1
        c.bnez x12, here2
        c.j jump3
        sw x12, 828(x29)

        jump3:
        sw x30, 832(x29)
        
        

        # jalr
        jal x14, hey
        hey:
        jalr x15, x14, 12
        sw x15, 836(x29)

        sw x30, 840(x31)
        jal x16, final
        addi x16, x16, 12
        final:
        # c.jalr 
        c.jalr x16
        c.nop
        sw x1, 840(x29) 
        sw x0, 840(x29) 
        sw x30, 844(x29)

        addi x2, x0, 0

        # c.addi4spn
        c.addi4spn x8, 4
        sw x2, 848(x29)
        # -
        c.addi4spn x8, 4
        sw x2, 852(x29)
        # 0
        addi x21, x2, 5
        c.addi4spn x8, 1
        sw x2, 856(x29)
        
        # c.jr
        jal x13, pc4
        addi x13, x13, 8
        pc4:
        c.jr x13

        c.nop
        nop

        # infinite loop
        inf:
        jal x0, inf