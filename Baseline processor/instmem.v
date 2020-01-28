`timescale 1ns / 1ps

module instmem(
	//input clk,
	input [11:0] addr, 
	output [31:0] inst
);

	/*reg			[7:0]	memory	[0:4095];

	initial
		$readmemh ("instmem_parse.mem", memory);
		
	always@(posedge clk) begin
		inst <= {memory[addr + 3],
					memory[addr + 2],
					memory[addr + 1],
					memory[addr]};
	end*/

	// INSTMEM uses Block memory from Vivado Block mem Generator module
	/*blk_mem_gen_instmem BLOCKMEM(
		.clka(clk),
		.addra(addr[11:2]),
		.douta(inst)
	);*/

	reg [31:0] memory [0:1023];
	initial begin
		$readmemh("instmem.mem", memory);
	end

	assign inst = memory[addr[11:2]];

endmodule