`timescale 1ns / 1ps

module top(
	input CLK100MHZ,
	input nrst,

	output [11:0] OUT_if_PC,
	output [11:0] OUT_id_PC,
	output [11:0] OUT_exe_PC,
	output [11:0] OUT_mem_PC,
	output [11:0] OUT_wb_PC,
);
	
// Declare wires & regs	//////////////////////////////////////////////////////////////////////////
// IF Stage
	wire [11:0] if_pcnew;		// Input to PC; new PC address
	wire [11:0] if_PC;	// Output of PC, input to INSTMEM
	wire [11:0] if_pc4;			// PC + 4
	wire [31:0] if_inst;		// INSTMEM Output

// ID Stage
	// Outputs of IF/ID Pipeline Register
	wire [11:0] id_pc4;
	wire [31:0] id_inst;
	wire [11:0] id_PC;

	// 32-bit instruction parts
	wire [6:0] id_opcode;
	wire [2:0] id_funct;
	wire [4:0] id_rsA, id_rsB;
	wire [4:0] id_rd;
	assign id_opcode = id_inst[6:0];
	assign id_funct = id_inst[14:12];
	assign id_rsA = id_inst[19:15];
	assign id_rsB = id_inst[24:20];
	assign id_rd = id_inst[11:7];

	// Control signals

	// Inputs to ID/EXE Pipereg
	wire [31:0] id_rfoutA, id_rfoutB;
	wire [31:0] id_imm;

// EXE Stage
	// Outputs of ID/EXE Pipeline Register
	wire [11:0] exe_pc4;
	wire [31:0] exe_rfoutA, exe_rfoutB;
	wire [31:0] exe_imm;
	wire [4:0] exe_rd;
	wire [11:0] exe_PC;

	// Inputs to EXE/MEM Pipereg
	wire [31:0] exe_ALUout;
	wire [31:0] exe_storedata;

// MEM Stage

// WB Stage

// Instantiate modules	//////////////////////////////////////////////////////////////////////////

// IF Stage
	pc PC( .clk(CLK100MHZ),
		.nrst(nrst),
		.addr_in(if_pcnew),
		.inst_addr(if_PC)
	);

	instmem INSTMEM( .clk(CLK100MHZ),
		.addr(if_PC),
		.inst(if_inst)
	);

	// PC + 4
	assign if_pc4 = if_PC + 12'd4;

	// PC Selection; REPLACE WITH MUX LATER
	assign if_pcnew = if_pc4;

	pipereg_if_id IF_ID(
		.clk(CLK100MHZ),
		.nrst(nrst),

		.if_pc4(if_pc4), 	.id_pc4(id_pc4),
		.if_inst(if_inst), 	.id_inst(id_inst),
		.if_PC(if_PC), 		.id_PC(id_PC)
	);

// ID Stage
	//control unit

	regfile RF(
		.clk(CLK100MHZ),
		.nrst(nrst),

		//.wr_en(),
		//.wr_data(wb_wr_data),
		.src1_addr(id_rsA),		.src2_addr(id_rsB),
		.dest_addr(id_rd),
		.src1_out(id_rfoutA),	.src2_out(id_rfoutB)
	);


	pipereg_id_exe ID_EXE(
		.clk(CLK100MHZ),
		.nrst(nrst),

		.id_pc4(id_pc4),		.exe_pc4(exe_pc4),
		.id_rfoutA(id_rfoutA),	.exe_rfoutA(exe_rfoutA),
		.id_rfoutB(id_rfoutB),	.exe_rfoutB(exe_rfoutB),
		.id_imm(id_imm),		.exe_imm(exe_imm),
		.id_rd(id_rd),			.exe_rd(exe_rd),
		.id_PC(id_PC),			.exe_PC(exe_PC)
		// Control signals go here
	);

// EXE Stage
	alu ALU(

	);

	pipereg_exe_mem EXE_MEM();

// MEM Stage
	datamem DATAMEM(

	);

	pipereg_mem_wb MEM_WB();

// WB Stage

///////////////////////////////////////////////////////////////////////////////////////////////////
endmodule