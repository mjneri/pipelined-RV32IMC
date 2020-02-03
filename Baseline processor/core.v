`timescale 1ns / 1ps

module core(
	input CLK,
	input nrst,

	// inputs from protocol controllers
	input [3:0] con_write,
	input [9:0] con_addr,
	input [31:0] con_in,
	output [31:0] con_out		// Ouput of DATAMEM connected to Protocol controllers
);
	
/******************************* DECLARING WIRES ******************************/

// IF stage ========================================================
	reg [11:0] if_pcnew;		// Input to PC; new PC address
	wire [11:0] if_PC;			// Output of PC, input to INSTMEM
	wire [11:0] if_pc4;			// PC + 4
	wire [31:0] if_inst;		// INSTMEM Output
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// ID Stage ========================================================
	// Outputs of IF/ID Pipeline Register
	wire [11:0] id_pc4;			// PC + 4
	wire [31:0] id_inst;		// 32bit Instruction
	wire [11:0] id_PC;			// PC

	// Other Datapath signals
	wire [31:0] id_branchtarget;
	wire [31:0] id_brOP;				// For computing branch target address
	wire id_jump_in_bht;				// For jumps already in BHT
	
	// 32-bit instruction parts
	wire [6:0] id_opcode;				// opcode
	wire [2:0] id_funct3;				// funct3
	wire [6:0] id_funct7;				// funct7
	wire [4:0] id_rsA, id_rsB;			// source registers
	wire [4:0] id_rd;					// destination register
	assign id_opcode = id_inst[6:0];
	assign id_funct3 = id_inst[14:12];
	assign id_funct7 = id_inst[31:25];
	assign id_rsA = id_inst[19:15];
	assign id_rsB = id_inst[24:20];
	assign id_rd = id_inst[11:7];

	// Control signals //////////////////////////////////
	wire [3:0] id_ALU_op;			// For EXE stage 	/
	wire id_sel_opA, id_sel_opB;	// For EXE stage 	/ 
	wire id_is_stype;				// For EXE stage 	/
	wire id_is_jump;				// For ID stage 	/
	wire id_is_btype;				// For ID Stage 	/
	wire id_wr_en;					// For WB stage 	/
	wire [2:0] id_dm_select;		// For MEM stage 	/
	wire [2:0] id_imm_select;		// For ID stage 	/
	wire [1:0] id_sel_pc;			// For EXE stage 	/ 
	wire [1:0] id_sel_data;			// For WB stage 	/
	wire [1:0] id_store_select;		// For EXE stage 	/
	wire id_sel_opBR;				// For ID stage 	/
	/////////////////////////////////////////////////////

	// Inputs to ID/EXE Pipereg 														
	wire [31:0] id_rfoutA, id_rfoutB;	// Regfile outputs 								
	wire [31:0] id_imm;					// Output of SHIFT, SIGN EXT, AND SHUFFLE block 
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// EXE Stage ========================================================
	// Outputs of ID/EXE Pipeline Register
	wire [11:0] exe_pc4;			// PC + 4
	wire [31:0] exe_inst;			// 32 bit instruction
	wire [31:0] exe_rfoutA;			// Regfile output A
	wire [31:0] exe_rfoutB;			// Regfile output B
	wire [31:0] exe_imm;			// Immediate
	wire [4:0] exe_rd;				// destination register
	wire [11:0] exe_PC;				// PC

	// Other wires used inside EXE stage
	wire [31:0] opA;
	wire [31:0] opB;
	wire exe_z;
	wire exe_less;
	//wire [31:0] exe_branchtarget;
	wire [2:0] exe_funct3;
	wire [6:0] exe_opcode;
	wire [5:0] exe_btype;

	// Control signals
	wire [3:0] exe_ALU_op;			// For EXE stage
	wire exe_sel_opA, exe_sel_opB;	// For EXE stage 
	wire exe_is_stype;				// For EXE stage
	wire [3:0] exe_dm_write;		// For MEM stage
	wire exe_wr_en;					// For WB stage
	wire [2:0] exe_dm_select;		// For MEM stage
	wire [1:0] exe_sel_pc;			// For EXE stage
	wire [1:0] exe_sel_data;		// For WB stage
	wire [1:0] exe_store_select;	// For EXE stage

	// Inputs to EXE/MEM Pipereg
	wire [31:0] exe_ALUout;			// ALU output
	wire [31:0] exe_storedata;		// Output of STORE BLOCK
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// MEM Stage ========================================================
	// Outputs of EXE/MEM Pipeline Register
	wire [11:0] mem_pc4;			// PC + 4
	wire [31:0] mem_inst;			// 32bit instruction
	wire [31:0] mem_ALUout;			// ALU output
	wire [31:0] mem_storedata;		// Input data to DATAMEM
	wire [31:0] mem_imm;			// 32bit Immediate
	wire [4:0]  mem_rd;				// Destination register
	wire [11:0] mem_PC;				// PC

	// Control signals
	wire [3:0] mem_dm_write;		// For MEM stage
	wire mem_wr_en;					// For WB stage
	wire [2:0] mem_dm_select;		// For MEM stage
	wire [1:0] mem_sel_data;		// For WB stage

	// MEM Stage Datapath Signals
	wire[31:0] mem_DATAMEMout;		// Output of DATAMEM

	// Inputs to MEM/WB Pipereg
	wire [31:0] mem_loaddata;		// Output of LOAD BLOCK
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// WB Stage ========================================================
	// Outputs of MEM/WB Pipeline Register
	wire [11:0] wb_pc4;				// PC + 4
	wire [31:0] wb_inst;			// 32bit instruction
	wire [31:0] wb_ALUout;			// ALU output
	wire [31:0] wb_loaddata;		// Output of LOAD BLOCK
	wire [31:0] wb_imm;				// 32bit Immediate
	wire [4:0] wb_rd;				// Destination register
	wire [11:0] wb_PC;				// PC

	// Control signals
	wire wb_wr_en;					// For WB stage
	wire [1:0] wb_sel_data;			// For WB stage

	// Datapath signals
	wire [31:0] wb_wr_data;
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// Signals for BHT =================================================
	wire if_prediction;				// Input to sel_PC mux
	wire [1:0] exe_correction;		// input to sel_PC mux
	wire flush;
	wire [9:0] if_PBT;				// Predicted branch target
	wire [9:0] exe_PBT;				// Predicted branch target
	wire [9:0] exe_CNI;				// Correct Next Instruction
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

/***********************************************************************************************/



/******************************* DATAPATH (INSTANTIATING MODULES) ******************************/

// IF Stage ========================================================
	pc PC( .clk(CLK),
		.nrst(nrst),
		.addr_in(if_pcnew),
		.inst_addr(if_PC)
	);

	instmem INSTMEM( //.clk(~CLK),
		.addr(if_PC),
		.inst(if_inst)
	);

	// PC + 4
	assign if_pc4 = if_PC + 12'd4;

	// PC Selection
	// 3'b000 = PC+4
	// 3'b001 = Prediction
	// 3'b010 = undef
	// 3'b011 = undef
	// 3'b100 = exeCNI
	// 3'b101 = exeCNI
	// 3'b110 = exePBT
	// 3'b111 = exePBT
	always@(*) begin
		case({exe_correction, if_prediction})
			3'b001: if_pcnew = {if_PBT, 2'h0};
			3'b100: if_pcnew = {exe_CNI, 2'h0};
			3'b101: if_pcnew = {exe_CNI, 2'h0};
			3'b110: if_pcnew = {exe_PBT, 2'h0};
			3'b111: if_pcnew = {exe_PBT, 2'h0};
			default: begin
				case({id_jump_in_bht, id_sel_pc})
					3'b001: if_pcnew = id_branchtarget;
					default: if_pcnew = if_pc4;
				endcase
			end
		endcase
	end

	pipereg_if_id IF_ID(
		.clk(CLK),
		.nrst(nrst),

		.if_pc4(if_pc4), 	.id_pc4(id_pc4),
		.if_inst(if_inst), 	.id_inst(id_inst),
		.if_PC(if_PC), 		.id_PC(id_PC)
	);



// ID Stage ========================================================
	
	//control unit
	controller1 CONTROL(
		// Inputs
		.opcode(id_opcode),
		.funct3(id_funct3),
		.funct7(id_funct7),

		// Outputs
		.ALU_op(id_ALU_op),
		.sel_opA(id_sel_opA),
		.sel_opB(id_sel_opB),
		.is_stype(id_is_stype),

		.is_jump(id_is_jump),
		.is_btype(id_is_btype),

		.wr_en(id_wr_en),
		.dm_select(id_dm_select),
		.imm_select(id_imm_select),
		.sel_pc(id_sel_pc),
		.sel_data(id_sel_data),
		.store_select(id_store_select),
		.sel_opBR(id_sel_opBR)
	);

	regfile RF(
		.clk(CLK),
		.nrst(nrst),

		.wr_en(wb_wr_en),
		.wr_data(wb_wr_data),
		.src1_addr(id_rsA),		.src2_addr(id_rsB),
		.dest_addr(wb_rd),
		.src1_out(id_rfoutA),	.src2_out(id_rfoutB)
	);

	shiftsignshuff SHIFTSIGNSHUFF(
		.imm_select(id_imm_select),
		.inst(id_inst[31:7]),
		.imm(id_imm)
	);

	// Branch target address
	assign id_brOP = (id_sel_opBR)? id_rfoutA : id_PC;
	assign id_branchtarget = id_brOP + id_imm;

	pipereg_id_exe ID_EXE(
		.clk(CLK),
		.nrst(nrst),
		.flush(flush),

		.id_pc4(id_pc4),		.exe_pc4(exe_pc4),
		.id_inst(id_inst),		.exe_inst(exe_inst),
		.id_rfoutA(id_rfoutA),	.exe_rfoutA(exe_rfoutA),
		.id_rfoutB(id_rfoutB),	.exe_rfoutB(exe_rfoutB),
		.id_imm(id_imm),		.exe_imm(exe_imm),
		.id_rd(id_rd),			.exe_rd(exe_rd),
		.id_PC(id_PC),			.exe_PC(exe_PC),

		// Control signals go here
		.id_ALU_op(id_ALU_op),				.exe_ALU_op(exe_ALU_op),
		.id_sel_opA(id_sel_opA),			.exe_sel_opA(exe_sel_opA),
		.id_sel_opB(id_sel_opB),			.exe_sel_opB(exe_sel_opB),
		.id_is_stype(id_is_stype),			.exe_is_stype(exe_is_stype),
		.id_wr_en(id_wr_en),				.exe_wr_en(exe_wr_en),
		.id_dm_select(id_dm_select),		.exe_dm_select(exe_dm_select),
		//.id_sel_pc(id_sel_pc),				.exe_sel_pc(exe_sel_pc),
		.id_sel_data(id_sel_data),			.exe_sel_data(exe_sel_data),
		.id_store_select(id_store_select), 	.exe_store_select(exe_store_select)
	);



// EXE Stage ========================================================
	// Selecting operands
	assign opA = (exe_sel_opA) ? exe_rfoutA : exe_PC;
	assign opB = (exe_sel_opB) ? exe_imm : exe_rfoutB;
	//assign exe_branchtarget = exe_PC + exe_imm;

	alu ALU(
		.op_a(opA),
		.op_b(opB),
		.ALU_op(exe_ALU_op),
		.res(exe_ALUout),
		.z(exe_z),
		.less(exe_less)
	);
	
	// Check what kind of branch instruction
	assign exe_opcode = exe_inst[6:0];
	assign exe_funct3 = exe_inst[14:12];
	assign exe_btype[5] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h0)? 1'b1 : 1'b0) : 1'b0;
	assign exe_btype[4] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h1)? 1'b1 : 1'b0) : 1'b0;
	assign exe_btype[3] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h4)? 1'b1 : 1'b0) : 1'b0;
	assign exe_btype[2] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h5)? 1'b1 : 1'b0) : 1'b0;
	assign exe_btype[1] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h6)? 1'b1 : 1'b0) : 1'b0;
	assign exe_btype[0] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h7)? 1'b1 : 1'b0) : 1'b0;

	branchpredictor BHT(
		.CLK(CLK),
		.nrst(nrst),

		.if_PC(if_PC[11:2]),

		.id_PC(id_PC[11:2]),
		.id_branchtarget(id_branchtarget[11:2]),
		.id_is_jump(id_is_jump),
		.id_is_btype(id_is_btype),

		.exe_PC(exe_PC[11:2]),
		.exe_z(exe_z),
		.exe_less(exe_less),
		.exe_btype(exe_btype),
		
		// Outputs
		.if_prediction(if_prediction),
		.exe_correction(exe_correction),
		
		.flush(flush),
		.id_jump_in_bht(id_jump_in_bht),

		.if_PBT(if_PBT),
		.exe_PBT(exe_PBT),
		.exe_CNI(exe_CNI)
	);

	storeblock STOREBLOCK(
		.opB(exe_rfoutB),
		.byte_offset(exe_ALUout[1:0]),
		.store_select(exe_store_select),
		.is_stype(exe_is_stype),
		.data(exe_storedata),
		.dm_write(exe_dm_write)
	);
	
	pipereg_exe_mem EXE_MEM(
		.clk(CLK),
		.nrst(nrst),

		.exe_pc4(exe_pc4),					.mem_pc4(mem_pc4),
		.exe_inst(exe_inst),				.mem_inst(mem_inst),
		.exe_ALUout(exe_ALUout),			.mem_ALUout(mem_ALUout),
		.exe_storedata(exe_storedata),		.mem_storedata(mem_storedata),
		.exe_imm(exe_imm),					.mem_imm(mem_imm),
		.exe_rd(exe_rd),					.mem_rd(mem_rd),
		.exe_PC(exe_PC),					.mem_PC(mem_PC),

		// Control signals
		.exe_dm_write(exe_dm_write),		.mem_dm_write(mem_dm_write),
		.exe_wr_en(exe_wr_en),				.mem_wr_en(mem_wr_en),
		.exe_dm_select(exe_dm_select),		.mem_dm_select(mem_dm_select),
		.exe_sel_data(exe_sel_data),		.mem_sel_data(mem_sel_data)
	);



// MEM Stage ========================================================
	datamem DATAMEM(
		.clk(CLK),
		.dm_write(mem_dm_write),
		.data_addr(mem_ALUout[11:2]),
		.data_in(mem_storedata),

		.con_write(con_write),
		.con_addr(con_addr),
		.con_in(con_in),

		.data_out(mem_DATAMEMout),
		.con_out(con_out)
	);

	loadblock LOADBLOCK(
		.data(mem_DATAMEMout),
		.byte_offset(mem_ALUout[1:0]),
		.dm_select(mem_dm_select),
		.loaddata(mem_loaddata)
	);

	pipereg_mem_wb MEM_WB(
		.clk(CLK),
		.nrst(nrst),

		.mem_pc4(mem_pc4),					.wb_pc4(wb_pc4),
		.mem_inst(mem_inst),				.wb_inst(wb_inst),
		.mem_ALUout(mem_ALUout),			.wb_ALUout(wb_ALUout),
		.mem_loaddata(mem_loaddata),		.wb_loaddata(wb_loaddata),
		.mem_imm(mem_imm),					.wb_imm(wb_imm),
		.mem_rd(mem_rd),					.wb_rd(wb_rd),
		.mem_PC(mem_PC),					.wb_PC(wb_PC),

		// Control signals
		.mem_wr_en(mem_wr_en),				.wb_wr_en(wb_wr_en),
		.mem_sel_data(mem_sel_data),		.wb_sel_data(wb_sel_data)
	);



// WB Stage ========================================================
	// Selector MUX
	assign wb_wr_data = (wb_sel_data == 2'd0) ? wb_pc4 : (wb_sel_data == 2'd1) ? wb_ALUout : (wb_sel_data == 2'd2) ? wb_imm : wb_loaddata;
	
///////////////////////////////////////////////////////////////////////////////////////////////////	
// Assign outputs
	//assign con_out = mem_DATAMEMout;	// output already tied to DATAMEM
endmodule
