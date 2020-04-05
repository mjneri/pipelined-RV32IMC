module fifo_mem(
	// Inputs
	input clk,
	input nrst,
	input wr,				// UART_CON[0]: EN
	input fifo_clr,			// RDDONE && FIFO_EMPTY
	input rd,				// BIT_INDEX = 7 && CLK_COUNT = 0
	input [7:0] data_in,

	// Outputs
	output [7:0] data_out,
	output fifo_full,		
	output fifo_empty,
	output fifo_threshold,
	output fifo_overflow,
	output fifo_underflow,
	output [4:0] wptr
);
	// Declaring wires

	wire[4:0] rptr; 
	wire fifo_we, fifo_rd;   

	// Instantiating modules
	write_pointer WPTR(
		.clk(clk),
		.nrst(nrst),
		.wptr(wptr),
		.fifo_we(fifo_we),
		.wr(wr),
		.fifo_full(fifo_full),
		.fifo_clr(fifo_clr)
	);

	read_pointer RPTR(
		.clk(clk),
		.nrst(nrst),
		.rptr(rptr),
		.fifo_rd(fifo_rd),
		.rd(rd),
		.fifo_empty(fifo_empty),
		.fifo_clr(fifo_clr)
	);

	memory_array MEM_ARRAY(
		.clk(clk),
		.nrst(nrst),
		.data_in(data_in),
		.data_out(data_out),
		.fifo_we(fifo_we),
		.wptr(wptr),
		.rptr(rptr),
		.fifo_clr(fifo_clr)
	);

	status_signal STATUS_SIGNAL(
		.clk(clk),
		.nrst(nrst),
		.wr(wr),
		.rd(rd),
		.fifo_we(fifo_we),
		.fifo_rd(fifo_rd),
		.wptr(wptr),
		.rptr(rptr),
		.fifo_clr(fifo_clr),
		.fifo_full(fifo_full),
		.fifo_empty(fifo_empty),
		.fifo_threshold(fifo_threshold),
		.fifo_overflow(fifo_overflow),
		.fifo_underflow(fifo_underflow)
	);
endmodule 

// fpga4student.com: FPga projects, Verilog projects, VHDL projects
// Verilog project: Verilog code for FIFO memory
// Verilog code for Memory Array submodule 
module memory_array(
	input clk,
	input nrst,
	input fifo_clr,
	input fifo_we,
	input [7:0] data_in,
	input [4:0] wptr,
	input [4:0] rptr,
	output [7:0] data_out
 );

	reg [7:0] fifo_array [31:0];  
	wire [7:0] data_out;  
	integer i;

	// Initializing registers
	initial begin
	for(i = 0; i < 32; i = i + 1)
		fifo_array[i]    <=    8'd0;
	end

	always @(posedge clk) begin
		if(!nrst | fifo_clr)
			for(i = 0; i < 32; i = i + 1)
				fifo_array[i]    <=    8'd0;
		else  
			if(fifo_we)   
				fifo_array[wptr] <= data_in ;  
	end  

	assign data_out = fifo_array[rptr];  
endmodule

// fpga4student.com: FPga projects, Verilog projects, VHDL projects
// Verilog project: Verilog code for FIFO memory
// Verilog code for Read Pointer sub-module
// RPTR increments as bytes are sent.
module read_pointer(
	input clk,
	input nrst,
	input rd,
	input fifo_empty,
	input fifo_clr,
	
	output reg [4:0] rptr,
	output fifo_rd
 );

	assign fifo_rd = (~fifo_empty) & rd;

	// Initializing registers
	initial begin
		rptr = 0;
	end

	always @(posedge clk) begin  
		if(~nrst | fifo_clr)
			rptr <= 0;  
		else if(fifo_rd)
			rptr <= rptr + 5'b1;
		// else
		// 	rptr <= rptr;
	end  
endmodule

// fpga4student.com: FPga projects, Verilog projects, VHDL projects
// Verilog project: Verilog code for FIFO memory
// Verilog code for Status Signals sub-module 
module status_signal(
	input clk,
	input nrst,
	input wr,
	input rd,
	input fifo_we,
	input fifo_rd,
	input fifo_clr,
	input [4:0] wptr,
	input [4:0] rptr,

	output reg fifo_full,
	output reg fifo_empty,
	output reg fifo_threshold,
	output reg fifo_overflow,
	output reg fifo_underflow
 );

	wire fbit_comp, overflow_set, underflow_set;  
	wire pointer_equal;  
	wire [4:0] pointer_result;

	assign fbit_comp = wptr[4] ^ rptr[4];
	assign overflow_set = fifo_full & wr;
	assign underflow_set = fifo_empty & rd;
	// assign pointer_equal = (wptr[3:0] - rptr[3:0])? 0 : 1;
	assign pointer_equal = (wptr == rptr)? 1 : 0;
	assign pointer_result = wptr[4:0] - rptr[4:0];

	// Initializing registers
	initial begin
		fifo_overflow = 0;
		fifo_underflow = 0;
	end

	always@(*) begin  
		fifo_full = fbit_comp & pointer_equal;  
		fifo_empty = (~fbit_comp) & pointer_equal;  
		fifo_threshold = (pointer_result[4]||pointer_result[3]) ? 1:0;  
	end

	always@(posedge clk) begin  
		if(~nrst | fifo_clr)
			fifo_overflow <=0;  
		else if((overflow_set==1) && (fifo_rd==0))  
			fifo_overflow <=1;
		else if(fifo_rd)  
			fifo_overflow <=0;  
		else  
			fifo_overflow <= fifo_overflow;  
	end

	always@(posedge clk) begin  
		if(~nrst | fifo_clr)
			fifo_underflow <=0;  
		else if((underflow_set==1) && (fifo_we==0))  
			fifo_underflow <=1;
		else if(fifo_we)
			fifo_underflow <=0;
		else  
			fifo_underflow <= fifo_underflow;
	end  
endmodule

// fpga4student.com: FPga projects, Verilog projects, VHDL projects
// Verilog project: Verilog code for FIFO memory
// Verilog code for Write Pointer sub-module   
// WPTR increments as bytes are written into the FIFO memory.
module write_pointer(
	input clk,
	input nrst,
	input wr,
	input fifo_full,
	input fifo_clr,

	output reg [4:0] wptr,
	output fifo_we			// FIFO Write enable
 );

	assign fifo_we = (~fifo_full) & wr;

	// Initializing registers
	initial begin
		wptr = 0;
	end

	always @(posedge clk) begin  
		if(~nrst | fifo_clr)
			wptr <= 5'b0;  
		else if(fifo_we)  
			wptr <= wptr + 5'b1;  
		// else  
		// 	wptr <= wptr;  
	end
endmodule  