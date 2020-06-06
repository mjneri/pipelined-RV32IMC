`timescale 1ns / 1ps

 module i2c(
 
	// Inputs
	input 	wire clk,
	input 	wire nrst,
	input 	wire [31:0] memory_data,
	input 	wire [31:0] memory_control,
	
	// Tri-state I2C Pins
	// inout i2c_scl_pin,
	// inout i2c_sda_pin
	input 	wire i2c_scl_i,
	output 	wire i2c_scl_o,
	output 	wire i2c_scl_t,
	input 	wire i2c_sda_i,
	output 	wire i2c_sda_o,
	output 	wire i2c_sda_t,
	output 	wire i2c_slave_sda_o,
	
	output	wire [31:0] i_dat,
	output	wire [31:0] con_out
	
	);
		
	
	
	/*
		Wishbone Interface Wire Signals
	*/
	wire  [2:0] wb_adr_int;   // ADR_I() address
	wire  [7:0] wb_dat_mo_int;   // DAT_I() data in
	wire  [7:0] wb_dat_mi_int;   // DAT_O() data out
	wire        wb_we_int;    // WE_I write enable input
	wire        wb_stb_int;   // STB_I strobe input
	wire        wb_ack_int;   // ACK_O acknowledge output
	wire        wb_cyc_int;   // CYC_I cycle input
	
	/*
		I2C Bus Wire Signals
	*/

	wire sda_passthrough_i;	//	to be able to simulate the sda output of a slave through a testbench
	wire busy_int;
	wire busy;
	wire done;
	wire nack;
	wire [7:0] i_dat_temp;
	
	assign con_out = {29'h0, nack, done, busy};
	//assign data_out = {24'h0, wb_dat_mo_int};
	assign i_dat = {24'h0, i_dat_temp};
	
	//Set-up I2C Bus

	assign sda_passthrough_i = nrst;
	// assign i2c_scl_i = i2c_scl_pin;
	// assign i2c_scl_pin = i2c_scl_t ? 1'bz : i2c_scl_o; //i2c_scl_t and i2c_scl_o essentially the same in the i2c_master module
	// assign i2c_sda_i = i2c_sda_pin;
	// assign i2c_sda_pin = (i2c_sda_t & i2c_slave_sda_o) ? 1'bz : 0; //i2c_sda_t and i2c_sda_o essentially the same in the i2c_master module
	
	i2c_main_controller I2C_CTRLR(
		.clk(clk), 
		.nrst(nrst),
		.done(done),
		.busy(busy),
		.nack(nack),
		.memory_control(memory_control),
		.memory_data(memory_data),
		.wbm_adr_o(wb_adr_int), 
		.wbm_dat_o(wb_dat_mo_int), 
		.wbm_dat_i(wb_dat_mi_int), 
		.wbm_we_o(wb_we_int), 
		.wbm_stb_o(wb_stb_int), 
		.wbm_ack_i(wb_ack_int), 
		.wbm_cyc_o(wb_cyc_int)
	);
	
	i2c_master_wbs_8 i2c_master_wbs_8_inst(
		.clk(clk),
		.nrst(nrst),
		.wbs_adr_i(wb_adr_int),
		.wbs_dat_i(wb_dat_mo_int),
		.wbs_dat_o(wb_dat_mi_int),
		.wbs_we_i(wb_we_int),
		.wbs_stb_i(wb_stb_int),
		.wbs_ack_o(wb_ack_int),
		.wbs_cyc_i(wb_cyc_int),
		.i2c_scl_i(i2c_scl_i),
		.i2c_scl_o(i2c_scl_o),
		.i2c_scl_t(i2c_scl_t),
		.i2c_sda_i(i2c_sda_i),
		.i2c_sda_o(i2c_sda_o),
		.i2c_sda_t(i2c_sda_t),
		.busy_int(busy_int),
		.i_dat_temp(i_dat_temp)
	);
	
	i2c_slave_temp i2c_slave_inst(
		.clk(clk),
		.nrst(nrst),
		.sda_passthrough_i(sda_passthrough_i),
		.i2c_slave_sda_o(i2c_slave_sda_o)
	);


endmodule

module i2c_slave_temp (
	input	clk,
	input	nrst,
	input	wire	sda_passthrough_i,
	output	reg	i2c_slave_sda_o
	);

	initial begin
		i2c_slave_sda_o = 1;
	end
	
	always@(posedge clk) begin
		if (!nrst) begin
			i2c_slave_sda_o <= 1;
		end
		else begin
			i2c_slave_sda_o <= sda_passthrough_i;
		end
	end
	
endmodule

	