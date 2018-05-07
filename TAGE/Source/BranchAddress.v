`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2017 02:55:26 PM
// Design Name: 
// Module Name: BranchAddress
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


module BranchAddress(Clk, reset, InstructionNumber, BranchAddress, BranchResult);
    parameter ADDRESS_SIZE = 8;
    parameter TRAINING_DATA_SIZE = 3898078;
    parameter INSTRUCTION_INDEX_SIZE = $clog2(TRAINING_DATA_SIZE);   
    input Clk,reset;
    input [INSTRUCTION_INDEX_SIZE - 1:0] InstructionNumber;
    output reg [ADDRESS_SIZE - 1:0] BranchAddress;
    output reg BranchResult;
    reg [ADDRESS_SIZE - 1:0] Address [TRAINING_DATA_SIZE - 1:0];
    reg Branch [TRAINING_DATA_SIZE - 1:0];
    integer i;
    
    initial begin
        for (i = 0; i < TRAINING_DATA_SIZE; i = i + 'd1) begin
            Address[i] = 0;
            Branch[i] = 0;
        end
        BranchAddress <= {ADDRESS_SIZE{1'b0}};
        BranchResult <= {1{1'b0}};
        $readmemh("C:/Users/royan/Desktop/Reconfigurable_Computing/branch_prediction/Branch_Data/WS04_Address.txt", Address);
        $readmemb("C:/Users/royan/Desktop/Reconfigurable_Computing/branch_prediction/Branch_Data/WS04_branchresult.txt", Branch);
    end
  
    always@(Clk) begin
		if(reset==1'b0) begin
		    BranchAddress <= {ADDRESS_SIZE{1'b0}};
			BranchResult <= {1{1'b0}};
		end
		else begin
		    BranchAddress <= Address[InstructionNumber];
			BranchResult <= Branch[InstructionNumber];
		end

    end 
    
endmodule
