`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
 
// Create Date: 01/23/2020 02:40:16 AM
// Design Name: 
// Module Name: tb_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_controller();
    //inputs
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    //reg z;
   // reg less;
    
    //outputs
    wire [3:0] ALU_op;
    wire sel_opA;
    wire sel_opB;
    wire is_stype;
    wire wr_en;
    wire [2:0] dm_select;
    wire [2:0] imm_select;
   // wire [1:0] sel_pc;
    wire [1:0] sel_data;
    wire [1:0] store_select;
  
   //Instantiate
   controller1 UUT (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        //.z(z),
        //.less(less),

        .ALU_op(ALU_op),
        .sel_opA(sel_opA),
        .sel_opB(sel_opB),
        .is_stype(is_stype),
        .wr_en(wr_en),
        .dm_select(dm_select),
        .imm_select(imm_select),
       // .sel_pc(sel_pc),
        .sel_data(sel_data),
        .store_select(store_select)
   );
    
	initial begin
		$display("Instruction\topcode\tfunct3\tfunct7\tALU_op\tsel_opA\tsel_opB\tstype\twr_en\tdm_select\timm_select\tsel_data\tstore_select");
		$display("--------------------------------------------------------------------------------------------------------------------------");
		funct7 = 0;
		funct3 = 0;
		opcode = 7'b0110111;    //lui
		$strobe("LUI        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b0010111;    //auipc
		$strobe("AUIPC      \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b1101111;    //jal
		$strobe("JAL        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b1100111;    //jalr
		$strobe("JALR       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b1100011;    //btype
		funct3 = 3'b000;		// BEQ
		$strobe("BEQ        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b001;		// BNE
		$strobe("BNE        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b100;		// BLT
		$strobe("BLT        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b011;		// --
		$strobe("-------    \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b101;		// BGE
		$strobe("BGE        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b110;		// BLTU
		$strobe("BLTU       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b111;		// BGEU
		$strobe("BGEU       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b010;		// --
		$strobe("---------  \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b0000011;    // Loads
		funct3 = 3'b000;		// LB
		$strobe("LB         \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b001;		// LH
		$strobe("LH         \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b111;		// --
		$strobe("---        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b010;		// LW
		$strobe("LW         \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b100;		// LBU
		$strobe("LBU        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b101;		// LHU
		$strobe("LHU        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b0100011;    // stype
		funct3 = 3'b000;		// SB
		$strobe("SB         \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b111;		// --
		$strobe("---        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b001;		// SH
		$strobe("SH         \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b010;		// SW
		$strobe("SW         \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b0010011;    // Itype
		funct3 = 3'b000;		// ADDI
		$strobe("ADDI       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		funct3 = 3'b010;		// SLTI
		$strobe("SLTI       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b011;		// SLTIU
		$strobe("SLTIU      \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b100;		// XORI
		$strobe("XORI       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b110;		// ORI
		$strobe("ORI        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b111;		// ANDI
		$strobe("ANDI       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b001;		// SLLI
		$strobe("SLLI       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b101;		// SRLI		
		$strobe("SRLI       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct7 = 7'b0100000;	// SRAI
		$strobe("SRAI       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b0110011;    //rtype
		funct3 = 3'b000;		// SUB
		$strobe("SUB        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		funct7 = 7'd0;			// ADD
		$strobe("ADD        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b010;		// SLT
		$strobe("SLT        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b011;		// SLTU
		$strobe("SLTU       \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b100;		// XOR
		$strobe("XOR        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b110;		// OR
		$strobe("OR         \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b111;		// AND
		$strobe("AND        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b001;		// SLL
		$strobe("SLL        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct3 = 3'b101;		// SRL
		$strobe("SRL        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		funct7 = 7'b0100000;	// SRA
		$strobe("SRA        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#100;
		opcode = 7'b0000000;	// --
		$strobe("---        \t%B\t%B\t%B\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%X\t%x", opcode, funct3, funct7, ALU_op, sel_opA, sel_opB, is_stype, wr_en, dm_select, imm_select, sel_data, store_select);
		#50;
		$finish;
	end
endmodule
