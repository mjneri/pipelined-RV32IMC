`ifndef CONST_VH		// Guard prevents header file from being included more than once
`define CONST_VH

`define ceilLog2(x) ((x) > 2**30 ? 31 : \
                     (x) > 2**29 ? 30 : \
                     (x) > 2**28 ? 29 : \
                     (x) > 2**27 ? 28 : \
                     (x) > 2**26 ? 27 : \
                     (x) > 2**25 ? 26 : \
                     (x) > 2**24 ? 25 : \
                     (x) > 2**23 ? 24 : \
                     (x) > 2**22 ? 23 : \
                     (x) > 2**21 ? 22 : \
                     (x) > 2**20 ? 21 : \
                     (x) > 2**19 ? 20 : \
                     (x) > 2**18 ? 19 : \
                     (x) > 2**17 ? 18 : \
                     (x) > 2**16 ? 17 : \
                     (x) > 2**15 ? 16 : \
                     (x) > 2**14 ? 15 : \
                     (x) > 2**13 ? 14 : \
                     (x) > 2**12 ? 13 : \
                     (x) > 2**11 ? 12 : \
                     (x) > 2**10 ? 11 : \
                     (x) > 2**9 ? 10 : \
                     (x) > 2**8 ? 9 : \
                     (x) > 2**7 ? 8 : \
                     (x) > 2**6 ? 7 : \
                     (x) > 2**5 ? 6 : \
                     (x) > 2**4 ? 5 : \
                     (x) > 2**3 ? 4 : \
                     (x) > 2**2 ? 3 : \
                     (x) > 2**1 ? 2 : \
                     (x) > 2**0 ? 1 : 0)

`define INT_SIG_WIDTH 6

`define MEM_DEPTH 2048
`define MEM_WIDTH 16
`define WORD_WIDTH 32

`define PC_ADDR_BITS 12

// BHT CONSTANTS
`define BHT_PC_ADDR_BITS `PC_ADDR_BITS-1
`define BHT_ENTRY 64		// Only use values in powers of 2

`define BHT_SET_BITS `ceilLog2(`BHT_ENTRY/4)
`define BHT_TAG_BITS `BHT_PC_ADDR_BITS - `BHT_SET_BITS
`define BHT_ENTRY_BITS 4 + `BHT_TAG_BITS + `BHT_PC_ADDR_BITS    // 4 = 2bits saturating counter + 1bit ISR_running + 1bit valid

// CONTROLLER CONSTANTS
`define OPC_LUI 7'h37
`define OPC_AUIPC 7'h17
`define OPC_JAL 7'h6f
`define OPC_JALR 7'h67
`define OPC_BTYPE 7'h63
`define OPC_ITYPE 7'h13
`define OPC_STYPE 7'h23
`define OPC_RTYPE 7'h33
`define OPC_LOAD 7'h03

`define ALU_ADD 4'd1
`define ALU_SUB 4'd2
`define ALU_AND 4'd3
`define ALU_OR  4'd4
`define ALU_XOR 4'd5
`define ALU_SLT 4'd6
`define ALU_SLTU 4'd7
`define ALU_SLL 4'd8
`define ALU_SRL 4'd9
`define ALU_SRA 4'd10
`define ALU_MUL 4'd11
`define ALU_MULH 4'd12
`define ALU_MULHSU 4'd13
`define ALU_MULHU 4'd14

`endif	// CONST_VH