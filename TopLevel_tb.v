`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2017 09:07:50 PM
// Design Name: 
// Module Name: TopLevel_tb
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


module TopLevel_tb();
    parameter ADDRESS_SIZE = 32;
    parameter TRAINING_DATA_SIZE = 3898078;
    parameter INSTRUCTION_INDEX_SIZE = $clog2(TRAINING_DATA_SIZE);
    parameter GHL = 22;
    parameter WS = 5;
    parameter LS = 128;
    parameter LS_INDEX_SIZE = $clog2(LS);
    reg Clk, Rst;
    wire BranchPrediction;
    wire PredictionCorrect;
    wire [INSTRUCTION_INDEX_SIZE - 1:0] CorrectlyPredicted, TotalBranches;
	reg [INSTRUCTION_INDEX_SIZE - 1:0] temp_branch=32'h00;
    
        
    TopLevel#(ADDRESS_SIZE, TRAINING_DATA_SIZE, INSTRUCTION_INDEX_SIZE, GHL, WS, LS, LS_INDEX_SIZE) 
            TopLevel_0(Clk, Rst, BranchPrediction, PredictionCorrect, CorrectlyPredicted, TotalBranches);
    
    initial begin
            Clk <= 1'b0;
        forever #5 Clk <= ~Clk;
    end 
    
    initial begin 
       Rst <= 0;
       #100
       Rst<=1;
    end
	
	always @(TotalBranches)
	begin
		if(TotalBranches % 32'd100000==32'd000000)
			begin
			$display("The hit rate is%d ,%d, %d",CorrectlyPredicted,TotalBranches,CorrectlyPredicted-temp_branch);
			//$display("The hit rate is%d",(CorrectlyPredicted-temp_branch)/100000);
				temp_branch<=CorrectlyPredicted;
			end
	end
    
endmodule
