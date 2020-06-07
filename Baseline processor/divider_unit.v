//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// divider_unit.v -- Container for Vivado Divider Generator modules
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: divider_unit.v
// Description:
//			The divider modules are generated through Vivado's IP Catalog
//			using the Divider Generator IP module. Both dividers use Radix2
//			since it naturally generates integer remainders (which is needed for REM[U]).
//			Both modules are generated with 32-bit Divisor & dividend widths, remainder type set to Remainder,
//			detect divide-by-zero disabled, Clocks per division set to 8, Flow control
//			set to Blocking, optimize goal set to Performance, ACLKEN and ARESETN enabled. One divider is generated
//	 		signed, while the other is unsigned.
//			The pipeline will stall until the operation is completed.
//			Latency is around 40-45 cycles.
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
module divider_unit(
	input CLK,
	input nrst,
	input load_hazard,

	input [31:0] opA,
	input [31:0] opB,

	input id_div_valid,
	input id_div_op_0,
	input exe_div_valid,
	input [1:0] exe_div_op,

	output reg div_running,
	output reg [31:0] DIVout
);
	// Parameters for div_op
	parameter DIV = 2'd0;
	parameter DIVU = 2'd1;
	parameter REM = 2'd2;
	parameter REMU = 2'd3;

	// For determining the status of the operation, a finite state machine (FSM)
	// is implemented. Here is a description of what occurs during each state:
	//
	// RESET		-- Do nothing. This state is entered one cycle after DONE or after a user reset.
	//					Next state is WAIT.
	// WAIT			-- Do nothing. Wait for div_valid to be asserted, indicating that the divider will execute.
	//					When div_valid is asserted, assert div_running. Next state is DIVIDING
	// DIVIDING		-- Do nothing. Wait for out_tvalid to be asserted, indicating that the divider has finished executing.
	//					Next state is DONE.
	// DONE			-- Set DIVout based on div_op. Deassert div_running. Next state is WAIT.
	parameter RESET = 2'd0;
	parameter WAIT = 2'd1;
	parameter DIVIDING = 2'd2;
	parameter DONE = 2'd3;

	// FSM signals
	reg [1:0] div_state, div_nstate;

	// To find out more about the port names of the div_gen
	// modules, please check PG151 - Divider Generator
	// and read about AXI4-Stream Interface.
	// The Basics: =============================================================
	// tready and tvalid are used to perform basic handshakes between the master
	// (RISC-V) and the slave (the Divider). Basically, the slave will only take
	// new valid inputs from the master once it's ready.

	// Signals for div_gen_signed module
	// Input
	wire div_signed_input_tvalid;

	// Outputs
	wire div_signed_dividend_tready;
	wire div_signed_divisor_tready;
	wire [63:0] div_signed_out_tdata;
	wire div_signed_out_tvalid;

	// Signals for div_gen_unsigned
	// Input
	wire div_unsigned_input_tvalid;

	// Outputs
	wire div_unsigned_dividend_tready;
	wire div_unsigned_divisor_tready;
	wire [63:0] div_unsigned_out_tdata;
	wire div_unsigned_out_tvalid;

	// Special Cases
	wire div_by_zero = (opB == 32'b0);		// division by zero
	wire div_signed_overflow = (opA == 32'h0x8000000) && (opB == 32'hFFFFFFFF);	// -2^31/-1 causes an overflow
	wire div_normal_case = !(div_by_zero || div_signed_overflow);

	// Assigning tvalid inputs
	// assert tvalid for one divider module only (depending if the operation is signed/unsigned)	
	// Note: the tvalid inputs are ANDed w/ div_state == WAIT because
	// we want them to be asserted for only one clock cycle during WAIT.
	// (put another way, we want them to be asserted by the next cycle (starting at state DIVIDING))
	assign div_signed_input_tvalid = exe_div_valid & ~exe_div_op[0] & (div_state == WAIT) & ~load_hazard;
	assign div_unsigned_input_tvalid = exe_div_valid & exe_div_op[0] & (div_state == WAIT) & ~load_hazard;

	// Instantiating Divider generator modules
	// NOTE: aresetn should be active for at least 2 cycles.
	wire divrem_clken = (~id_div_op_0 & id_div_valid) | (~exe_div_op[0] & exe_div_valid);
	wire divuremu_clken = (id_div_op_0 & id_div_valid) | (exe_div_op[0] & exe_div_valid);
	div_gen_signed DIVREM(
		.aclk(CLK),
		.aclken(divrem_clken),
		.aresetn(nrst),
		
		.s_axis_dividend_tdata(opA),
		.s_axis_dividend_tready(div_signed_dividend_tready),
		.s_axis_dividend_tvalid(div_signed_input_tvalid),

		.s_axis_divisor_tdata(opB),
		.s_axis_divisor_tready(div_signed_divisor_tready),
		.s_axis_divisor_tvalid(div_signed_input_tvalid),

		.m_axis_dout_tdata(div_signed_out_tdata),
		.m_axis_dout_tvalid(div_signed_out_tvalid)
	);

	div_gen_unsigned DIVUREMU(
		.aclk(CLK),
		.aclken(divuremu_clken),
		.aresetn(nrst),
		
		.s_axis_dividend_tdata(opA),
		.s_axis_dividend_tready(div_unsigned_dividend_tready),
		.s_axis_dividend_tvalid(div_unsigned_input_tvalid),

		.s_axis_divisor_tdata(opB),
		.s_axis_divisor_tready(div_unsigned_divisor_tready),
		.s_axis_divisor_tvalid(div_unsigned_input_tvalid),

		.m_axis_dout_tdata(div_unsigned_out_tdata),
		.m_axis_dout_tvalid(div_unsigned_out_tvalid)
	);

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
//-=-				DIV_STATE CONTROL 			 =-=//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
	initial begin
		div_state = RESET;
		DIVout = 0;
	end
	

	// Next state transition
	always@(posedge CLK) begin
		if(!nrst)
			div_state <= RESET;
		else
			div_state <= div_nstate;
	end

	// Next state logic (states described above)
	always@(*) begin
		case(div_state)
			RESET: div_nstate = WAIT;
			WAIT: begin
				if(exe_div_valid && !load_hazard)
					div_nstate = DIVIDING;
				else
					div_nstate = WAIT;
			end
			DIVIDING: begin
				if(div_unsigned_out_tvalid || div_signed_out_tvalid)
					div_nstate = DONE;
				else
					div_nstate = DIVIDING;
			end
			DONE: div_nstate = WAIT;
		endcase
	end

	// This controls div_running
	// Note: the reason we assert div_running at WAIT state instead of asserting it
	// at DIVIDING state is because when div_valid is asserted at WAIT, it means that a
	// division instruction is now in the EXE stage, and we want the pipeline to stall
	// immediately at the next cycle. Since we tied div_running to the stall signals through
	// sf_controller.v, we set it up such that it is already asserted 1 cycle before
	// the divider actually starts executing.
	// An equivalent condition for this would be 'case(div_nstate); DIVIDING: div_running = 1'
	always@(*) begin
		case(div_state)
			RESET: div_running = 0;
			WAIT: div_running = (exe_div_valid && !load_hazard)? 1'b1 : 1'b0;
			DIVIDING: div_running = 1'b1;
			DONE: div_running = 1'b0;
		endcase
	end

	// This controls DIVout. DIVout is set only once division is done
	// NOTE: Quotient is out_tdata[63:32], Remainder is out_tdata[31:0].
	// Just like div_running, we 'set' DIVout one cycle before div_state
	// transitions to DONE, so that when div_state goes to DONE at the next clock cycle,
	// DIVout is already set to the expected answer.
	// An equivalent condition for this would be 'if(div_nstate == DONE)'.
	always@(posedge CLK) begin
		if(!nrst)
			DIVout <= 0;
		else begin
			if (div_state == DIVIDING && (div_unsigned_out_tvalid || div_signed_out_tvalid))
				case(exe_div_op)
					DIV: DIVout <= div_normal_case ? div_signed_out_tdata[63:32] : 32'hFFFFFFFF;
					REM: DIVout <= div_normal_case ? div_signed_out_tdata[31:0] : (div_by_zero ? opA : 32'd0);
					DIVU: DIVout <= !div_by_zero ? div_unsigned_out_tdata[63:32] : 32'hFFFFFFFF;
					REMU: DIVout <= !div_by_zero ? div_unsigned_out_tdata[31:0] : opA;
				endcase
		end
	end
endmodule