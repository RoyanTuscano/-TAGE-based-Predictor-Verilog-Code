`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2017 01:54:19 PM
// Design Name: 
// Module Name: Statistics
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


module Statistics(Clk,reset, BranchResult, CorrectlyPredicted, TotalBranches,enable);
    parameter TRAINING_DATA_SIZE = 65536;
    parameter INSTRUCTION_INDEX_SIZE = $clog2(TRAINING_DATA_SIZE);
    
    input Clk,reset,enable;
    input BranchResult;
    reg [INSTRUCTION_INDEX_SIZE - 1:0] CorrectlyPredicted_reg, TotalBranches_reg;
    output reg [INSTRUCTION_INDEX_SIZE - 1:0] CorrectlyPredicted, TotalBranches;
    
    initial begin
        CorrectlyPredicted <= 0;
        TotalBranches <= 0;
    end
    
    always@(posedge Clk) begin
		if(reset==1'b0)
			begin
				CorrectlyPredicted <= 0;
				TotalBranches<=0;
			end
        else if (BranchResult==1'b1 && enable==1'b1) begin
            CorrectlyPredicted <= CorrectlyPredicted + 1;
			TotalBranches <= TotalBranches + 1;
        end
		else if(BranchResult==1'b0 && enable==1'b1) begin
			CorrectlyPredicted<= CorrectlyPredicted;
			TotalBranches<= TotalBranches + 1;		
		end
		else begin
			CorrectlyPredicted <= CorrectlyPredicted;
			TotalBranches <= TotalBranches;	
		end
        
    end
    
endmodule
