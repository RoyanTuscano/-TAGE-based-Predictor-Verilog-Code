`timescale 1ns / 1ps
//This module is to update the Histroy of global register

module update_history(CLK,reset,ghist,phist,pc,Actual_branch,update_history_enable);
parameter GlobLen=131;	//This is the global history length
parameter PLen=16 ;		//this is length of path History
parameter pc_len=32;

input CLK,reset;
input[pc_len-1 : 0] pc;
input Actual_branch;
input update_history_enable;
output reg[GlobLen-1:0] ghist;
output reg[PLen-1:0]  phist;

initial begin
	ghist<={GlobLen{1'b0}};
	phist<={PLen{1'b0}};
end

always @(posedge CLK) begin
	if(reset==1'b0)begin
		ghist<={GlobLen{1'b0}};
		phist<={PLen{1'b0}};
	end
	else if(update_history_enable==1'b1)begin
		ghist<={ghist[GlobLen-2:0],Actual_branch};
		phist<={phist[PLen-1],pc[0]};
	end
	else begin
		ghist<=ghist;
		phist<=phist;
		end
end


endmodule
