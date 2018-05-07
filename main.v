`timescale 1ns / 1ps
module main(clk,reset,en1,en2,we1,we2,interrupt_in1,interrupt_out1,
            addrout1,addrout2,din_pc1,din_pc2,din_br1,din_br2,CorrectlyPredicted, TotalBranches);

parameter INSTRUCTION_INDEX_SIZE = 32;
parameter pc_address_size=32;
parameter branch_result_size=1;
parameter Address_width=16;
input clk,reset, interrupt_in1;
input [pc_address_size-1:0]din_pc1,din_pc2;
input [branch_result_size-1:0] din_br1,din_br2;
output [INSTRUCTION_INDEX_SIZE-1 : 0] CorrectlyPredicted, TotalBranches;
output wire en1, en2;
output wire interrupt_out1;
//output wire [7:0] dout;
output reg we1=1'b0;
output reg we2=1'b0;
output wire [Address_width-1:0]addrout1, addrout2;

reg[Address_width-1:0] compare_addr1= {Address_width{1'b1}};
reg[Address_width-1:0] compare_addr2= {Address_width{1'b1}};

wire ena1,ena2, wen1,wen2;
wire[31:0] counter_value;
wire counter_enable,counter_reset;
wire inc_addr_enable1, inc_addr_enable2;
wire clk, reset, interrupt_in, counter_full, en;
wire [31:0] compare_counter;
wire address_full1,address_reset1;
wire address_full2,address_reset2;

//assign din=interrupt_in1?din1:din2;
//assign din=interrupt_in1?doutb1:doutb2;

//assign compare_counter=32'h1fff_ffff;
assign compare_counter=32'h0000_00ff;
assign ena1=1'b1;
assign ena2=1'b1;
assign wen1=1'b0;
assign wen2=1'b0;



wire /* instruction_inc_en,*/ index_tag_enable, table_read_en, update_predictor_enable, update_enable;
wire [INSTRUCTION_INDEX_SIZE - 1:0] CorrectlyPredicted, TotalBranches;
wire Actual_branch;
wire [INSTRUCTION_INDEX_SIZE - 1:0] pc;
wire [pc_address_size-1:0] pc_addr_001, pc_addr_002, dina_pc;
wire [branch_result_size-1:0] branch_result_001, branch_result_002,dina_br;

assign dina_pc={pc_address_size{1'b0}};
assign dina_br={branch_result_size{1'b0}};
assign pc = interrupt_out1? pc_addr_002 : pc_addr_001;

assign Actual_branch= interrupt_out1?  din_br2 : din_br1 ;

controller c1(      .clk(clk),.reset(reset),.interrupt_in1(interrupt_in1),
                    .en1(en1),.en2(en2),
                     .counter_enable(counter_enable),.counter_reset(counter_reset),
                     .inc_addr_enable1(inc_addr_enable1),.inc_addr_enable2(inc_addr_enable2),
                     .address_reset1(address_reset1),.address_reset2(address_reset2),
                     .address_full1(address_full1),.address_full2(address_full2),
                     .counter_full(counter_full),
                     .interrupt_out1(interrupt_out1),.index_tag_enable(index_tag_enable),
		.table_read_en(table_read_en),
		.update_enable(update_enable),.update_predictor_enable(update_predictor_enable));
			
counter count(.clk(clk),.reset(reset),.counter_reset(counter_reset),.counter_enable(counter_enable),.counter_value(counter_value));

comparator#(32) comp(.clk(clk),.a(counter_value), .b(compare_counter), .eq(counter_full),.reset(reset));

increment#(Address_width) address1(.clk(clk),.reset(reset),.addr_reset(address_reset1),.addr_out(addrout1),.enable(inc_addr_enable1));
increment#(Address_width) address2(.clk(clk), .reset(reset),.addr_reset(address_reset2), .addr_out(addrout2),.enable(inc_addr_enable2));

comparator#(Address_width) addr1(.clk(clk),.reset(reset),.a(addrout1), .b(compare_addr1), .eq(address_full1));
comparator#(Address_width) addr2(.clk(clk),.reset(reset),.a(addrout2), .b(compare_addr2), .eq(address_full2));


TopLevel toplevel_01(.CLK(clk), .reset(reset),.CorrectlyPredicted(CorrectlyPredicted), .TotalBranches(TotalBranches), .index_tag_enable(index_tag_enable),
		.table_read_en(table_read_en),
		.update_enable(update_enable),.update_predictor_enable(update_predictor_enable)	 ,
		.pc(pc),.Actual_branch(Actual_branch));

//increment_data buffer1_data(.clk(clk),.reset(reset),.in_data(din),.out_data(data_out));
//increment_data buffer2_data(.clk(clk),.reset(reset),.in_data(din2),.out_data(data_out2));

/*
blk_mem_gen_0 pc_address_01 (
  .clka(clk),    // input wire clka
  .ena(en1),      // input wire ena
  .wea(we1),      // input wire [0 : 0] wea
  .addra(addrout1),  // input wire [15 : 0] addra
  .dina(dina_pc),    // input wire [31 : 0] dina
  .douta(pc_addr_001)  // output wire [31 : 0] douta
);

PC_Address_2 pc_address_02 (
  .clka(clk),    // input wire clka
  .ena(en2),      // input wire ena
  .wea(we1),      // input wire [0 : 0] wea
  .addra(addrout2),  // input wire [15 : 0] addra
  .dina(dina_pc),    // input wire [31 : 0] dina
  .douta(pc_addr_002)  // output wire [31 : 0] douta
);

branch_Mem_1 branch_result_01 (
  .clka(clk),    // input wire clka
  .ena(en1),      // input wire ena
  .wea(we1),      // input wire [0 : 0] wea
  .addra(addrout1),  // input wire [15 : 0] addra
  .dina(dina_br),    // input wire [0 : 0] dina
  .douta(branch_result_001)  // output wire [0 : 0] douta
);

Branch_result_2 branch_result_02 (
  .clka(clk),    // input wire clka
  .ena(en2),      // input wire ena
  .wea(we1),      // input wire [0 : 0] wea
  .addra(addrout2),  // input wire [15 : 0] addra
  .dina(dina_br),    // input wire [0 : 0] dina
  .douta(branch_result_002)  // output wire [0 : 0] douta
);
*/
endmodule