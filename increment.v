`timescale 1ns / 1ps

module increment(clk,reset,addr_reset,addr_out,enable);

parameter size=16;
parameter size1=size-1;
input clk,reset,enable,addr_reset;
output reg [size-1:0] addr_out;

	initial begin
		addr_out<={size{1'b0}};
		
	end
	
	always @(posedge clk)
		begin
			if(reset==1'b0)
				addr_out<={size{1'b0}};
			else if(addr_reset==1'b1)
			     addr_out<={size{1'b0}};
			else if(enable==1'b1)
				addr_out<=addr_out + 16'h0001;
			else
				addr_out<=addr_out;
		end

endmodule