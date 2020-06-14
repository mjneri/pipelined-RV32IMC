//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// uart_datamemdump.v -- RV32IMC Processor Answer key stuff
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: uart_datamemdump.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module uart_datamemdump(
	// 50MHz clock input from CLKIP
	input CLK,
	input nrst,

	// Input data from the DATAMEM in the RISC-V Core
	input [31:0] con_data,
	
	// Output word address to the RISC-V Core 
	output reg [9:0] con_addr,

	// Output to UART_TX pin of the Arty7 FPGA
	output TX
);
	
	// UART_TX control signals
	// -=-=-=-=-=-=-=-
	// dont_touch attribute was used for UARTData to prevent
	// Vivado from merging parts of it together. Not sure if
	// it actually affects the behavior of the module, but in
	// this case, we know it works.
	reg UARTSend;
	wire UARTReady;
	(* dont_touch = "yes" *) reg [7:0] UARTData;

	UART_TX UART_TX(
		.SEND(UARTSend),
		.DATA(UARTData),
		.CLK(CLK),
		.READY(UARTReady),
		.TX(TX)
	);
	
	// Definitions for the UARTDUMP state machine. Here is a description of what occurs during each state:
	//
	// RESET			-- Do nothing. This state is entered after configuration or a user reset. Also, 
	//						we set con_addr to the address that UARTDUMP is mapped to in the RISC-V Core.
	//						Next state is WAIT_SEND.
	//
	// WAIT_SEND		-- Do nothing. Wait for the corresponding data to be set in
	//						whatever address that UARTDUMP is mapped to in the RISC-V 
	//						Core, indicating that the program is finished running and
	//						we can start dumping the contents of the data memory to the
	//						USB-UART Bridge. If the data we're looking for is present in
	//						the mapped address, then we stop incrementing clock_counter and set con_addr
	//						to address 0. Next state is LD_TESTPROGNAME.
	//
	// LD_TESTPROGNAME	-- The program name running in the RISC-V core is loaded into the
	//						sendStr variable and the strIndex variable is set to zero. The
	//						string length is stored in the strLength variable. Next state is
	//						SEND_CHAR.
	//
	// SEND_CHAR		-- UARTSend is asserted for a single clock cycle, signaling the character
	//						at sendStr(strIndex) to be registered by the UART_TX module at the
	//						next cycle. strIndex is also incremented (behaves as if it were post 
	//						incremented after reading the sendStr data). Next state is RDY_LOW.
	//
	// RDY_LOW			-- Do nothing. Wait for the UARTReady signal to go low, indicating a send
	//						operation has begun. Next state is WAIT_RDY.
	//
	// WAIT_RDY			-- Do nothing. Wait for the UARTReady signal to go high, indicating a send
	//						operation has finished. If UARTReady is high and strIndex != strLength,
	//						next state is SEND_CHAR (indicating that the string is not done sending
	//						yet). Else, if UARTReady is high and strIndex == strLength, the next state
	//						depends on the value of strLast (or what string was last sent).
	//						If strLast == LD_TESTPROGNAME, next state is LD_LINE1.
	//						If strLast == LD_LINE1, next state is LD_LINE2.
	//						If strLast == LD_LINE2, next state is LD_LINE3.
	//						If strLast == LD_LINE3, next state is CHECK_ANSKEY.
	//						If strLast == LD_ANSWER and con_addr == 10'h3FF (indicating that it has dumped
	//							all the contents of the RISC-V core datamem, next state is CHECK_RESULT.
	//						If strLast == LD_RESULT, next state is LD_CLOCKCYCLES.
	//						If strLast == LD_CLOCKCYCLES, next state is LD_ENDLINE.
	//						If strLast == LD_ENDLINE, next state is DONE.
	//
	// LD_LINE1			-- Line 1 is loaded into the sendStr variable and the strIndex variable is set to
	//						zero. The string length is stored in the strLength variable. Next state is SEND_CHAR.
	//
	// LD_LINE2			-- Line 2 is loaded into the sendStr variable and the strIndex variable is set to
	//						zero. The string length is stored in the strLength variable. Next state is SEND_CHAR.
	//
	// LD_LINE3			-- Line 3 is loaded into the sendStr variable and the strIndex variable is set to
	//						zero. The string length is stored in the strLength variable. Next state is SEND_CHAR.
	//
	// CHECK_ANSKEY		-- con_data(the data from the RISC-V core that corresponds to con_addr) is compared with
	//						the answer key to determine if the test case was passed. The variable test_pass is
	//						incremented accordingly. Next state is LD_ANSWER.
	//
	// LD_ANSWER		-- The string corresponding to the answers from the RISC-V core and the answer key is loaded
	//						into the sendStr variable and the strIndex variable is set to zero. The string length is
	//						stored in the strLength variable. Next state is SEND_CHAR
	//
	// CHECK_RESULT		-- test_pass is compared with the amount of test cases done (usually corresponds to the size of
	//						the RISC-V core's data memory). Next state is LD_RESULT.
	//
	// LD_RESULT		-- The string corresponding to test_pass is loaded into the sendStr variable
	//						and the strIndex variable is set to zero. The string length is stored in the strLength variable.
	//						Next state is SEND_CHAR.
	//
	// LD_CLOCKCYCLES	-- The string corresponding to clock_counter is loaded into the sendStr variable
	//						and the strIndex variable is set to zero. The string length is stored in the strLength variable.
	//						Next state is SEND_CHAR.
	//
	// LD_ENDLINE		-- The last line is is loaded into the sendStr variable and the strIndex variable is set to zero. 
	//						The string length is stored in the strLength variable. Next state is SEND_CHAR.
	//
	// DONE 			-- Do nothing. This is the last state of the state machine and it will stay in this state until
	//						a user reset is performed again.
	// UARTDUMP format:
	//
	// 'Test program name' \r\n 					TESTPROGNAME
	// ----------| SUMMARY |----------\r\n 			LINE1
	// Address\t  Actual  \t Expected \r\n 			LINE2
	// =======\t==========\t==========\r\n 			LINE3
	// 0x000  \t0x00000000\t0x00000000\tPass\r\n 	ANSWER
	// ...
	// 0x3FF  \t0x00000000\t0x00000000\tFail\r\n 	ANSWER
	// \r\n 										RESULT
	// Passed: X/Y test cases.\r\n 					RESULT
	// Clock cycles: X\r\n 							CLOCKCYCLES
	// ===============================\r\n 			ENDLINE
	// \n\n\n 										ENDLINE
	parameter RESET 			= 4'h0;
	parameter WAIT_SEND 		= 4'h1;
	parameter LD_TESTPROGNAME 	= 4'h2;
	parameter SEND_CHAR 		= 4'h3;
	parameter RDY_LOW 			= 4'h4;
	parameter WAIT_RDY 			= 4'h5;
	parameter LD_LINE1 			= 4'h6;
	parameter LD_LINE2 			= 4'h7;
	parameter LD_LINE3 			= 4'h8;
	parameter CHECK_ANSKEY 		= 4'h9;
	parameter LD_ANSWER 		= 4'hA;
	parameter CHECK_RESULT 		= 4'hB;
	parameter LD_RESULT 		= 4'hC;
	parameter LD_CLOCKCYCLES 	= 4'hD;
	parameter LD_ENDLINE 		= 4'hE;
	parameter DONE 				= 4'hF;

	// Defining other constants needed:
	parameter MAX_STR_LEN = 36;				// based on ANSWER
	parameter RESET_CTR_MAX = 18'h186A0;	// 50MHz * 2ms

	// This value has to be changed everytime the test program is changed.
	// Also note that \r & \n are included in the string length.
	parameter TESTPROGNAME_STR_LEN = 12;

	parameter LINE1_STR_LEN = 33;
	parameter LINE2_STR_LEN = 31;
	parameter LINE3_STR_LEN = 31;
	parameter ANSWER_STR_LEN = 36;
	parameter RESULT_STR_LEN = 35;
	parameter CLOCKCYCLES_STR_LEN = 26;
	parameter ENDLINE_STR_LEN = 36;

	// Test program name definition. Note that the values stored at each index
	// are the ASCII values of the indicated character. Also note that for
	// Verilog, wire arrays should be used when defining constant arrays, and that
	// each index has to be assigned individually.
	// This should also be changed everytime the test program is changed.
	// alu_test.s
	wire [7:0] TESTPROGNAME_STR [0:TESTPROGNAME_STR_LEN - 1];
		assign TESTPROGNAME_STR[0] = "a";
		assign TESTPROGNAME_STR[1] = "l";
		assign TESTPROGNAME_STR[2] = "u";
		assign TESTPROGNAME_STR[3] = "_";
		assign TESTPROGNAME_STR[4] = "t";
		assign TESTPROGNAME_STR[5] = "e";
		assign TESTPROGNAME_STR[6] = "s";
		assign TESTPROGNAME_STR[7] = "t";
		assign TESTPROGNAME_STR[8] = ".";
		assign TESTPROGNAME_STR[9] = "s";
		assign TESTPROGNAME_STR[10] = 8'h0D;
		assign TESTPROGNAME_STR[11] = 8'h0A;

	// LINE 1 string definition
	// ----------| SUMMARY |----------\r\n
	wire [7:0] LINE1_STR [0:LINE1_STR_LEN - 1];
		assign LINE1_STR[0] = "-";
		assign LINE1_STR[1] = "-";
		assign LINE1_STR[2] = "-";
		assign LINE1_STR[3] = "-";
		assign LINE1_STR[4] = "-";
		assign LINE1_STR[5] = "-";
		assign LINE1_STR[6] = "-";
		assign LINE1_STR[7] = "-";
		assign LINE1_STR[8] = "-";
		assign LINE1_STR[9] = "-";
		assign LINE1_STR[10] = "|";
		assign LINE1_STR[11] = " ";
		assign LINE1_STR[12] = "S";
		assign LINE1_STR[13] = "U";
		assign LINE1_STR[14] = "M";
		assign LINE1_STR[15] = "M";
		assign LINE1_STR[16] = "A";
		assign LINE1_STR[17] = "R";
		assign LINE1_STR[18] = "Y";
		assign LINE1_STR[19] = " ";
		assign LINE1_STR[20] = "|";
		assign LINE1_STR[21] = "-";
		assign LINE1_STR[22] = "-";
		assign LINE1_STR[23] = "-";
		assign LINE1_STR[24] = "-";
		assign LINE1_STR[25] = "-";
		assign LINE1_STR[26] = "-";
		assign LINE1_STR[27] = "-";
		assign LINE1_STR[28] = "-";
		assign LINE1_STR[29] = "-";
		assign LINE1_STR[30] = "-";
		assign LINE1_STR[31] = 8'h0D;
		assign LINE1_STR[32] = 8'h0A;

	// LINE 2 string definition
	// Address\t  Actual  \t Expected \r\n
	wire [7:0] LINE2_STR [0:LINE2_STR_LEN - 1];
		assign LINE2_STR[0] = "A";
		assign LINE2_STR[1] = "d";
		assign LINE2_STR[2] = "d";
		assign LINE2_STR[3] = "r";
		assign LINE2_STR[4] = "e";
		assign LINE2_STR[5] = "s";
		assign LINE2_STR[6] = "s";
		assign LINE2_STR[7] = 8'h09;
		assign LINE2_STR[8] = " ";
		assign LINE2_STR[9] = " ";
		assign LINE2_STR[10] = "A";
		assign LINE2_STR[11] = "c";
		assign LINE2_STR[12] = "t";
		assign LINE2_STR[13] = "u";
		assign LINE2_STR[14] = "a";
		assign LINE2_STR[15] = "l";
		assign LINE2_STR[16] = " ";
		assign LINE2_STR[17] = " ";
		assign LINE2_STR[18] = 8'h09;
		assign LINE2_STR[19] = " ";
		assign LINE2_STR[20] = "E";
		assign LINE2_STR[21] = "x";
		assign LINE2_STR[22] = "p";
		assign LINE2_STR[23] = "e";
		assign LINE2_STR[24] = "c";
		assign LINE2_STR[25] = "t";
		assign LINE2_STR[26] = "e";
		assign LINE2_STR[27] = "d";
		assign LINE2_STR[28] = " ";
		assign LINE2_STR[29] = 8'h0D;
		assign LINE2_STR[30] = 8'h0A;
	
	// LINE 3 string definition
	// =======\t==========\t==========\r\n
	wire [7:0] LINE3_STR [0:LINE3_STR_LEN - 1];
		assign LINE3_STR[0] = "=";
		assign LINE3_STR[1] = "=";
		assign LINE3_STR[2] = "=";
		assign LINE3_STR[3] = "=";
		assign LINE3_STR[4] = "=";
		assign LINE3_STR[5] = "=";
		assign LINE3_STR[6] = "=";
		assign LINE3_STR[7] = 8'h09;
		assign LINE3_STR[8] = "=";
		assign LINE3_STR[9] = "=";
		assign LINE3_STR[10] = "=";
		assign LINE3_STR[11] = "=";
		assign LINE3_STR[12] = "=";
		assign LINE3_STR[13] = "=";
		assign LINE3_STR[14] = "=";
		assign LINE3_STR[15] = "=";
		assign LINE3_STR[16] = "=";
		assign LINE3_STR[17] = "=";
		assign LINE3_STR[18] = 8'h09;
		assign LINE3_STR[19] = "=";
		assign LINE3_STR[20] = "=";
		assign LINE3_STR[21] = "=";
		assign LINE3_STR[22] = "=";
		assign LINE3_STR[23] = "=";
		assign LINE3_STR[24] = "=";
		assign LINE3_STR[25] = "=";
		assign LINE3_STR[26] = "=";
		assign LINE3_STR[27] = "=";
		assign LINE3_STR[28] = "=";
		assign LINE3_STR[29] = 8'h0D;
		assign LINE3_STR[30] = 8'h0A;

	// END LINE string definition
	// ===============================\r\n\n\n\n
	wire [7:0] ENDLINE_STR [0:ENDLINE_STR_LEN - 1];
		assign ENDLINE_STR[0] = "=";
		assign ENDLINE_STR[1] = "=";
		assign ENDLINE_STR[2] = "=";
		assign ENDLINE_STR[3] = "=";
		assign ENDLINE_STR[4] = "=";
		assign ENDLINE_STR[5] = "=";
		assign ENDLINE_STR[6] = "=";
		assign ENDLINE_STR[7] = "=";
		assign ENDLINE_STR[8] = "=";
		assign ENDLINE_STR[9] = "=";
		assign ENDLINE_STR[10] = "=";
		assign ENDLINE_STR[11] = "=";
		assign ENDLINE_STR[12] = "=";
		assign ENDLINE_STR[13] = "=";
		assign ENDLINE_STR[14] = "=";
		assign ENDLINE_STR[15] = "=";
		assign ENDLINE_STR[16] = "=";
		assign ENDLINE_STR[17] = "=";
		assign ENDLINE_STR[18] = "=";
		assign ENDLINE_STR[19] = "=";
		assign ENDLINE_STR[20] = "=";
		assign ENDLINE_STR[21] = "=";
		assign ENDLINE_STR[22] = "=";
		assign ENDLINE_STR[23] = "=";
		assign ENDLINE_STR[24] = "=";
		assign ENDLINE_STR[25] = "=";
		assign ENDLINE_STR[26] = "=";
		assign ENDLINE_STR[27] = "=";
		assign ENDLINE_STR[28] = "=";
		assign ENDLINE_STR[29] = "=";
		assign ENDLINE_STR[30] = "=";
		assign ENDLINE_STR[31] = 8'h0D;
		assign ENDLINE_STR[32] = 8'h0A;
		assign ENDLINE_STR[33] = 8'h0A;
		assign ENDLINE_STR[34] = 8'h0A;
		assign ENDLINE_STR[35] = 8'h0A;

	// String definitions for ANSWER_STR, RESULT_STR, & CLOCKCYCLES_STR
	// 0x3FF  \t0x00000000\t0x00000000\tFail\r\n 	ANSWER
	// \r\nPassed: X/Y test cases.\r\n 				RESULT
	// Clock cycles: X\r\n 							CLOCKCYCLES
	reg [7:0] ANSWER_STR [0:ANSWER_STR_LEN - 1];
	reg [7:0] RESULT_STR [0:RESULT_STR_LEN - 1];
	reg [7:0] CLOCKCYCLES_STR [0:CLOCKCYCLES_STR_LEN - 1];

	// Contains the current string being sent over UART.
	reg [7:0] sendStr [0:MAX_STR_LEN - 1];

	// Initializing all char arrays
	integer i;
	initial begin
		for(i = 0; i < ANSWER_STR_LEN; i = i+1)
			ANSWER_STR[i] = "\0";

		for(i = 0; i < RESULT_STR_LEN; i = i+1)
			RESULT_STR[i] = "\0";

		for(i = 0; i < CLOCKCYCLES_STR_LEN; i = i+1)
			CLOCKCYCLES_STR[i] = "\0";

		for(i = 0; i < MAX_STR_LEN; i = i+1)
			sendStr[i] = "\0";
	end

	// Contains the length of the current string being sent over UART.
	reg [5:0] strLength;

	// Contains the index of the next character to be sent over UART
	// within sendStr.
	reg [5:0] strIndex;

	// Current UART state signal
	reg [3:0] UARTState;

	// This counter counts the amount of time paused in the UART reset state
	reg [17:0] reset_ctr;

	// Contains the last string sent
	reg [3:0] strLast;

	// Determines how many clock cycles the program in the RISC-V core ran.
	reg [31:0] clock_counter;

	// Determines how many test cases were passed by the RISC-V core based on the answer key.
	reg [9:0] test_pass;

	// Determines the total amount of test cases.
	reg [9:0] test_total;

	// Answer key memory
	reg [31:0] answerkey [0:1023];
	initial begin
		$readmemh("answerkey.mem", answerkey);
	end
	
	// The data that the module is looking for before dumping the data memory contents
	parameter TRIGGER_DATA = 32'hade1b055;

	// The address that UARTDUMP is mapped to in the RISC-V core
	parameter MAPPED_ADDR = 10'h3FF;

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
//-=-				UART Control 				 =-=//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=//
	
	// This counter determines how many clock cycles it took for the program
	// in the RISC-V core to complete executing. We stop incrementing it once
	// we detect TRIGGER_DATA.
	always@(posedge CLK) begin
		if(!nrst)
			clock_counter <= 0;
		else begin
			if((UARTState == RESET || UARTState == WAIT_SEND) && con_data != TRIGGER_DATA)
				clock_counter <= clock_counter + 1;
		end
	end

	// This sets con_addr to where UARTDUMP is mapped in the RISC-V core until
	// we detect TRIGGER_DATA. We start incrementing con_addr at CHECK_ANSKEY
	always@(posedge CLK) begin
		if(!nrst)
			con_addr <= 0;
		else begin
			if(UARTState == RESET)
				con_addr <= MAPPED_ADDR;
			else if(UARTState == WAIT_SEND && con_data == TRIGGER_DATA)
				con_addr <= 10'h0;
			else if(UARTState == CHECK_ANSKEY)
				con_addr <= con_addr + 1;
		end
	end
	
	// This counter holds the UART FSM in reset for 2ms. This
	// will complete transmission of any byte that may have been
	// initiated during FPGA configuration due to the UART_TX line being
	// pulled low, preventing a frame shift error from occuring
	// during the first message.
	always@(posedge CLK) begin
		if(!nrst)
			reset_ctr <= 0;
		else begin
			if(reset_ctr == RESET_CTR_MAX || UARTState != RESET)
				reset_ctr <= 18'h0;
			else
				reset_ctr <= reset_ctr + 1;
		end
	end

	// Next UART state logic (states described above)
	always@(posedge CLK) begin
		if(!nrst) begin
			UARTState <= RESET;
		end else begin
			case(UARTState)
				RESET: begin
					if(reset_ctr == RESET_CTR_MAX)
						UARTState <= WAIT_SEND;
				end
				WAIT_SEND: begin
					if(con_data == TRIGGER_DATA)
						UARTState <= LD_TESTPROGNAME;
				end

				LD_TESTPROGNAME: UARTState <= SEND_CHAR;
				SEND_CHAR: UARTState <= RDY_LOW;
				RDY_LOW: UARTState <= WAIT_RDY;
				WAIT_RDY: begin
					if(UARTReady == 1) begin
						if(strIndex < strLength)
							UARTState <= SEND_CHAR;
						else begin
							if(strLast == LD_TESTPROGNAME)
								UARTState <= LD_LINE1;
							else if(strLast == LD_LINE1)
								UARTState <= LD_LINE2;
							else if(strLast == LD_LINE2)
								UARTState <= LD_LINE3;
							else if(strLast == LD_LINE3)
								UARTState <= CHECK_ANSKEY;
							else if(strLast == LD_ANSWER && con_addr != 10'h3FF)
								UARTState <= CHECK_ANSKEY;
							else if(strLast == LD_ANSWER && con_addr == 10'h3FF)
								UARTState <= CHECK_RESULT;
							else if(strLast == LD_RESULT)
								UARTState <= LD_CLOCKCYCLES;
							else if(strLast == LD_CLOCKCYCLES)
								UARTState <= LD_ENDLINE;
							else if(strLast == LD_ENDLINE)
								UARTState <= DONE;
							else // Should never be reached
								UARTState <= RESET;
						end
					end
				end
				LD_LINE1: UARTState <= SEND_CHAR;
				LD_LINE2: UARTState <= SEND_CHAR;
				LD_LINE3: UARTState <= SEND_CHAR;
				CHECK_ANSKEY: UARTState <= LD_ANSWER;
				LD_ANSWER: UARTState <= SEND_CHAR;
				CHECK_RESULT: UARTState <= LD_RESULT;
				LD_RESULT: UARTState <= SEND_CHAR;
				LD_CLOCKCYCLES: UARTState <= SEND_CHAR;
				LD_ENDLINE: UARTState <= SEND_CHAR;
				DONE: UARTState <= DONE;
			endcase
		end
	end

	// Controls the contents of ANSWER_STR, RESULT_STR, and CLOCKCYCLES_STR
	// since they depend on the test cases.
	// Also note that since some parts are initially stored as integers,
	// we need to convert them to ASCII by using lookup tables.
	// Consequently, this would mean lots of really repetitive code, which is
	// why we use Verilog functions.
	function [7:0] hextoascii(
		input [3:0] hexdigit
	);
		begin
			case(hexdigit)
				4'h0: hextoascii = "0";
				4'h1: hextoascii = "1";
				4'h2: hextoascii = "2";
				4'h3: hextoascii = "3";
				4'h4: hextoascii = "4";
				4'h5: hextoascii = "5";
				4'h6: hextoascii = "6";
				4'h7: hextoascii = "7";
				4'h8: hextoascii = "8";
				4'h9: hextoascii = "9";
				4'ha: hextoascii = "a";
				4'hb: hextoascii = "b";
				4'hc: hextoascii = "c";
				4'hd: hextoascii = "d";
				4'he: hextoascii = "e";
				4'hf: hextoascii = "f";
			endcase
		end
	endfunction

	// We define CLOCKCYCLES_STR at LD_TESTPROGNAME since we stop incrementing
	// clock_counter at this state. We also do this since there is no
	// CHECK_CLOCKCYCLES state, unlike CHECK_ANSKEY or CHECK_RESULT.
	always@(posedge CLK) begin
		if(UARTState == CHECK_ANSKEY) begin
			ANSWER_STR[0] = "0";
			ANSWER_STR[1] = "x";
			ANSWER_STR[2] = hextoascii({2'h0, con_addr[9:8]});
			ANSWER_STR[3] = hextoascii(con_addr[7:4]);
			ANSWER_STR[4] = hextoascii(con_addr[3:0]);
			ANSWER_STR[5] = " ";
			ANSWER_STR[6] = " ";
			ANSWER_STR[7] = 8'h09;
			ANSWER_STR[8] = "0";
			ANSWER_STR[9] = "x";
			ANSWER_STR[10] = hextoascii(con_data[31:28]);
			ANSWER_STR[11] = hextoascii(con_data[27:24]);
			ANSWER_STR[12] = hextoascii(con_data[23:20]);
			ANSWER_STR[13] = hextoascii(con_data[19:16]);
			ANSWER_STR[14] = hextoascii(con_data[15:12]);
			ANSWER_STR[15] = hextoascii(con_data[11:8]);
			ANSWER_STR[16] = hextoascii(con_data[7:4]);
			ANSWER_STR[17] = hextoascii(con_data[3:0]);
			ANSWER_STR[18] = 8'h09;
			ANSWER_STR[19] = "0";
			ANSWER_STR[20] = "x";
			ANSWER_STR[21] = hextoascii(answerkey[con_addr][31:28]);
			ANSWER_STR[22] = hextoascii(answerkey[con_addr][27:24]);
			ANSWER_STR[23] = hextoascii(answerkey[con_addr][23:20]);
			ANSWER_STR[24] = hextoascii(answerkey[con_addr][19:16]);
			ANSWER_STR[25] = hextoascii(answerkey[con_addr][15:12]);
			ANSWER_STR[26] = hextoascii(answerkey[con_addr][11:8]);
			ANSWER_STR[27] = hextoascii(answerkey[con_addr][7:4]);
			ANSWER_STR[28] = hextoascii(answerkey[con_addr][3:0]);
			ANSWER_STR[29] = 8'h09;

			if(con_data == answerkey[con_addr]) begin
				ANSWER_STR[30] = "P";
				ANSWER_STR[31] = "a";
				ANSWER_STR[32] = "s";
				ANSWER_STR[33] = "s";
			end else begin
				ANSWER_STR[30] = "F";
				ANSWER_STR[31] = "a";
				ANSWER_STR[32] = "i";
				ANSWER_STR[33] = "l";
			end

			ANSWER_STR[34] = 8'h0D;
			ANSWER_STR[35] = 8'h0A;
		end

		if(UARTState == CHECK_RESULT) begin
			RESULT_STR[0] = 8'h0D;
			RESULT_STR[1] = 8'h0A;
			RESULT_STR[2] = "P";
			RESULT_STR[3] = "a";
			RESULT_STR[4] = "s";
			RESULT_STR[5] = "s";
			RESULT_STR[6] = "e";
			RESULT_STR[7] = "d";
			RESULT_STR[8] = ":";
			RESULT_STR[9] = " ";
			RESULT_STR[10] = "0";
			RESULT_STR[11] = "x";
			RESULT_STR[12] = hextoascii({2'h0, test_pass[9:8]});
			RESULT_STR[13] = hextoascii(test_pass[7:4]);
			RESULT_STR[14] = hextoascii(test_pass[3:0]);
			RESULT_STR[15] = "/";
			RESULT_STR[16] = "0";
			RESULT_STR[17] = "x";
			RESULT_STR[18] = hextoascii({2'h0, test_total[9:8]});
			RESULT_STR[19] = hextoascii(test_total[7:4]);
			RESULT_STR[20] = hextoascii(test_total[3:0]);
			RESULT_STR[21] = " ";
			RESULT_STR[22] = "t";
			RESULT_STR[23] = "e";
			RESULT_STR[24] = "s";
			RESULT_STR[25] = "t";
			RESULT_STR[26] = " ";
			RESULT_STR[27] = "c";
			RESULT_STR[28] = "a";
			RESULT_STR[29] = "s";
			RESULT_STR[30] = "e";
			RESULT_STR[31] = "s";
			RESULT_STR[32] = ".";
			RESULT_STR[33] = 8'h0D;
			RESULT_STR[34] = 8'h0A;
		end

		if(UARTState == LD_TESTPROGNAME) begin
			CLOCKCYCLES_STR[0] = "C";
			CLOCKCYCLES_STR[1] = "l";
			CLOCKCYCLES_STR[2] = "o";
			CLOCKCYCLES_STR[3] = "c";
			CLOCKCYCLES_STR[4] = "k";
			CLOCKCYCLES_STR[5] = " ";
			CLOCKCYCLES_STR[6] = "c";
			CLOCKCYCLES_STR[7] = "y";
			CLOCKCYCLES_STR[8] = "c";
			CLOCKCYCLES_STR[9] = "l";
			CLOCKCYCLES_STR[10] = "e";
			CLOCKCYCLES_STR[11] = "s";
			CLOCKCYCLES_STR[12] = ":";
			CLOCKCYCLES_STR[13] = " ";
			CLOCKCYCLES_STR[14] = "0";
			CLOCKCYCLES_STR[15] = "x";
			CLOCKCYCLES_STR[16] = hextoascii(clock_counter[31:28]);
			CLOCKCYCLES_STR[17] = hextoascii(clock_counter[27:24]);
			CLOCKCYCLES_STR[18] = hextoascii(clock_counter[23:20]);
			CLOCKCYCLES_STR[19] = hextoascii(clock_counter[19:16]);
			CLOCKCYCLES_STR[20] = hextoascii(clock_counter[15:12]);
			CLOCKCYCLES_STR[21] = hextoascii(clock_counter[11:8]);
			CLOCKCYCLES_STR[22] = hextoascii(clock_counter[7:4]);
			CLOCKCYCLES_STR[23] = hextoascii(clock_counter[3:0]);
			CLOCKCYCLES_STR[24] = 8'h0D;
			CLOCKCYCLES_STR[25] = 8'h0A;
		end
	end

	// Loads the sendStr, strLength, and strLast values when a 
	// LD state is reached.
	// Note that for Verilog, we cannot assign to 2d arrays directly
	// (sendStr <= TESTPROGNAME_STR for example). Hence, we have to use
	// for loops to assign values to each register in the array.
	always@(posedge CLK) begin
		if(!nrst) begin
			strLength <= 0;
			strLast <= 0;
		end else begin
			case(UARTState)
				LD_TESTPROGNAME: begin
					for(i = 0; i < TESTPROGNAME_STR_LEN; i = i+1) begin
						sendStr[i] <= TESTPROGNAME_STR[i];
					end
					strLength <= TESTPROGNAME_STR_LEN;
					strLast <= LD_TESTPROGNAME;
				end

				LD_LINE1: begin
					for(i = 0; i < LINE1_STR_LEN; i = i+1) begin
						sendStr[i] <= LINE1_STR[i];
					end
					strLength <= LINE1_STR_LEN;
					strLast <= LD_LINE1;
				end

				LD_LINE2: begin
					for(i = 0; i < LINE2_STR_LEN; i = i+1) begin
						sendStr[i] <= LINE2_STR[i];
					end
					strLength <= LINE2_STR_LEN;
					strLast <= LD_LINE2;
				end

				LD_LINE3: begin
					for(i = 0; i < LINE3_STR_LEN; i = i+1) begin
						sendStr[i] <= LINE3_STR[i];
					end
					strLength <= LINE3_STR_LEN;
					strLast <= LD_LINE3;
				end

				LD_ANSWER: begin
					for(i = 0; i < ANSWER_STR_LEN; i = i+1) begin
						sendStr[i] <= ANSWER_STR[i];
					end
					strLength <= ANSWER_STR_LEN;
					strLast <= LD_ANSWER;
				end

				LD_RESULT: begin
					for(i = 0; i < RESULT_STR_LEN; i = i+1) begin
						sendStr[i] <= RESULT_STR[i];
					end
					strLength <= RESULT_STR_LEN;
					strLast <= LD_RESULT;
				end

				LD_CLOCKCYCLES: begin
					for(i = 0; i < CLOCKCYCLES_STR_LEN; i = i+1) begin
						sendStr[i] <= CLOCKCYCLES_STR[i];
					end
					strLength <= CLOCKCYCLES_STR_LEN;
					strLast <= LD_CLOCKCYCLES;
				end

				LD_ENDLINE: begin
					for(i = 0; i < ENDLINE_STR_LEN; i = i+1) begin
						sendStr[i] <= ENDLINE_STR[i];
					end
					strLength <= ENDLINE_STR_LEN;
					strLast <= LD_ENDLINE;
				end
			endcase
		end
	end

	// Controls test_pass and test_total
	always@(posedge CLK) begin
		if(!nrst) begin
			test_pass <= 0;
			test_total <= 0;
		end else begin
			if(UARTState == CHECK_ANSKEY) begin
				if(con_data == answerkey[con_addr])
					test_pass <= test_pass + 1;
				test_total <= test_total + 1;
			end
		end
	end

	// Controls the strIndex signal so that it contains the index
	// of the next character that needs to be sent over UART.
	always@(posedge CLK) begin
		if(!nrst)
			strIndex <= 0;
		else begin
			if (UARTState == LD_TESTPROGNAME||
				UARTState == LD_LINE1		||
				UARTState == LD_LINE2		||
				UARTState == LD_LINE3		||
				UARTState == LD_ANSWER		||
				UARTState == LD_RESULT		||
				UARTState == LD_CLOCKCYCLES	||
				UARTState == LD_ENDLINE)

				strIndex <= 0;
			else if(UARTState == SEND_CHAR)
				strIndex <= strIndex + 1;
		end
	end

	// Controls the UART_TX.vhd control signals
	always@(posedge CLK) begin
		if(!nrst) begin
			UARTSend <= 1'b0;
		end else begin
			if(UARTState == SEND_CHAR) begin
				UARTSend <= 1'b1;
				UARTData <= sendStr[strIndex];
			end
			else begin
				UARTSend <= 1'b0;
			end
		end
	end
endmodule