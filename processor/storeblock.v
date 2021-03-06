//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// storeblock.v -- Store data module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: storeblock.v
// Description: Generates the data to be stored in the data memory
//				based on the store instruction used. The dm_write write enable
//				signal is also generated
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

module storeblock(
    input [31:0] opB,
    input [1:0] byte_offset,
    input [1:0] store_select,
    input is_stype,
    output [31:0] data,
    output reg [3:0] dm_write
    );
    
    parameter sw = 2'd2;
    parameter sh = 2'd1;
    parameter sb = 2'd0;
    
    wire [31:0] nboff_data;
    
    assign nboff_data = (store_select == sb) ? {24'd0 , opB[7:0]} : (store_select == sh) ? {16'd0, opB[15:0]} : opB ;
    assign data = nboff_data << (8*byte_offset);

	always@(*) begin
		case(store_select)
			sb:
				case({is_stype, byte_offset})
					3'b100: dm_write <= 4'b0001;
					3'b101: dm_write <= 4'b0010;
					3'b110: dm_write <= 4'b0100;
					3'b111: dm_write <= 4'b1000;
					default: dm_write <= 4'b0000;
				endcase
			sh:
				case({is_stype, byte_offset})
					3'b100: dm_write <= 4'b0011;
					3'b110: dm_write <= 4'b1100;
					default: dm_write <= 4'b0000;
				endcase
			sw:
				case({is_stype, byte_offset})
					3'b100: dm_write <= 4'b1111;
					default: dm_write <= 4'b0000;
				endcase

			default: dm_write <= 4'b0000;
		endcase
	end
endmodule
