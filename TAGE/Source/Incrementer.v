`timescale 1ns / 1ps

module Incrementer(Clk, Rst, en, InstructionNumber_in, InstructionNumber_out);
    parameter TRAINING_DATA_SIZE = 256;
    parameter INSTRUCTION_INDEX_SIZE = $clog2(TRAINING_DATA_SIZE);
    input Clk, Rst, en;
    input [INSTRUCTION_INDEX_SIZE - 1:0] InstructionNumber_in;
    output reg [INSTRUCTION_INDEX_SIZE - 1:0] InstructionNumber_out;
    
    initial begin
        InstructionNumber_out <= 0;
    end
    
    always@(posedge Clk, posedge Rst) begin
        if (Rst == 1'b0) begin
            InstructionNumber_out <= 0;
        end
        else if (en == 1'b1) begin
            InstructionNumber_out <= InstructionNumber_out + 1'b1;
        end
		else
			InstructionNumber_out <= InstructionNumber_out;
		
    end
    
endmodule
