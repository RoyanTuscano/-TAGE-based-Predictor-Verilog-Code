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
   // parameter TRAINING_DATA_SIZE = 65536;
    parameter INSTRUCTION_INDEX_SIZE = 32;
    
    input Clk,reset,enable;
    input BranchResult;
    reg [INSTRUCTION_INDEX_SIZE - 1:0] CorrectlyPredicted_reg, TotalBranches_reg;
    output reg [INSTRUCTION_INDEX_SIZE - 1:0] CorrectlyPredicted, TotalBranches;
    
    initial begin
        CorrectlyPredicted <= {INSTRUCTION_INDEX_SIZE{1'b0}};
        TotalBranches <= {INSTRUCTION_INDEX_SIZE{1'b0}};
    end
    
    always@(posedge Clk) begin
		if(reset==1'b0)
			begin
				CorrectlyPredicted <={INSTRUCTION_INDEX_SIZE{1'b0}};
				TotalBranches<={INSTRUCTION_INDEX_SIZE{1'b0}};
			end
        else if (BranchResult==1'b1 && enable==1'b1) begin
            CorrectlyPredicted <= CorrectlyPredicted + 32'h0000_0001;
			TotalBranches <= TotalBranches + 32'h0000_0001;
        end
		else if(BranchResult==1'b0 && enable==1'b1) begin
			CorrectlyPredicted<= CorrectlyPredicted;
			TotalBranches<= TotalBranches + 32'h0000_0001;		
		end
		else begin
			CorrectlyPredicted <= CorrectlyPredicted;
			TotalBranches <= TotalBranches;	
		end
        
    end
    
endmodule
