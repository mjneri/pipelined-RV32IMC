`timescale 1ns / 1ps

module tb_alu();
	//reg CLK;

	reg [31:0] opA, opB;
	reg [3:0] aluop;
	wire [31:0] res;
	wire z, less;
	
	alu uut(
		//.CLK(CLK),
		.op_a(opA),
		.op_b(opB),
		.ALU_op(aluop),
		.res(res),
		.z(z),
		.less(less)
	);

	// Define parameters for aluop
	parameter ADD 	= 	4'd1;
	parameter SUB 	= 	4'd2;
	parameter AND 	= 	4'd3;
	parameter OR 	= 	4'd4;
	parameter XOR 	= 	4'd5;
	parameter SLT 	= 	4'd6;
	parameter SLTU 	= 	4'd7;
	parameter SLL	= 	4'd8;
	parameter SRL 	= 	4'd9;
	parameter SRA 	= 	4'd10;

	// Added for Multiplication
	parameter MUL 	=	4'd11;
	parameter MULH	=	4'd12;
	parameter MULHSU=	4'd13;
	parameter MULHU =	4'd14;

	// Task for generating stimulus
	task test_op();
		input [31:0] A, B;
		begin
			opA = A;
			opB = B;
			aluop = ADD; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = SUB; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = AND; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = OR; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = XOR; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = SLT; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = SLTU; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = SLL; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = SRL; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = SRA; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = MUL; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = MULH; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = MULHSU; $strobe("OP: %D, A: %X, B: %X, RES: %X", aluop, opA, opB, res);
			#10 aluop = MULHU; $strobe("OP: %D, A: %X, B: %X, RES: %X\n", aluop, opA, opB, res);
		end
	endtask

	// always
	// 	#20 CLK = ~CLK;		// 50MHz

	initial begin
		// test_op(32'h0, 32'h0);
		// #10 test_op(32'hc0e19800, 32'heee19000);

		// // Random inputs
		// #10 test_op($random%32, $random%32);
		// #10 test_op($random%32, $random%32);
		// #10 test_op($urandom%32, $urandom%32);
		// #10 test_op($urandom%32, $urandom%32);
		// #10 test_op($urandom%32, $urandom%32);
		//CLK = 0;
		aluop = MUL;
		opA = 32'hc0e19800;
		opB = 32'heee19000;
		#100;
		aluop = MULH;
		#100;
		aluop = MULHU;
		#100;
		aluop = MULHSU;
		#100;
		$finish;
	end
endmodule