`timescale 1ns / 1ps
module counter(clk,reset,counter_reset,counter_enable,counter_value);

input clk,reset,counter_reset,counter_enable;

output reg[31:0] counter_value;

	initial begin
		counter_value=32'h0000_0000;
	end
	
	always @(posedge clk)
		begin
		    if(counter_reset==1'b1)
			    counter_value<=32'h0000_0000; 
			else if(counter_enable==1'b1)
				counter_value<=counter_value + 32'h0000_0001;
			else
				counter_value<=counter_value;
		end

endmodule