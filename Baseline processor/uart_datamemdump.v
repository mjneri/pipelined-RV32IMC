`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2020 10:18:14 AM
// Design Name: 
// Module Name: UART_USB_CTRL
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


module uart_datamemdump(
	input CLK,
	input nrst,
	input [31:0] con_data,
	
	output reg [9:0] con_addr,
	output TX
);
	reg send;
	wire ready;
	reg [3:0] offset;
	reg [1:0] txState, txNstate;
	(* dont_touch = "yes" *) reg [7:0] byte_data;
	
	UART_TX UART_TX(
		.SEND(send),
		.DATA(byte_data),
		.CLK(CLK),
		.READY(ready),
		.TX(TX)
	);
	
	parameter READY = 2'h0;
	parameter SEND_DM = 2'h1;
	parameter LOAD_BYTE = 2'h2;
	parameter SEND_BYTE = 2'h3;
	
	// ASCII
	parameter Asc0 = 8'h30;
	parameter Asc1 = 8'h31;
	parameter Asc2 = 8'h32;
	parameter Asc3 = 8'h33;
	parameter Asc4 = 8'h34;
	parameter Asc5 = 8'h35;
	parameter Asc6 = 8'h36;
	parameter Asc7 = 8'h37;
	parameter Asc8 = 8'h38;
	parameter Asc9 = 8'h39;
	parameter AscA = 8'h41;
	parameter AscB = 8'h42;
	parameter AscC = 8'h43;
	parameter AscD = 8'h44;
	parameter AscE = 8'h45;
	parameter AscF = 8'h46;
	parameter AscNL = 8'h0A;
	parameter AscBR = 8'h0D; 
	
	// Next state logic
	always@(*) begin
		case(txState)
			READY:
				begin
					if(con_data == 32'hade1b055)
						txNstate = SEND_DM;
					else
						txNstate = READY;				
				end
			SEND_DM: txNstate = LOAD_BYTE;
			LOAD_BYTE: txNstate = SEND_BYTE;
			SEND_BYTE:
				if(ready == 1'h1) begin
					if(offset == 4'ha)
						if(con_addr == 10'h3FF)
							txNstate = READY;
						else
							txNstate = SEND_DM;						
					else
						txNstate = LOAD_BYTE;
				end else 
					txNstate = SEND_BYTE;
			default: txNstate = READY;	// Should never be reached
		endcase
	end
	
	// State transition
	always@(posedge CLK) begin
		if(!nrst) begin
			txState <= READY;
		end else begin
			txState <= txNstate;
		end
	end
	
	// Input to UART_TX logic
	always@(posedge CLK) begin
		if(!nrst)
			offset <= 0;
		else
			case(txState)
				LOAD_BYTE: offset <= offset + 4'b1;
				SEND_DM: offset <= 4'h0;
			endcase
	end
	
	always@(*) begin
		case(txState)
			LOAD_BYTE:
				begin
					case(offset)
						4'h9: byte_data = AscNL;
						4'h8: byte_data = AscBR;
						
						4'h7:
							begin
								case(con_data[3:0])
									4'h0: byte_data = Asc0;
									4'h1: byte_data = Asc1;
									4'h2: byte_data = Asc2;
									4'h3: byte_data = Asc3;
									4'h4: byte_data = Asc4;
									4'h5: byte_data = Asc5;
									4'h6: byte_data = Asc6;
									4'h7: byte_data = Asc7;
									4'h8: byte_data = Asc8;
									4'h9: byte_data = Asc9;
									4'ha: byte_data = AscA;
									4'hb: byte_data = AscB;
									4'hc: byte_data = AscC;
									4'hd: byte_data = AscD;
									4'he: byte_data = AscE;
									4'hf: byte_data = AscF;
								endcase
							end
						4'h6:
							begin
								case(con_data[7:4])
									4'h0: byte_data = Asc0;
									4'h1: byte_data = Asc1;
									4'h2: byte_data = Asc2;
									4'h3: byte_data = Asc3;
									4'h4: byte_data = Asc4;
									4'h5: byte_data = Asc5;
									4'h6: byte_data = Asc6;
									4'h7: byte_data = Asc7;
									4'h8: byte_data = Asc8;
									4'h9: byte_data = Asc9;
									4'ha: byte_data = AscA;
									4'hb: byte_data = AscB;
									4'hc: byte_data = AscC;
									4'hd: byte_data = AscD;
									4'he: byte_data = AscE;
									4'hf: byte_data = AscF;
								endcase
							end
						4'h5:
							begin
								case(con_data[11:8])
									4'h0: byte_data = Asc0;
									4'h1: byte_data = Asc1;
									4'h2: byte_data = Asc2;
									4'h3: byte_data = Asc3;
									4'h4: byte_data = Asc4;
									4'h5: byte_data = Asc5;
									4'h6: byte_data = Asc6;
									4'h7: byte_data = Asc7;
									4'h8: byte_data = Asc8;
									4'h9: byte_data = Asc9;
									4'ha: byte_data = AscA;
									4'hb: byte_data = AscB;
									4'hc: byte_data = AscC;
									4'hd: byte_data = AscD;
									4'he: byte_data = AscE;
									4'hf: byte_data = AscF;
								endcase
							end
						4'h4:
							begin
								case(con_data[15:12])
									4'h0: byte_data = Asc0;
									4'h1: byte_data = Asc1;
									4'h2: byte_data = Asc2;
									4'h3: byte_data = Asc3;
									4'h4: byte_data = Asc4;
									4'h5: byte_data = Asc5;
									4'h6: byte_data = Asc6;
									4'h7: byte_data = Asc7;
									4'h8: byte_data = Asc8;
									4'h9: byte_data = Asc9;
									4'ha: byte_data = AscA;
									4'hb: byte_data = AscB;
									4'hc: byte_data = AscC;
									4'hd: byte_data = AscD;
									4'he: byte_data = AscE;
									4'hf: byte_data = AscF;
								endcase
							end
						4'h3:
							begin
								case(con_data[19:16])
									4'h0: byte_data = Asc0;
									4'h1: byte_data = Asc1;
									4'h2: byte_data = Asc2;
									4'h3: byte_data = Asc3;
									4'h4: byte_data = Asc4;
									4'h5: byte_data = Asc5;
									4'h6: byte_data = Asc6;
									4'h7: byte_data = Asc7;
									4'h8: byte_data = Asc8;
									4'h9: byte_data = Asc9;
									4'ha: byte_data = AscA;
									4'hb: byte_data = AscB;
									4'hc: byte_data = AscC;
									4'hd: byte_data = AscD;
									4'he: byte_data = AscE;
									4'hf: byte_data = AscF;
								endcase
							end
						4'h2:
							begin
								case(con_data[23:20])
									4'h0: byte_data = Asc0;
									4'h1: byte_data = Asc1;
									4'h2: byte_data = Asc2;
									4'h3: byte_data = Asc3;
									4'h4: byte_data = Asc4;
									4'h5: byte_data = Asc5;
									4'h6: byte_data = Asc6;
									4'h7: byte_data = Asc7;
									4'h8: byte_data = Asc8;
									4'h9: byte_data = Asc9;
									4'ha: byte_data = AscA;
									4'hb: byte_data = AscB;
									4'hc: byte_data = AscC;
									4'hd: byte_data = AscD;
									4'he: byte_data = AscE;
									4'hf: byte_data = AscF;
								endcase
							end
						4'h1:
							begin
								case(con_data[27:24])
									4'h0: byte_data = Asc0;
									4'h1: byte_data = Asc1;
									4'h2: byte_data = Asc2;
									4'h3: byte_data = Asc3;
									4'h4: byte_data = Asc4;
									4'h5: byte_data = Asc5;
									4'h6: byte_data = Asc6;
									4'h7: byte_data = Asc7;
									4'h8: byte_data = Asc8;
									4'h9: byte_data = Asc9;
									4'ha: byte_data = AscA;
									4'hb: byte_data = AscB;
									4'hc: byte_data = AscC;
									4'hd: byte_data = AscD;
									4'he: byte_data = AscE;
									4'hf: byte_data = AscF;
								endcase
							end
						4'h0:
							begin
								case(con_data[31:28])
									4'h0: byte_data = Asc0;
									4'h1: byte_data = Asc1;
									4'h2: byte_data = Asc2;
									4'h3: byte_data = Asc3;
									4'h4: byte_data = Asc4;
									4'h5: byte_data = Asc5;
									4'h6: byte_data = Asc6;
									4'h7: byte_data = Asc7;
									4'h8: byte_data = Asc8;
									4'h9: byte_data = Asc9;
									4'ha: byte_data = AscA;
									4'hb: byte_data = AscB;
									4'hc: byte_data = AscC;
									4'hd: byte_data = AscD;
									4'he: byte_data = AscE;
									4'hf: byte_data = AscF;
								endcase
							end
						default: byte_data = 8'h0;
					endcase
					
					send = 1'b1;
				end
			SEND_BYTE: 
				begin
					send = 1'b0;
					byte_data = 8'h0;
				end
			default: 
				begin
					send = 1'b0;
					byte_data = 8'h0;
				end
		endcase
	end
	
	// Output Logic
	always@(posedge CLK) begin
		if(!nrst)
			con_addr <= 10'h0;
		else begin
			case(txState)
				READY: con_addr <= 10'h3FF;
				SEND_DM: con_addr <= con_addr + 10'h1;
			endcase
		end
	end
endmodule
