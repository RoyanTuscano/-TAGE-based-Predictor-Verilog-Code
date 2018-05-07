`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2017 11:58:16 AM
// Design Name: 
// Module Name: PerceptronTable
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


module 	Bimodal_Table(Clk, reset,wr, rd, index/*pc*/, rdata_c_bits, correct_prediction, inc_counter, dec_counter,update_enable);
   
	parameter IL=10;	//Index size ie number of addresses
	parameter CL=3;		//Counter length

	reg [ CL-1 : 0 ] c_bits[(1 << IL) - 1 : 0];		//Counter table
	
	output [ CL-1 : 0 ] rdata_c_bits;
	reg [ CL-1 : 0 ] rdata_c_bits_reg;
	input [IL - 1 : 0]index;
	input Clk,rd,wr,reset;
    input correct_prediction;
	input inc_counter;
	input dec_counter;
	input update_enable;

    integer i, j;
   
    initial
    begin
		rdata_c_bits_reg<={CL{1'b0}};
      for (i = 0; i < (1<<IL); i = i+1)
			begin	
				c_bits[i] = {CL{1'b0}};		//initialize the bits
			end
	end
   
   // Keep addr and write data
   
  always @(posedge Clk)
	begin
		    if (inc_counter==1'b1 && update_enable==1'b1 && c_bits[index]!= {CL{1'b1}})
				begin
						c_bits[index]<=c_bits[index] + 1'b1;
				end
			else if(dec_counter==1'b1 && update_enable==1'b1 && c_bits[index]!= {CL{1'b0}})
				begin	
						c_bits[index]<=c_bits[index] - 1'b1;
				end
			else
				begin
						c_bits[index]<=c_bits[index];
				end
					
	end


  //
  // Read process
  // ------------


  always @(posedge Clk)
	begin
		if(reset==1'b0)
			rdata_c_bits_reg <= {CL{1'b0}};
		if (rd==1'b1)
			begin
				rdata_c_bits_reg <= c_bits[index];
			end
		else
			begin
				rdata_c_bits_reg <= {CL{1'b0}};
			end
	end
		
  assign rdata_c_bits = rdata_c_bits_reg;
	
endmodule

 /*
  always @(posedge clk)
	begin
		    if (wr && correct_prediction)
				begin
				
					if(branch_taken || c_bits[index] !=3'b111)
						c_bits[index]<=c_bits[index] + 1;
					else if(~branch_taken || c_bits[index] !=3'b000)
						c_bits[index]<=c_bits[index] - 1;
					else
						c_bits[index]<=c_bits[index];
						
				end
			else if(wr && ~correct_prediction)
				begin	
			
					if(branch_taken || c_bits[index] !=3'b000)		//branch_taken is predicted but since its wrong we decrement the c bit
						c_bits[index]<=c_bits[index] - 1'b1;
					else if(~branch_taken || c_bits[index] !=3'b111)	//branch not taken is predicted but since its wrong we increment the c bit
						c_bits[index]<=c_bits[index] + 1'b1;
					else
						c_bits[index]<=c_bits[index];
					
				end
					
	end

	*/