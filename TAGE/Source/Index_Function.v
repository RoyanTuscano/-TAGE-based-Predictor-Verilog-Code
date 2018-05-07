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


module Index_Function(CLK,reset,ghist,phist,pc_addr, Index,index_tag_enable);


parameter HistLen=16;	//History length..this is like the original length
parameter GlobLen=131;	//This is the global history length
parameter IL=10;		//Index size ie number of addresses...this is like the compressed length
parameter OutLen=6 ; 	//this is the length that will be thrown out at the end and wont be used...HistLen%OutLen
parameter PLen=16 ;		//this is length of path History
parameter pc_len=32;	//length of the program counter
parameter pc_shift=10;// IL -(NHIS-bank-1)

input CLK;
input reset, index_tag_enable;
input[pc_len-1 : 0] pc_addr;
input[GlobLen-1:0] ghist;
input[PLen-1:0]  phist;

output[IL-1 : 0] Index;


reg [GlobLen-1:0] CompIndex;	//This History folding is for index
reg[pc_len-1 : 0] tempIndex;
wire temp1;
wire temp2;



	initial begin
		CompIndex={GlobLen{1'b0}};
		tempIndex={pc_len{1'b0}};
	end

	always @(posedge CLK) begin
		if(reset==1'b0)begin
			CompIndex={GlobLen{1'b0}};
			tempIndex={pc_len{1'b0}};		
		end
		else if(index_tag_enable==1'b1) begin
			CompIndex <= ({CompIndex[GlobLen-2 : 0], ghist[0]}) ^ ({ghist[GlobLen-1 : 0],{OutLen{1'b0}}}) ^ ({{HistLen{1'b0}},CompIndex[GlobLen-1:GlobLen-HistLen]});
			tempIndex <= (pc_addr) ^ ({{pc_shift{1'b0}},pc_addr[pc_len-1:pc_len-pc_shift]}) ^ (phist[IL-1:0]);		//can check more option to mix the path history
		end
		else begin
			CompIndex<=CompIndex;
			tempIndex<=tempIndex;
		end

		
	end
	
	assign Index=(CompIndex[IL-1:0] ^ tempIndex[IL-1:0]) ;
  
endmodule


















