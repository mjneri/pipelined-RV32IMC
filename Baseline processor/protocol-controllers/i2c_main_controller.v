`timescale 1ns / 1ps

//Credits to USB-C

module i2c_main_controller(
		input clk,
		input nrst,
		
		//Control Signal Output
		output wire done,
		output wire busy,
		output reg nack,
		
		//From Data MEMORY
		input wire [31:0] memory_control,
		input wire [31:0] memory_data,

		/*
		* I2C master interface
		*/
		output	reg  [2:0] wbm_adr_o,   // ADR_I() address to i2cmaster
		output	reg  [7:0] wbm_dat_o,   // DAT_I() data in to i2cmaster
		input		wire [7:0] wbm_dat_i,   // DAT_O() data out from i2cmaster
		output	reg        wbm_we_o,    // WE_I write enable to i2cmaster
		output	reg        wbm_stb_o,   // STB_I strobe to i2cmaster
		input		wire       wbm_ack_i,   // ACK_O acknowledge from i2cmaster
		output	reg        wbm_cyc_o   // CYC_I cycle to i2cmaster
		);
	
	/*
	DATA MEMORY SIGNALS
	
	memory_control[31:0]- [0] 		- CMD START
						- [1] 		- CMD READ
						- [2] 		- CMD WRITE
						- [3] 		- SET PRESCALE
						- [10:4] 	- SLAVE ADDRESS
						- [14:11]	- NO. OF BITS TO BE SENT
						- [15]		- UNUSED
						- [31:16]	- PRESCALE VALUE
	
	memory_data[31:0]	-	DATA TO BE SENT
	*/

	//I2C State Parameters
	parameter [7*8:0] 	I2C_STATE_IDLE = "___IDLE",
						I2C_STATE_READ = "___READ",
						I2C_STATE_WRITE = "__WRITE",
						I2C_STATE_PRESCALE = "_PRESCL",
						I2C_STATE_DONE = "___DONE";
	
	parameter [4*8:0]	R0 = "_R00",
						R1 = "_R01",
						R2 = "_R02",
						R3 = "_R03",
						R4 = "_R04",
						R5 = "_R05",
						R6 = "_R06",
						R7 = "_R07",
						R8 = "_R08",
						RX = "_RXX",
						
						W0 = "_W00",
						W1 = "_W01",
						W2 = "_W02",
						W3 = "_W03",
						W4 = "_W04",
						W5 = "_W05",
						W6 = "_W06",
						W7 = "_W07",
						W8 = "_W08",
						WX = "_WXX",
						
						P0 = "_P00",
						P1 = "_P01",
						P2 = "_P02";

	//I2C registers
	reg [31:0] buffer_data;
	reg [8*7:1] i2c_state;	
	reg [8*4:1] i2c_substate_count;
	reg [3:0] i2c_data_length; // in terms of how many 8-bit packets there are (data_length * 8 = actual number of bits)
	reg [3:0] i2c_data_length_counter;
	reg [3:0] i2c_data_sent_counter; //how many bytes has the I2C module sent already
	
	reg [15:0] i2c_prescale; // 16-bit prescale value
	reg [6:0] i2c_addr; // 7-bit i2c addresses

    assign done = (i2c_state == I2C_STATE_DONE);
    assign busy = ((i2c_state == I2C_STATE_READ) || (i2c_state == I2C_STATE_WRITE));
    
	// Initializing registers
	initial begin
		wbm_adr_o <= 3'd0;
		wbm_dat_o <= 8'd0;
		wbm_we_o <= 1'b0;
		wbm_stb_o <= 1'b0;
		wbm_cyc_o <= 1'b0;
		
		i2c_state <= I2C_STATE_IDLE;
		i2c_substate_count <= "_I00";
		i2c_data_length <= 4'd1;
		i2c_data_length_counter <= 4'd0;
		i2c_data_sent_counter <= 4'd0;
		
		i2c_prescale <= 16'd0;// = 75; 60 MHz / (4 * 200 kHz); Fclk = 60 MHz, Fi2c = 200 kHz
		buffer_data <= 16'b0;
		i2c_addr <= 7'd0;

		nack <= 0;
	end

	always@(posedge clk) begin
		if (!nrst) begin

			wbm_adr_o <= 3'd0;
			wbm_dat_o <= 8'd0;
			wbm_we_o <= 1'b0;
			wbm_stb_o <= 1'b0;
			wbm_cyc_o <= 1'b0;
			
			i2c_state <= I2C_STATE_IDLE;
			i2c_substate_count <= "_I00";
			i2c_data_length <= 4'd1;
			i2c_data_length_counter <= 4'd0;
			i2c_data_sent_counter <= 4'd0;
			
			i2c_prescale <= 16'd0;// = 75; 60 MHz / (4 * 200 kHz); Fclk = 60 MHz, Fi2c = 200 kHz
			buffer_data <= 16'b0;
			i2c_addr <= 7'd0;

			nack <= 0;
		end
		else begin
			

			if ( (i2c_state == I2C_STATE_IDLE) ) begin //state while waiting for valid command from user host
				// check if CMD START = 1
				if (memory_control[0] == 1'b1) begin
					//check if valid command present
					if (memory_control[1] == 1'b1) begin //If CMD READ = 1
						i2c_state <= I2C_STATE_READ;
						i2c_data_length <= memory_control[14:11]; //8bits data
						i2c_substate_count <= R0;
						nack <= 0;
					end
					else if (memory_control[2] == 1'b1) begin // If WRITE = 1
						i2c_state <= I2C_STATE_WRITE;
						i2c_data_length <= memory_control[14:11]; //8bits data
						i2c_substate_count <= W0;
						nack <= 0;
					end
					else if (memory_control[3] == 1'b1) begin //If SET_PRESCALE = 1
						i2c_state <= I2C_STATE_PRESCALE;
						i2c_data_length <= memory_control[14:11]; //8bits data
						i2c_prescale <= memory_control[31:16]; //16'd125;//16'd2500;
						i2c_substate_count <= P0;
						nack <= 0;
					end
				end
			end
			
			else if (i2c_state == I2C_STATE_READ) begin
				if (i2c_substate_count == R0) begin
					//wait for i2c_address
					i2c_addr <= memory_control[10:4];
					i2c_substate_count <= R1;
					
				end
				else if (i2c_substate_count == R1) begin
					//set cmd address
					wbm_adr_o <= 3'd2;
					wbm_dat_o <= {1'b0, i2c_addr};
					wbm_we_o <= 1'b1;
					wbm_stb_o <= 1'b1;
					wbm_cyc_o <= 1'b1;
					
					i2c_substate_count <= R2;
				end
				else if (i2c_substate_count == R2) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//set read cmd bit, starting read i2c transaction
						wbm_adr_o <= 3'd3;
						wbm_dat_o <= 8'b00000011; //set cmd_read and cmd_start to high
						wbm_we_o <= 1'b1;
						wbm_stb_o <= 1'b1;
						wbm_cyc_o <= 1'b1;
						
						i2c_substate_count <= R3;
					end
				end
				else if (i2c_substate_count == R3) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//start tracking number of busy signal changes, request for busy signal
						//start tracking of missed acks as well
						wbm_adr_o <= 3'd0;
						wbm_we_o <= 1'b0; //read operation
						wbm_stb_o <= 1'b1;
						wbm_cyc_o <= 1'b1;
						
						i2c_substate_count <= R4;
					end
				end
				else if (i2c_substate_count == R4) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//check busy signal if high or low
						if (wbm_dat_i[0] == 1'b0) begin //busy has not yet gone high, wait for it
							if (wbm_dat_i[3] == 1'b1) begin //no acknowledge received, stop i2c operation
								//send stop command (can only be done while module is not busy), then go back to I2C_STATE_IDLE
								wbm_adr_o <= 3'd3;
								wbm_dat_o <= 8'b00010000; //set cmd_stop
								wbm_we_o <= 1'b1;
								wbm_stb_o <= 1'b1;
								wbm_cyc_o <= 1'b1;
							
								i2c_substate_count <= RX;
							end
							else begin
								wbm_adr_o <= 3'd0;
								wbm_we_o <= 1'b0; //read operation
								wbm_stb_o <= 1'b1;
								wbm_cyc_o <= 1'b1;
							end
						end
						else begin //busy has gone high, wait for it to go low
							wbm_adr_o <= 3'd0;
							wbm_we_o <= 1'b0; //read operation
							wbm_stb_o <= 1'b1;
							wbm_cyc_o <= 1'b1;
							
							i2c_data_sent_counter <= i2c_data_sent_counter + 4'd1; //another data sent by the slave				
							i2c_substate_count <= R5;
							
						end
					end
				end
				else if (i2c_substate_count == R5) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						if (wbm_dat_i[0] == 1'b0) begin //busy has now gone low
							if (wbm_dat_i[3] == 1'b1) begin //no acknowledge received, stop i2c operation
								//send stop command (can only be done while module is not busy), then go back to I2C_STATE_IDLE
								wbm_adr_o <= 3'd3;
								wbm_dat_o <= 8'b00010000; //set cmd_stop
								wbm_we_o <= 1'b1;
								wbm_stb_o <= 1'b1;
								wbm_cyc_o <= 1'b1;
							
								i2c_substate_count <= RX;
							end
							else begin
								if (i2c_data_sent_counter == i2c_data_length) begin //all bytes received by the I2C module, send stop command
									//Note: busy signal does not deassert after sending address, only data bytes
									wbm_adr_o <= 3'd3; 
									wbm_dat_o <= 8'b00010000; //set cmd_stop
									wbm_we_o <= 1'b1;
									wbm_stb_o <= 1'b1;
									wbm_cyc_o <= 1'b1;
								
									i2c_substate_count <= R6;
								end
								else begin //not all bytes sent yet, restart read, keep tracking number of sent bytes
									wbm_adr_o <= 3'd3;
									wbm_dat_o <= 8'b00000010; //set cmd_read
									wbm_we_o <= 1'b1;
									wbm_stb_o <= 1'b1;
									wbm_cyc_o <= 1'b1;
									
									i2c_substate_count <= R4;
								end
							end
						end
						else begin //busy has not yet returned to low, wait for it again
							wbm_adr_o <= 3'd0;
							wbm_we_o <= 1'b0; //read operation
							wbm_stb_o <= 1'b1;
							wbm_cyc_o <= 1'b1;
							
					
						end
					end
				end
				else if (i2c_substate_count == R6) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//start reading from READ FIFO
						wbm_adr_o <= 3'd4;
						wbm_we_o <= 1'b0; //read operation
						wbm_stb_o <= 1'b1;
						wbm_cyc_o <= 1'b1;
						
						i2c_data_length_counter <= i2c_data_length_counter + 4'd1;
						
						i2c_substate_count <= R7;
					end
				end
				else if (i2c_substate_count == R7) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//check number of bytes sent
						if ( i2c_data_length_counter == i2c_data_length ) begin //stop reading
						
							
							//reset wishbone signals
							wbm_adr_o <= 3'd0;
							wbm_dat_o <= 8'b00000000;
							wbm_we_o <= 1'b0;
							wbm_stb_o <= 1'b0;
							wbm_cyc_o <= 1'b0;
							
							
							i2c_substate_count <= R8;
						end 
						else begin //read again and wait for data
							wbm_adr_o <= 3'd4;
							wbm_we_o <= 1'b0; //read operation
							wbm_stb_o <= 1'b1;
							wbm_cyc_o <= 1'b1;
							
							i2c_data_length_counter <= i2c_data_length_counter + 4'd1;
						end
					end
				end
				else if ( i2c_substate_count == R8 ) begin
					//reset values
					i2c_data_length <= 4'd1;
					i2c_data_length_counter <= 4'd0;
					i2c_data_sent_counter <= 4'd0;
					i2c_state <= I2C_STATE_DONE;
					nack <= 0;
				end
				else if( i2c_substate_count == RX ) begin
					//reset values
					i2c_data_length <= 4'd1;
					i2c_data_length_counter <= 4'd0;
					i2c_data_sent_counter <= 4'd0;
					i2c_state <= I2C_STATE_DONE;
					nack <= 1;
				end
			end
			
			else if (i2c_state == I2C_STATE_WRITE) begin
				if (i2c_substate_count == W0) begin
					i2c_substate_count <= W1;
					
				end
				else if (i2c_substate_count == W1) begin
					buffer_data	<= memory_data[31:0];
					i2c_substate_count <= W2;
					
				end
				else if (i2c_substate_count == W2) begin
					//wait for i2c address
					i2c_addr <= memory_control[10:4];
					i2c_substate_count <= W3;
					
				end
				else if (i2c_substate_count == W3) begin
					//set cmd address
					wbm_adr_o <= 3'd2;
					wbm_dat_o <= {1'b0, i2c_addr};
					wbm_we_o <= 1'b1;
					wbm_stb_o <= 1'b1;
					wbm_cyc_o <= 1'b1;
					
					i2c_substate_count <= W4;
				end
				else if (i2c_substate_count == W4) begin //set all data to be sent to write FIFO
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						if (i2c_data_length_counter == i2c_data_length) begin //all bytes sent
							//start write
							wbm_adr_o <= 3'd3;
							wbm_dat_o <= 8'b00000101; //cmd_write and cmd_start high
							wbm_we_o <= 1'b1;
							wbm_stb_o <= 1'b1;
							wbm_cyc_o <= 1'b1;
							
							i2c_substate_count <= W5;
						end
						else begin //not all bytes sent yet
							//set data to write
							wbm_adr_o <= 3'd4;
							wbm_dat_o <= buffer_data[7:0];
							wbm_we_o <= 1'b1;
							wbm_stb_o <= 1'b1;
							wbm_cyc_o <= 1'b1;
							
							buffer_data <= {8'h00, buffer_data[31:24],buffer_data[23:16], buffer_data[15:8]}; //shift new byte to send if present
							i2c_data_length_counter <= i2c_data_length_counter + 4'd1;
						end
					end
				end
				else if (i2c_substate_count == W5) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//start tracking busy signal and miss_ack
						wbm_adr_o <= 3'd0;
						wbm_we_o <= 1'b0; //read operation
						wbm_stb_o <= 1'b1;
						wbm_cyc_o <= 1'b1;
						
						i2c_substate_count <= W6;
					end
				end
				else if (i2c_substate_count == W6) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//check busy signal if high or low
						if (wbm_dat_i[0] == 1'b0) begin //busy has not yet gone high, wait for it
							if (wbm_dat_i[3] == 1'b1) begin //no acknowledge received, stop i2c operation
								
								
								//send stop command (can only be done while module is not busy), then go back to I2C_STATE_IDLE
								wbm_adr_o <= 3'd3;
								wbm_dat_o <= 8'b00010000; //set cmd_stop
								wbm_we_o <= 1'b1;
								wbm_stb_o <= 1'b1;
								wbm_cyc_o <= 1'b1;
							
								i2c_substate_count <= WX;
							end
							else begin //keep waiting for busy to go high
								wbm_adr_o <= 3'd0;
								wbm_we_o <= 1'b0; //read operation
								wbm_stb_o <= 1'b1;
								wbm_cyc_o <= 1'b1;
							end
						end
						else begin //busy has gone high, wait for it to go low
							wbm_adr_o <= 3'd0;
							wbm_we_o <= 1'b0; //read operation
							wbm_stb_o <= 1'b1;
							wbm_cyc_o <= 1'b1;
							
							i2c_data_sent_counter <= i2c_data_sent_counter + 4'd1; //another data currently being sent
							i2c_substate_count <= W7;
						end
					end
				end
				else if (i2c_substate_count == W7) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						if (wbm_dat_i[0] == 1'b0) begin //busy has now gone low
							if (wbm_dat_i[3] == 1'b1) begin //no acknowledge received, stop i2c operation
								//send stop command (can only be done while module is not busy), then go back to I2C_STATE_IDLE
								wbm_adr_o <= 3'd3;
								wbm_dat_o <= 8'b00010000; //set cmd_stop
								wbm_we_o <= 1'b1;
								wbm_stb_o <= 1'b1;
								wbm_cyc_o <= 1'b1;
							
								i2c_substate_count <= WX;
							end
							else if (i2c_data_sent_counter == i2c_data_length) begin //all bytes sent by the I2C module, send stop command
								wbm_adr_o <= 3'd3;
								wbm_dat_o <= 8'b00010000; //set cmd_stop
								wbm_we_o <= 1'b1;
								wbm_stb_o <= 1'b1;
								wbm_cyc_o <= 1'b1;
							
								i2c_substate_count <= W8;
							end
							else begin //not all bytes sent yet, restart write, keep tracking number of sent bytes
								wbm_adr_o <= 3'd3;
								wbm_dat_o <= 8'b00000100; //set cmd_start
								wbm_we_o <= 1'b1;
								wbm_stb_o <= 1'b1;
								wbm_cyc_o <= 1'b1;
								
								i2c_substate_count <= W5;
							end
						end
						else begin //busy has not yet returned to low, wait for it again
							wbm_adr_o <= 3'd0;
							wbm_we_o <= 1'b0; //read operation
							wbm_stb_o <= 1'b1;
							wbm_cyc_o <= 1'b1;
						end
					end
				end
				else if (i2c_substate_count == W8) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//reset values
						wbm_adr_o <= 3'd0;
						wbm_dat_o <= 8'd0;
						wbm_we_o <= 1'b0;
						wbm_stb_o <= 1'b0;
						wbm_cyc_o <= 1'b0;
						
						i2c_data_length <= 4'd1;
						i2c_data_length_counter <= 4'd0;
						i2c_data_sent_counter <= 4'd0;
						i2c_substate_count <= "_I00";
						i2c_state <= I2C_STATE_DONE;
						nack <= 0;
					end
				end
				else if (i2c_substate_count == WX) begin
					if (wbm_ack_i == 1'b0) begin
						wbm_stb_o <= 1'b0;
					end
					else begin
						//reset values
						wbm_adr_o <= 3'd0;
						wbm_dat_o <= 8'd0;
						wbm_we_o <= 1'b0;
						wbm_stb_o <= 1'b0;
						wbm_cyc_o <= 1'b0;
						
						i2c_data_length <= 4'd1;
						i2c_data_length_counter <= 4'd0;
						i2c_data_sent_counter <= 4'd0;
						i2c_substate_count <= "_I00";
						i2c_state <= I2C_STATE_DONE;
						nack <= 1;
					end
				end
			end
			
			else if (i2c_state == I2C_STATE_PRESCALE) begin //state to initialize i2c master module
				if (i2c_substate_count == P0) begin
					//set Prescale Low
					wbm_adr_o <= 3'd6;
					wbm_dat_o <= i2c_prescale[7:0];
					wbm_we_o <= 1'b1;
					wbm_stb_o <= 1'b1;
					wbm_cyc_o <= 1'b1;
					
					i2c_substate_count <= P1;
				end
				else if (i2c_substate_count == P1) begin
					//set Prescale High
					wbm_adr_o <= 3'd7;
					wbm_dat_o <= i2c_prescale[15:8];
					wbm_we_o <= 1'b1;
					wbm_stb_o <= 1'b1;
					wbm_cyc_o <= 1'b1;
					
					i2c_substate_count <= P2;
				end
				else if (i2c_substate_count == P2) begin
					//reset outputs
					wbm_we_o <= 1'b0;
					wbm_stb_o <= 1'b0;
					wbm_cyc_o <= 1'b0;
					i2c_state <= I2C_STATE_IDLE;
				end
			end

			else if (i2c_state == I2C_STATE_DONE) // go back to I2C_STATE_IDLE
				i2c_state <= I2C_STATE_IDLE;
		end
	end


endmodule
