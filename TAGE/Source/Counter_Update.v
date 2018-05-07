`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2017 03:21:16 PM
// Design Name: 
// Module Name: Comparator
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


module Counter_Update(Branch_Predicited,Inc_counter, dec_counter );

input Branch_Predicited;
output Inc_counter,dec_counter;

initial begin
		Inc_counter=1'b0;
		dec_counter=1'b0;
	end

always @(Branch_Predicited)
	begin 
		if(Branch_Predicited==1'b1)			//correct prediction that it is taken
			begin
				inc_counter <= 1'b1;
				dec_counter <= 1'b0;
			end
		else
			begin
				inc_counter <= 1'b0;
				dec_counter <= 1'b1;
			end
	end
	
  
endmodule


















