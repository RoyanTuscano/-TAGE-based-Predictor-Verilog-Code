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

module comparator(clk,reset, a, b, eq);
    parameter DATAWIDTH = 1;
    input [DATAWIDTH-1:0] a, b;
    output reg eq;
    input clk,reset;
    
    always@(posedge clk) begin
        if(reset==1'b0)
        begin
            eq<=1'b0;
        end
        else if (a == b) begin
            eq <= 1'b1;  
        end
        else begin
            eq <= 1'b0;
        end
    end
endmodule
