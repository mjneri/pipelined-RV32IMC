`timescale 1ns / 1ps

module tb_branchpredictor();
	reg CLK, nrst;

	// inputs to BHT
	reg [9:0] if_PC;

	reg [9:0] id_PC;
	reg [9:0] id_branchtarget;
	reg id_is_jump;
	reg id_is_btype;

	reg [9:0] exe_PC;
	reg exe_z;
	reg exe_less;
	reg [5:0] exe_btype;

	// Outputs of BHT
	wire if_prediction;
	wire [1:0] exe_correction;

	wire flush;

	wire [9:0] if_PBT;
	wire [9:0] exe_PBT;
	wire [9:0] exe_CNI;

	// UUT
	branchpredictor UUT(
		.CLK(CLK),
		.nrst(nrst),

		.if_PC(if_PC),
		.id_PC(id_PC),
		.id_branchtarget(id_branchtarget),
		.id_is_jump(id_is_jump),
		.id_is_btype(id_is_btype),
		.exe_PC(exe_PC),
		.exe_z(exe_z),
		.exe_less(exe_less),
		.exe_btype(exe_btype),
		.if_prediction(if_prediction),
		.exe_correction(exe_correction),
		.flush(flush),
		.if_PBT(if_PBT),
		.exe_PBT(exe_PBT),
		.exe_CNI(exe_CNI)
	);

	always
		#5 CLK = ~CLK;

	initial begin
		CLK = 0;
		nrst = 0;

		// inputs are 0'd
		if_PC = 0;

		id_PC = 0;
		id_branchtarget = 0;
		id_is_jump = 0;
		id_is_btype = 0;

		exe_PC = 0;
		exe_z = 0;
		exe_less = 0;
		exe_btype = 0;

		#100;
		nrst = 1;

		// Test reads in IF Stage
		$display("=== TESTING READS IN IF STAGE ===");
		#10 if_PC = 10'h001;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h002;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h003;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		// Test 4 writes to a single SET
		#10 $display("\n=== TESTING 4 WRITES TO A SINGLE SET");
		#10;
		id_PC = 10'h3ac;	// Tag = 11 1010, Set = 1100
		id_branchtarget = 10'h1ca;
		id_is_btype = 1'b1;
		$strobe("id_PC: 0x%X, idBT: 0x%X, btype: %B, isjump: %B, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			id_PC, id_branchtarget, id_is_btype, id_is_jump, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10;
		id_PC = 10'h2cc;	// Tag = 10 1100, Set = 1100
		id_branchtarget = 10'h3ac;
		id_is_btype = 1'b0;
		id_is_jump = 1'b1;
		$strobe("id_PC: 0x%X, idBT: 0x%X, btype: %B, isjump: %B, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			id_PC, id_branchtarget, id_is_btype, id_is_jump, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10;
		id_PC = 10'h0fc;	// Tag = 00 1111, Set = 1100
		id_branchtarget = 10'h2cc;
		id_is_btype = 1'b1;
		id_is_jump = 1'b0;
		$strobe("id_PC: 0x%X, idBT: 0x%X, btype: %B, isjump: %B, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			id_PC, id_branchtarget, id_is_btype, id_is_jump, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10;
		id_PC = 10'h11c;	// Tag = 01 0001, Set = 1100
		id_branchtarget = 10'h0fc;
		id_is_btype = 1'b0;
		id_is_jump = 1'b1;
		$strobe("id_PC: 0x%X, idBT: 0x%X, btype: %B, isjump: %B, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			id_PC, id_branchtarget, id_is_btype, id_is_jump, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10 id_is_jump = 1'b0;

		// Test reads
		#10 $display("=== TESTING READS IN IF STAGE ===");
		#10 if_PC = 10'h3ac;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h2cc;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h0fc;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h11c;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		// Update the counter in EXE stage
		#10 $display("\n=== UPDATE COUNTER IN EXE STAGE ===");
		#10;
		exe_PC = 10'h3ad;	// Not in BHT yet
		exe_z = 1'b1;
		exe_less = 1'b0;
		exe_btype = 6'h00;	// Not btype
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10;	// bltu
		exe_PC = 10'h3ac;
		exe_z = 1'b0;
		exe_less = 1'b1;
		exe_btype = 6'h02;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10;	// jump
		exe_PC = 10'h2cc;
		exe_z = 1'b1;
		exe_less = 1'b0;
		exe_btype = 6'h0;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10;	// bne
		exe_PC = 10'h0fc;
		exe_z = 1'b0;
		exe_less = 1'b0;
		exe_btype = 6'h10;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10;	// jump
		exe_PC = 10'h11c;
		exe_z = 1'b1;
		exe_less = 1'b0;
		exe_btype = 6'h0;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		// Test reads
		#10 $display("\n=== TESTING READS ===");
		#10 if_PC = 10'h3ac;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h2cc;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h0fc;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h11c;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		// Test overwriting
		#10 $display("\n=== TEST OVERWRITING ===");
		#10;
		id_PC = 10'h09c;	// Tag = 01 1001, Set = 1100
		id_branchtarget = 10'h011;
		id_is_btype = 1'b0;
		id_is_jump = 1'b1;
		$strobe("id_PC: 0x%X, idBT: 0x%X, btype: %B, isjump: %B, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			id_PC, id_branchtarget, id_is_btype, id_is_jump, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		// Write the same as above
		#10;
		id_PC = 10'h09c;	// Tag = 01 1001, Set = 1100
		id_branchtarget = 10'h011;
		id_is_btype = 1'b1;
		id_is_jump = 1'b0;
		$strobe("id_PC: 0x%X, idBT: 0x%X, btype: %B, isjump: %B, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			id_PC, id_branchtarget, id_is_btype, id_is_jump, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		// Overwrite
		#10;
		id_PC = 10'h05c;	// Tag = 01 1001, Set = 1100
		id_branchtarget = 10'h0a1;
		id_is_btype = 1'b1;
		id_is_jump = 1'b0;
		$strobe("id_PC: 0x%X, idBT: 0x%X, btype: %B, isjump: %B, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			id_PC, id_branchtarget, id_is_btype, id_is_jump, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10 id_is_btype = 1'b0;

		// Test reads
		#10 $display("\n=== TESTING READS ===");
		#10 if_PC = 10'h3ac;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h2cc;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h09c;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h05c;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h0fc;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 if_PC = 10'h11c;
		$strobe("if_PC: 0x%X, if_pred: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			if_PC, if_prediction, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#40;

		// Testing feedback
		#10 $display("\n=== TESTING FEEDBACK ===");
		exe_z = 0;
		exe_less = 0;

		#10 exe_btype = 6'h20;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h10;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h08;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h04;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h02;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h01;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10;
		exe_z = 0;
		exe_less = 1;

		#10 exe_btype = 6'h20;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h10;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h08;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h04;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h02;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h01;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10;
		exe_z = 1;
		exe_less = 0;

		#10 exe_btype = 6'h20;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h10;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h08;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h04;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h02;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h01;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);

		#10;
		exe_z = 1;
		exe_less = 1;

		#10 exe_btype = 6'h20;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h10;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h08;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h04;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h02;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		#10 exe_btype = 6'h01;
		$strobe("exe_PC: 0x%X, zf: %B, less: %B, btype: 0x%X, feedback: %B, exe_corr: %B, flush: %B, ifPBT: 0x%X, exePBT: 0x%X, exeCNI: 0x%X", 
			exe_PC, exe_z, exe_less, exe_btype, UUT.feedback, exe_correction, flush, if_PBT, exe_PBT, exe_CNI);
		
		#40 $finish;
	end

	// Stimulus
	/*always@(posedge CLK) begin
		if_PC <= if_PC + 10'b1;
		id_PC <= if_PC;
		exe_PC <= id_PC;
	end*/
	/*always@(posedge CLK) begin
		$strobe("if_PC: 0x%X, id_PC: 0x%X, id_BT: 0x%X, id_jump: %B, id_btype: %B, exe_PC: 0x%X, exe")
	end*/
endmodule