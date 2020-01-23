`timescale 1ns / 1ps

module datamem(
	input 				clk,
	
	input		[6:0]	p_addr,
	input		[31:0]	p_in,
	input				p_wr,
	input		[2:0]	p_load,
	input		[1:0]	p_store,
	
	input		[6:0]	c_addr,
	input		[31:0]	c_in,
	input				c_wr,
	input		[2:0]	c_load,
	input		[1:0]	c_store,
	
	output		[31:0]	p_out,
	output		[31:0]	c_out
);
	
	reg 		[31:0]	p_mem [0:15];
	reg 		[31:0]	c_mem [0:15];
	
	wire		[3:0]	p_eff_addr;
	wire		[3:0]	c_eff_addr;
	wire				p_sel;
	wire				c_sel;
	
//	wire c_clk = c_wr & !clk;
//	wire p_clk = p_wr & !clk;
	
	assign p_eff_addr = p_addr[5:2];
	assign c_eff_addr = c_addr[5:2];
	
	assign p_sel = p_addr[6];
	assign c_sel = c_addr[6];
	
	initial begin
		$readmemh("C:/Users/raszagal/Documents/papati/CoE 198/mcu/Master Controller/data_proc_mem.mem", p_mem);
		$readmemh("C:/Users/raszagal/Documents/papati/CoE 198/mcu/Master Controller/data_cont_mem.mem", c_mem);
	end
	
	// Read Ports
	assign p_out 	=	p_sel ?
																										// Controller Memory (upper bits)
							p_load == 3'h0	?	c_mem[p_eff_addr]										:		// 0: LW
							p_load == 3'h1	?	{{16{c_mem[p_eff_addr][15]}}, c_mem[p_eff_addr][15:0]}	:		// 1: LH
							p_load == 3'h2	?	{16'h0, c_mem[p_eff_addr][15:0]}						:		// 2: LHU
							p_load == 3'h3	?	{{24{c_mem[p_eff_addr][7]}}, c_mem[p_eff_addr][7:0]}	:		// 3: LB
							p_load == 3'h4	?	{24'h0, c_mem[p_eff_addr][7:0]}							:		// 4: LBU
												32'h0													:		// default: N/A
																										// Processor Memory (lower bits)
							p_load == 3'h0	?	p_mem[p_eff_addr]										:		// 0: LW
							p_load == 3'h1	?	{{16{p_mem[p_eff_addr][15]}}, p_mem[p_eff_addr][15:0]}	:		// 1: LH
							p_load == 3'h2	?	{16'h0, p_mem[p_eff_addr][15:0]}						:		// 2: LHU
							p_load == 3'h3	?	{{24{p_mem[p_eff_addr][7]}}, p_mem[p_eff_addr][7:0]}	:		// 3: LB
							p_load == 3'h4	?	{24'h0, p_mem[p_eff_addr][7:0]}							:		// 4: LBU
												32'h0													;		// default: N/A
	
	assign c_out 	=	c_sel ?
																										// Controller Memory (upper bits)
							c_load == 3'h0	?	c_mem[c_eff_addr]										:		// 0: LW
							c_load == 3'h1	?	{{16{c_mem[c_eff_addr][15]}}, c_mem[c_eff_addr][15:0]}	:		// 1: LH
							c_load == 3'h2	?	{16'h0, c_mem[c_eff_addr][15:0]}						:		// 2: LHU
							c_load == 3'h3	?	{{24{c_mem[c_eff_addr][7]}}, c_mem[c_eff_addr][7:0]}	:		// 3: LB
							c_load == 3'h4	?	{24'h0, c_mem[c_eff_addr][7:0]}							:		// 4: LBU
												32'h0													:		// default: N/A
																										// Processor Memory (lower bits)
							c_load == 3'h0	?	p_mem[c_eff_addr]										:		// 0: LW
							c_load == 3'h1	?	{{16{p_mem[c_eff_addr][15]}}, p_mem[c_eff_addr][15:0]}	:		// 1: LH
							c_load == 3'h2	?	{16'h0, p_mem[c_eff_addr][15:0]}						:		// 2: LHU
							c_load == 3'h3	?	{{24{p_mem[c_eff_addr][7]}}, p_mem[c_eff_addr][7:0]}	:		// 3: LB
							c_load == 3'h4	?	{24'h0, p_mem[c_eff_addr][7:0]}							:		// 4: LBU
												32'h0													;		// default: N/A
	
	// Write Ports
	always@(posedge clk)
		// Processor Side
			case(p_store)
				// 0: SW
				2'h0:	p_mem[p_eff_addr]			<= p_in;
				// 1: SH
				2'h1:	
					case(p_addr[1])
						1'h0:	p_mem[p_eff_addr]	<= (p_mem[p_eff_addr] & 32'hFFFF0000) | (p_in & 32'h0000FFFF);
						1'h1:	p_mem[p_eff_addr]	<= (p_mem[p_eff_addr] & 32'h0000FFFF) | ((p_in & 32'h0000FFFF) << 16);
					endcase	
				// 2: SB
				2'h2:
					case(p_addr[1:0])
						2'h0:	p_mem[p_eff_addr]	<= (p_mem[p_eff_addr] & 32'hFFFFFF00) | (p_in & 32'h000000FF);
						2'h1:	p_mem[p_eff_addr]	<= (p_mem[p_eff_addr] & 32'hFFFF00FF) | ((p_in & 32'h000000FF) << 8);
						2'h2:	p_mem[p_eff_addr]	<= (p_mem[p_eff_addr] & 32'hFF00FFFF) | ((p_in & 32'h000000FF) << 16);
						2'h3:	p_mem[p_eff_addr]	<= (p_mem[p_eff_addr] & 32'h00FFFFFF) | ((p_in & 32'h000000FF) << 24);
					endcase
				// 3: N/A
			endcase
	always@(posedge clk)
		// Controller Side
			case(c_store)
				// 0: SW
				2'h0:	c_mem[c_eff_addr]			<= c_in;
				// 1: SH
				2'h1:	
					case(c_addr[1])
						1'h0:	c_mem[c_eff_addr]	<= (c_mem[p_eff_addr] & 32'hFFFF0000) | (c_in & 32'h0000FFFF);
						1'h1:	c_mem[c_eff_addr]	<= (c_mem[p_eff_addr] & 32'h0000FFFF) | (c_in & 32'hFFFF0000);
					endcase	
				// 2: SB
				2'h2:
					case(c_addr[1:0])
						2'h0:	c_mem[c_eff_addr]	<= (c_mem[c_eff_addr] & 32'hFFFFFF00) | (c_in & 32'h000000FF);
						2'h1:	c_mem[c_eff_addr]	<= (c_mem[c_eff_addr] & 32'hFFFF00FF) | (c_in & 32'h0000FF00);
						2'h2:	c_mem[c_eff_addr]	<= (c_mem[c_eff_addr] & 32'hFF00FFFF) | (c_in & 32'h00FF0000);
						2'h3:	c_mem[c_eff_addr]	<= (c_mem[c_eff_addr] & 32'h00FFFFFF) | (c_in & 32'hFF000000);
					endcase
				// 3: N/A
			endcase
endmodule