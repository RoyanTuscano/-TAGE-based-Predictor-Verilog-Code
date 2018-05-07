`timescale 1ns / 1ps

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
