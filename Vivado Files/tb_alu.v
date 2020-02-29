`timescale 1ns / 1ps

module tb_alu();
	reg [31:0] opA, opB;
	reg [3:0] aluop;
	wire [31:0] res;
	wire z, less;
	
	alu uut(
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
			$strobe("A: %X, B: %X", opA, opB);
			aluop = ADD; 		$strobe("OP: ADD   , RES: %X", res);
			#10 aluop = SUB; 	$strobe("OP: SUB   , RES: %X", res);
			#10 aluop = AND; 	$strobe("OP: AND   , RES: %X", res);
			#10 aluop = OR; 	$strobe("OP: OR    , RES: %X", res);
			#10 aluop = XOR; 	$strobe("OP: XOR   , RES: %X", res);
			#10 aluop = SLT; 	$strobe("OP: SLT   , RES: %X", res);
			#10 aluop = SLTU; 	$strobe("OP: SLTU  , RES: %X", res);
			#10 aluop = SLL; 	$strobe("OP: SLL   , RES: %X", res);
			#10 aluop = SRL; 	$strobe("OP: SRL   , RES: %X", res);
			#10 aluop = SRA; 	$strobe("OP: SRA   , RES: %X", res);
			#10 aluop = MUL; 	$strobe("OP: MUL   , RES: %X", res);
			#10 aluop = MULH; 	$strobe("OP: MULH  , RES: %X", res);
			#10 aluop = MULHSU; $strobe("OP: MULHSU, RES: %X", res);
			#10 aluop = MULHU; 	$strobe("OP: MULHU , RES: %X\n", res);
		end
	endtask

	// always
	// 	#10 CLK = ~CLK;		// 50MHz

	initial begin
		test_op(32'h0, 32'h0);
		#10 test_op(32'hc0e19800, 32'heee19000);

		// Random inputs
		#10 test_op($random, $random);
		#10 test_op($random, $random);
		#10 test_op($urandom, $urandom);
		#10 test_op($urandom, $urandom);
		#10 test_op($urandom, $urandom);
		//CLK = 0;
		
		// aluop = MUL;
		// opA = 32'hc0e19800;
		// opB = 32'heee19000;
		// #100;
		// aluop = MULH;
		// #100;
		// aluop = MULHU;
		// #100;
		// aluop = MULHSU;
		// #100;
		#10 $finish;
	end
endmodule



// module opA_testcases();
// 	reg [31:0] testcases [0:49];
// 	initial begin
// 		$readmemh("opA_testcases.mem", testcases);
// 	end
// endmodule

// module opB_testcases();
// 	reg [31:0] testcases [0:49];
// 	initial begin
// 		$readmemh("opB_testcases.mem", testcases);
// 	end
// endmodule
