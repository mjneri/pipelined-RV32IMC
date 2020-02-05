`timescale 1ns / 1ps

module forwarding_unit(
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
    input [1:0] id_sel_data,
    input [1:0] exe_sel_data,
    input [1:0] mem_sel_data,
    input [1:0] wb_sel_data,
    input id_is_stype,
    input exe_is_stype,

	output fw_exe_to_id_A,
    output fw_exe_to_id_B,
    output fw_mem_to_id_A,
    output fw_mem_to_id_B,
    output fw_wb_to_id_A,
    output fw_wb_to_id_B,
    
    output fw_mem_to_exe_A,
    output fw_mem_to_exe_B,
    output fw_wb_to_exe_A,
    output fw_wb_to_exe_B );

    assign fw_exe_to_id_A = (id_rsA == exe_rd) && (id_rsA != 0) && exe_wr_en && id_sel_opA && (exe_sel_data != 2'd3);
    assign fw_exe_to_id_B = (id_rsB == exe_rd) && (id_rsB != 0) && exe_wr_en && (!id_sel_opB || id_is_stype) && (exe_sel_data != 2'd3);
    assign fw_mem_to_id_A = (id_rsA == mem_rd) && (id_rsA != 0) && mem_wr_en && id_sel_opA;
    assign fw_mem_to_id_B = (id_rsB == mem_rd) && (id_rsB != 0) && mem_wr_en && !id_sel_opB;
    assign fw_wb_to_id_A = (id_rsA == wb_rd) && (id_rsA != 0) && wb_wr_en && id_sel_opA;
    assign fw_wb_to_id_B = (id_rsB == wb_rd) && (id_rsB != 0) && wb_wr_en && (!id_sel_opB || (wb_sel_data == 2'd3));

    assign fw_mem_to_exe_A = (exe_rsA == mem_rd) && (exe_rsA != 0) && mem_wr_en && (mem_sel_data == 2'd3);
    assign fw_mem_to_exe_B = (exe_rsB == mem_rd) && (exe_rsB != 0) && mem_wr_en && ((mem_sel_data == 2'd3) || exe_is_stype);
    assign fw_wb_to_exe_A = (exe_rsA == wb_rd) && (exe_rsA != 0) && wb_wr_en && (wb_sel_data == 2'd3);
    assign fw_wb_to_exe_B = (exe_rsB == wb_rd) && (exe_rsB != 0) && wb_wr_en && (wb_sel_data == 2'd3);

endmodule