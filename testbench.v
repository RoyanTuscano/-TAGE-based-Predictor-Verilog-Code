`timescale 1ns / 1ps
module tb();

parameter INSTRUCTION_INDEX_SIZE = 32;
parameter pc_address_size=32;
parameter branch_result_size=1;
parameter Address_width=16;

reg clk,reset, interrupt_in1;
reg [pc_address_size-1:0]din_pc1,din_pc2;
reg [branch_result_size-1:0] din_br1,din_br2;
wire [INSTRUCTION_INDEX_SIZE-1 : 0] CorrectlyPredicted, TotalBranches;
wire en1, en2;
wire interrupt_out1, we1,we2;

wire [Address_width-1:0]addrout1, addrout2;
reg [INSTRUCTION_INDEX_SIZE - 1:0] temp_branch=32'h00;


main main01(clk,reset,en1,en2,we1,we2,interrupt_in1,interrupt_out1,
            addrout1,addrout2,din_pc1,din_pc2,din_br1,din_br2,CorrectlyPredicted, TotalBranches);
/*
main tb(.clk(clk),.reset(reset),.en1(en1),.en2(en2),.we1(we1),.we2(we2),.interrupt_in1(interrupt_in1),.interrupt_in2(interrupt_in2),
    .interrupt_out1(interrupt_out1),.data_out(dataout),.addrout1(addrout1),.addrout2(addrout2),.din1(din1),.din2(din2),.dout1(dout1),
    .dout2(dout2));
*/
  initial begin
          clk <= 1'b0;
      forever #10 clk <= ~clk;
  end

initial begin
    interrupt_in1<=1'b0;
	reset<=1'b0;
	#500
	reset<=1'b1;
	#300
	interrupt_in1<=1'b1;
	reset<=1'b1;
	#100000;
	interrupt_in1<=1'b0;
	#2000000;
	interrupt_in1<=1'b1;
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
