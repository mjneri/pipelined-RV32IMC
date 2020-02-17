`timescale 1ns / 1ps
module tb_decode();
    reg [31:0] test_mem [0:45];
    
    reg [31:0] comp_inst;
    reg [31:0] inst;
    wire [6:0] id_opcode;				// opcode
	wire [2:0] id_funct3;				// funct3
	wire [6:0] id_funct7;				// funct7
	wire [4:0] id_rsA, id_rsB;			// source registers
	wire [4:0] id_rd;				// destination register
    wire [3:0] id_ALU_op;		// For EXE stage 	/
	wire id_sel_opA, id_sel_opB;	// For EXE stage 	/ 
	wire id_is_stype;			// For EXE stage 	/
	wire id_wr_en;				// For WB stage 	/
	wire [2:0] id_dm_select;		// For MEM stage 	/
	wire [2:0] id_imm_select;	// For ID stage 	/
	wire [1:0] id_sel_data;			// For WB stage 	/
	wire [1:0] id_store_select;
    wire [31:0] id_imm;
    
    wire [6:0] dec_opcode;				// opcode
	wire [2:0] dec_funct3;				// funct3
	wire [6:0] dec_funct7;				// funct7
	//wire [4:0] dec_rsA, dec_rsB;			// source registers
	wire [4:0] dec_rd;				// destination register
    wire [3:0] dec_ALU_op;		// For EXE stage 	/
	wire dec_sel_opA, dec_sel_opB;	// For EXE stage 	/ 
	wire dec_is_stype;			// For EXE stage 	/
	wire dec_wr_en;				// For WB stage 	/
	wire [2:0] dec_dm_select;		// For MEM stage 	/
	wire [2:0] dec_imm_select;	// For ID stage 	/
	wire [1:0] dec_sel_data;			// For WB stage 	/
	wire [1:0] dec_store_select;
    
    wire [3:0] dec_alu_op;
    wire [4:0] dec_rs1;
    wire [4:0] dec_rs2;
    // wire [4:0] dec_rd;
    wire [31:0] dec_imm;
    wire [19:0] dec_jt;

    wire is_compressed;

    id_dec dec_test(
        inst,
        id_rsA, id_rsB,			// source registers
        id_rd,					// destination register
        id_ALU_op,			// For EXE stage 	/
        id_sel_opA, id_sel_opB,	// For EXE stage 	/ 
        id_is_stype,				// For EXE stage 	/
        id_wr_en,					// For WB stage 	/
        id_dm_select,		// For MEM stage 	/
        id_imm_select,		// For ID stage 	/
        id_sel_data,			// For WB stage 	/
        id_store_select,		// For EXE stage 	/
        id_imm
    );

    compressed_decoder dddd(
        // inputs
        comp_inst[15:0],

        // type indicator
        is_compressed,

        // control signals
        dec_dm_select,
        dec_imm_select,
        dec_sel_data,
        dec_store_select,
        dec_alu_op,
        dec_sel_opA,
        dec_sel_opB,
        dec_is_stype,
        dec_wr_en,

        // results
        dec_rs1,
        dec_rs2,
        dec_rd,
        dec_imm,
        dec_jt
    );

    //wire test_id_rsA

    
    integer i;
    initial begin
        $dumpfile("bbb.vcd");
        $dumpvars(0, tb_decode);
        $readmemh("instmem.txt", test_mem);
        inst = 32'd0;
        comp_inst = 32'd0;
        #50;
        for (i = 0; i < 23; i = i + 1) begin
            inst = test_mem[(i*2) + 1];
            comp_inst = test_mem[(i*2)];
            #20;
        end
        $finish;
    end

endmodule