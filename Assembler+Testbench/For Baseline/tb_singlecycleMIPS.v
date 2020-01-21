`timescale 1ns/1ps
`define DEL_IN  7
`define MEM_ADDR_WIDTH 32
`define CLK_PERIOD  10
`define WORD_WIDTH 32

module tb_single_cycle_mips();
    
    reg CLK100MHZ;
    wire CLK8MHZ;
    reg nrst;
    wire [31:0] inst;                  // 32-bit instruction (from instruction memory)
	wire [31:0] data_in;          // data from memory to processor
    wire [31:0] data_out;         // data from processor to memory
    wire data_wr;                                   // data memory write enable
    wire [31:0] inst_addr;         // program counter
    wire [31:0] data_addr;         // data memory address
    wire [7:0] data_map;		// memory mapped data address
    
    clk_wiz_0 CLKIP(
    	.clk_in1(CLK100MHZ),
    	.clk_out1(CLK8MHZ)
    );

    single_cycle_mips UUT (
        .clk(CLK8MHZ),
        .nrst(nrst),
        .inst(inst),
        .data_in(data_in),
        .inst_addr(inst_addr),
        .data_addr(data_addr),
        .data_out(data_out),
        .data_wr(data_wr)
    );

    instmem I1 (
        .inst_addr(inst_addr),
        .inst(inst)
    );

    datamem D1 (
        .clk(CLK8MHZ),
        .data_addr(data_addr),
        .data_wr(data_wr),
        .data_in(data_in),
        .data_out(data_out),
        .data_map(data_map)
    );

    datamem_ans D2 ();

    always 
        #5 CLK100MHZ = ~CLK100MHZ;

    integer i;
    integer done;
    integer check_done;
    integer pass;

    initial begin 
        CLK100MHZ = 0;
        nrst = 0;
        done = 0;
        check_done = 0;
        
         for (i=0;i<100;i=i+1) begin
			$display("%X%X%X%X\t",
			D1.memory[(i*4)],
			D1.memory[(i*4)+1],
			D1.memory[(i*4)+2],
			D1.memory[(i*4)+3]);
		end
		$display("\n\n");
        
        #100 nrst = 1;
    end

    always@(posedge CLK100MHZ) begin
        if(inst == 32'h0)
            check_done = check_done + 1;
    end
    always@(posedge CLK100MHZ) begin
        if(check_done == 10)
            done = 1;
    end


    always@(posedge done) begin
        pass = 0;
        $display("== SUMMARY ==");
        $display("Actual  \tExpected");
        $display("========\t========");
        for (i=0;i<100;i=i+1) begin
            if(D1.memory[(i*4)]==D2.memory[(i*4)] && D1.memory[(i*4)+1]==D2.memory[(i*4)+1] && D1.memory[(i*4)+2]==D2.memory[(i*4)+2] && D1.memory[(i*4)+3]==D2.memory[(i*4)+3]) begin
                $display("%X%X%X%X\t%X%X%X%X\tPass",
                D1.memory[(i*4)],
                D1.memory[(i*4)+1],
                D1.memory[(i*4)+2],
                D1.memory[(i*4)+3],
                D2.memory[(i*4)],
                D2.memory[(i*4)+1],
                D2.memory[(i*4)+2],
                D2.memory[(i*4)+3]);
                pass = pass + 1;
            end else begin
                $display("%X%X%X%X\t%X%X%X%X\tFail",
                D1.memory[(i*4)],
                D1.memory[(i*4)+1],
                D1.memory[(i*4)+2],
                D1.memory[(i*4)+3],
                D2.memory[(i*4)],
                D2.memory[(i*4)+1],
                D2.memory[(i*4)+2],
                D2.memory[(i*4)+3]);
            end
        end

        $display("\n\n");
        $display("Passed\t%d/%d test cases", pass, i);//*/
        $finish;
    end
endmodule

module datamem_ans();
    reg [7:0] memory [0:4095];
    initial begin
        $readmemh("datamem_ans_parse.mem", memory);
    end
endmodule
