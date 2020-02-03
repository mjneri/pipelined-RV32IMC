`timescale 1ns / 1ps

module tb_shiftsignshuff();

	reg [2:0] imm_select;
	reg [31:0] inst;
	wire [31:0] imm;

	shiftsignshuff uut(
		.imm_select(imm_select),
		.inst(inst[31:7]),
		.imm(imm)
	);

	// Parameters for immselct
	parameter ITYPE = 3'h0;
	parameter STYPE = 3'h1;
	parameter UTYPE = 3'h2;
	parameter BTYPE = 3'h3;
	parameter JTYPE = 3'h4;

	parameter add = 32'h00840333;	// add x6, x8, x10
	parameter addi = 32'h06300093;	// addi x1, x0, 99
	parameter sw = 32'h00102023;	// sw x1, x0(0)
	parameter lui = 32'hdeadb137;	// lui x1, deadb
	parameter beq = 32'h00208a63;	// beq
	parameter jal = 32'hfb1ff0ef;	// jal

	initial begin
		inst = 0;
		$display("Test instructions:");
		$display("add x6, x8, x10 || Imm: --------");
		$display("addi x1, x0, 99 || Imm: 0x00000063");
		$display("sw x1, x0(0) || Imm: 0x00000000");
		$display("lui, x1, 0xdeadb || Imm: 0xdeadb000");
		$display("beq || Imm: 0x00000014");
		$display("jal || Imm: 0xffffffb0");

		// Test ITYPE
		#20;
		$display("=== TESTING ITYPE SELECT ===");
		imm_select = ITYPE;
		#20;
		inst = add;
		$strobe("inst: add\tImm:0x%X", imm);
		#20;
		inst = addi;
		$strobe("inst: addi\tImm:0x%X", imm);
		#20;
		inst = sw;
		$strobe("inst: sw\tImm:0x%X", imm);
		#20;
		inst = lui;
		$strobe("inst: lui\tImm:0x%X", imm);
		#20;
		inst = beq;
		$strobe("inst: beq\tImm:0x%X", imm);
		#20;
		inst = jal;
		$strobe("inst: jal\tImm:0x%X", imm);
		#20;

		// Test STYPE
		imm_select = STYPE;
		$display("=== TESTING STYPE SELECT ===");
		#20;
		inst = add;
		$strobe("inst: add\tImm:0x%X", imm);
		#20;
		inst = addi;
		$strobe("inst: addi\tImm:0x%X", imm);
		#20;
		inst = sw;
		$strobe("inst: sw\tImm:0x%X", imm);
		#20;
		inst = lui;
		$strobe("inst: lui\tImm:0x%X", imm);
		#20;
		inst = beq;
		$strobe("inst: beq\tImm:0x%X", imm);
		#20;
		inst = jal;
		$strobe("inst: jal\tImm:0x%X", imm);
		#20;

		// Test UTYPE
		imm_select = UTYPE;
		$display("=== TESTING UTYPE SELECT ===");
		#20;
		inst = add;
		$strobe("inst: add\tImm:0x%X", imm);
		#20;
		inst = addi;
		$strobe("inst: addi\tImm:0x%X", imm);
		#20;
		inst = sw;
		$strobe("inst: sw\tImm:0x%X", imm);
		#20;
		inst = lui;
		$strobe("inst: lui\tImm:0x%X", imm);
		#20;
		inst = beq;
		$strobe("inst: beq\tImm:0x%X", imm);
		#20;
		inst = jal;
		$strobe("inst: jal\tImm:0x%X", imm);
		#20;

		// Test BTYPE
		imm_select = BTYPE;
		$display("=== TESTING BTYPE SELECT ===");
		#20;
		inst = add;
		$strobe("inst: add\tImm:0x%X", imm);
		#20;
		inst = addi;
		$strobe("inst: addi\tImm:0x%X", imm);
		#20;
		inst = sw;
		$strobe("inst: sw\tImm:0x%X", imm);
		#20;
		inst = lui;
		$strobe("inst: lui\tImm:0x%X", imm);
		#20;
		inst = beq;
		$strobe("inst: beq\tImm:0x%X", imm);
		#20;
		inst = jal;
		$strobe("inst: jal\tImm:0x%X", imm);
		#20;

		// Test JTYPE
		imm_select = JTYPE;
		$display("=== TESTING JTYPE SELECT ===");
		#20;
		inst = add;
		$strobe("inst: add\tImm:0x%X", imm);
		#20;
		inst = addi;
		$strobe("inst: addi\tImm:0x%X", imm);
		#20;
		inst = sw;
		$strobe("inst: sw\tImm:0x%X", imm);
		#20;
		inst = lui;
		$strobe("inst: lui\tImm:0x%X", imm);
		#20;
		inst = beq;
		$strobe("inst: beq\tImm:0x%X", imm);
		#20;
		inst = jal;
		$strobe("inst: jal\tImm:0x%X", imm);
		#20;
	end

endmodule