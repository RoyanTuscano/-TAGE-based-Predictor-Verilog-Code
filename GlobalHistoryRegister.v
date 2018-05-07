`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2017 11:31:35 AM
// Design Name: 
// Module Name: GlobalHistoryRegister
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


module GlobalHistoryRegister(branchValue, in, Clk, Rst, out);
    parameter GHL = 8;
    input [GHL - 1 : 0] in;
    input branchValue, Clk, Rst;
    output reg [GHL - 1 : 0] out;
        
    initial begin
        out <= 0;
    end
    
    always @(negedge Clk) begin
        if (Rst == 1'b1) begin
            out <= {GHL{1'b0}};
        end
        else begin
            out <= {branchValue, in[1 +: GHL - 1]};
        end
//        out[0] <= 1'b1;
    end   

endmodule

