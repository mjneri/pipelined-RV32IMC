`timescale 1ns / 1ps

/*
    Forwarding Unit module

    Creates control signals for data forwarding in the datapath.

    ALU output:
    - forward ALU output, EXE/MEM, or MEM/WB to ID

    Memory output:
    - forward datamem output to EXE (ALU inputs, non-multiplication)
    - stall one cycle + forward datamem output to jump adder (LW -> JALR)
    - forward MEM/WB register to ID (LW -> (inst) -> (inst) -> JALR)

*/

module forwarding_unit(
    // Inputs
	input [4:0] id_rsA,
	input [4:0] id_rsB,
    input [4:0] exe_rsA,
	input [4:0] exe_rsB,
    
    input [4:0] exe_rd,
    input [4:0] mem_rd,
    input [4:0] wb_rd,

    input exe_wr_en,
    input mem_wr_en,
    input wb_wr_en,

    input id_sel_opA,
    input id_sel_opB,

   // input [1:0] id_sel_data,
    input [1:0] exe_sel_data,
    input [1:0] mem_sel_data,
    input [1:0] wb_sel_data,

    input id_is_stype,
    input exe_is_stype,

    input [2:0] id_imm_select,

    input [6:0] exe_opcode,
    input exe_comp_use_A,
    input exe_comp_use_B,
    input exe_is_comp,

    // Outputs
    // Forwarding to ID stage
	output fw_exe_to_id_A,
    output fw_exe_to_id_B,
    output fw_mem_to_id_A,
    output fw_mem_to_id_B,
    output fw_wb_to_id_A,
    output fw_wb_to_id_B,
    
    // Forwarding to EXE stage
    output fw_mem_to_exe_A,
    output fw_mem_to_exe_B,
    output fw_wb_to_exe_A,
    output fw_wb_to_exe_B
);

    // ID stage forwarding (ALU output, memory load, immediate, or pc+4 -> ALU operand/s)

	assign fw_exe_to_id_A = (id_rsA == exe_rd) && (id_rsA != 0) &&
							exe_wr_en && (exe_sel_data != 2'd3) &&
							id_sel_opA && 
							!(id_imm_select == 3'd2 || id_imm_select == 3'd4);

    assign fw_exe_to_id_B = (id_rsB == exe_rd) && (id_rsB != 0) && 
							exe_wr_en && (exe_sel_data != 2'd3) &&
							(!id_sel_opB || id_is_stype);

    assign fw_mem_to_id_A = (id_rsA == mem_rd) && (id_rsA != 0) && 
							mem_wr_en && 
							id_sel_opA &&
							!(id_imm_select == 3'd2 || id_imm_select == 3'd4);

    assign fw_mem_to_id_B = (id_rsB == mem_rd) && (id_rsB != 0) && 
							mem_wr_en && 
							(!id_sel_opB || id_is_stype);
    
    assign fw_wb_to_id_A = (id_rsA == wb_rd) && (id_rsA != 0) && 
							wb_wr_en && 
							id_sel_opA &&
							!(id_imm_select == 3'd2 || id_imm_select == 3'd4);

    assign fw_wb_to_id_B = (id_rsB == wb_rd) && (id_rsB != 0) && 
							wb_wr_en && 
							(!id_sel_opB || id_is_stype);

    // EXE stage forwarding (memory load -> ALU operand/s)

    // base:
    // A: NOT lui/auipc/jal
    wire base_use_A = !(exe_opcode == 7'h37 || exe_opcode == 7'h17 || exe_opcode == 7'h6F);					// if inst uses operand A
    // B: conditions for A + r-type/b-type/store
    wire base_use_B = base_use_A && !(exe_opcode == 7'h37 || exe_opcode == 7'h17 || exe_opcode == 7'h6F);		// if inst uses operand B
    // compressed:
    // check if use_A/use_B is nonzero
    wire fwd_A = exe_is_comp ? exe_comp_use_A : base_use_A;
    wire fwd_B = exe_is_comp ? exe_comp_use_B : base_use_B;
    assign fw_mem_to_exe_A = (exe_rsA == mem_rd) && (exe_rsA != 0) && 
							mem_wr_en && (mem_sel_data == 2'd3) &&
							fwd_A;

	assign fw_mem_to_exe_B = (exe_rsB == mem_rd) && (exe_rsB != 0) && 
							mem_wr_en && (mem_sel_data == 2'd3) &&
							fwd_B;

    assign fw_wb_to_exe_A = (exe_rsA == wb_rd) && (exe_rsA != 0) && 
							wb_wr_en && (wb_sel_data == 2'd3) &&
							fwd_A;

    assign fw_wb_to_exe_B = (exe_rsB == wb_rd) && (exe_rsB != 0) && 
							wb_wr_en && (wb_sel_data == 2'd3) &&
							fwd_B;
endmodule