`timescale 1ns / 1ps
//This is the Top module of the source..you can change the index bits to vary number of enteries in the Bimodal table, and TAG component tables

module TopLevel(CLK, reset, BranchPrediction, PredictionCorrectReg, CorrectlyPredicted, TotalBranches);
    parameter ADDRESS_SIZE = 32;
    parameter TRAINING_DATA_SIZE = 131072/2;
    parameter INSTRUCTION_INDEX_SIZE = $clog2(TRAINING_DATA_SIZE);
    parameter GHL = 23;
    parameter WS = 5;
    parameter LS = 128;
    parameter LS_INDEX_SIZE = $clog2(LS);
	parameter GlobLen=131;	//This is the global history length
    parameter PLen=16 ;		//this is length of path History
	parameter tag_len=8;	//length of the tag used
	parameter tag_len1=9;	//length of the tag used for another CSR during folding
	parameter IL=10;		//Index size ie number of addresses...this is like the compressed length
	parameter CL=3;		//Counter length
	parameter UL=2;		//Useful length
	
	parameter HistLen_Bank1=8;
	parameter HistLen_Bank2=15;
	parameter HistLen_Bank3=44;
	parameter HistLen_Bank4=130;
	
	parameter OutLen1=0 ; 	//this is the length that will be thrown out at the end and wont be used...HistLen%OutLen
	parameter OutLen2=7 ;
	parameter OutLen3=4 ;
	parameter OutLen4=2;
	
	parameter pc_shift=10;
	
    input CLK, reset;
    wire Clk_decode, Clk_execute, Clk_done;
    wire [ADDRESS_SIZE - 1:0] BranchAddress,pc;
    wire [INSTRUCTION_INDEX_SIZE - 1:0] InstructionNumber,InstructionNumber_in;
    wire [LS_INDEX_SIZE - 1:0] index;
    wire BranchResult, BranchResult_register;
    wire [(GHL * WS) - 1:0] Perceptron;
    wire [(GHL * WS) - 1:0] DotProduct_out;
    wire PredictionCorrect;
    wire [GHL - 1:0] GlobalHistoryTable;
    output PredictionCorrectReg;
    output BranchPrediction;
    output [INSTRUCTION_INDEX_SIZE - 1:0] CorrectlyPredicted, TotalBranches;
	
	
	
	wire instruction_inc_en,index_tag_enable, table_read_en,wr;
	wire Actual_branch;
	
	wire [PLen-1:0]  phist;
	wire [GlobLen-1:0] ghist;
	wire [tag_len-1 : 0] Comp_tag_bank1, Comp_tag_bank2;
	wire [tag_len : 0] Comp_tag_bank3, Comp_tag_bank4;
	
	wire [tag_len-1 : 0] tag_bank1, tag_bank2;
	wire [tag_len : 0] tag_bank3,tag_bank4;
	
	wire [IL-1 : 0] Index_bank1, Index_bank2, Index_bank3, Index_bank4;
	wire[CL-1:0] Bimodal_C_bit,C_bit_Bank1,C_bit_Bank2, C_bit_Bank3, C_bit_Bank4;
	wire[UL-1:0] U_bit_Bank1, U_bit_Bank2, U_bit_Bank3, U_bit_Bank4;
	
	wire inc_c_bit_Bimodal, dec_c_bit_Bimodal;
	wire inc_c_bit_bank1,inc_c_bit_bank2, inc_c_bit_bank3, inc_c_bit_bank4;
	wire dec_c_bit_bank1,dec_c_bit_bank2, dec_c_bit_bank3, dec_c_bit_bank4;
	wire inc_u_bit_bank1,inc_u_bit_bank2, inc_u_bit_bank3, inc_u_bit_bank4;
	wire dec_u_bit_bank1,dec_u_bit_bank2, dec_u_bit_bank3, dec_u_bit_bank4;
	
	wire correct_prediction, update_enable, Alloc, update_predictor_enable;

	TAGE_Controller Controller(.CLK(CLK),.reset(reset), .index_tag_enable(index_tag_enable),
								.instruction_inc_en(instruction_inc_en),.table_read_en(table_read_en),
								.update_enable(update_enable),.update_predictor_enable(update_predictor_enable));
	

    Incrementer#(TRAINING_DATA_SIZE) Incrementer_0(.Clk(CLK), .Rst(reset), 
                                .en(instruction_inc_en), .InstructionNumber_in(InstructionNumber_in), 
                                  .InstructionNumber_out(InstructionNumber));
    BranchAddress#(ADDRESS_SIZE, TRAINING_DATA_SIZE) BranchAddress_0(.Clk(CLK), .InstructionNumber(InstructionNumber), .BranchAddress(pc), .BranchResult(Actual_branch));
	
	
Index_Tag_Generator Index_Tag_Generator01(CLK,reset,ghist,pc, Index_bank1,Index_bank2,
							Index_bank3, Index_bank4,
							Comp_tag_bank1, Comp_tag_bank2, Comp_tag_bank3
							,Comp_tag_bank4, index_tag_enable);

	Bimodal_Table#(IL, CL) Bimodal_Table1(.Clk(CLK), .wr(wr), .rd(table_read_en), .index(pc)/*pc*/, .rdata_c_bits(Bimodal_C_bit)
											, .correct_prediction(correct_prediction), .inc_counter(inc_c_bit_Bimodal), .dec_counter(dec_c_bit_Bimodal)
											,.update_enable(update_enable));
	
	TAGE_Table#(IL,tag_len,UL,CL )  bank1(.Clk(CLK), .wr(wr), .rd(table_read_en), .index(Index_bank1), .rdata_tag_bits(tag_bank1), .rdata_u_bits(U_bit_Bank1),
									.rdata_c_bits(C_bit_Bank1), .wdata_tag_bits(Comp_tag_bank1),
								.correct_prediction(correct_prediction), .inc_u_bit(inc_u_bit_bank1),.dec_u_bit(dec_u_bit_bank1),
								.inc_c_bit(inc_c_bit_bank1), .dec_c_bit(dec_c_bit_bank1), .alloc(Alloc),.update_enable(update_enable));
								
	TAGE_Table#(IL,tag_len,UL,CL )  bank2(.Clk(CLK), .wr(wr), .rd(table_read_en), .index(Index_bank2), .rdata_tag_bits(tag_bank2), .rdata_u_bits(U_bit_Bank2),
									.rdata_c_bits(C_bit_Bank2), .wdata_tag_bits(Comp_tag_bank2),
								.correct_prediction(correct_prediction), .inc_u_bit(inc_u_bit_bank2),.dec_u_bit(dec_u_bit_bank2),
								.inc_c_bit(inc_c_bit_bank2), .dec_c_bit(dec_c_bit_bank2), .alloc(Alloc),.update_enable(update_enable));
								
	TAGE_Table#(IL,tag_len1,UL,CL )  bank3(.Clk(CLK), .wr(wr), .rd(table_read_en), .index(Index_bank3), .rdata_tag_bits(tag_bank3), .rdata_u_bits(U_bit_Bank3),
									.rdata_c_bits(C_bit_Bank3), .wdata_tag_bits(Comp_tag_bank3),
								.correct_prediction(correct_prediction), .inc_u_bit(inc_u_bit_bank3),.dec_u_bit(dec_u_bit_bank3),
								.inc_c_bit(inc_c_bit_bank3), .dec_c_bit(dec_c_bit_bank3), .alloc(Alloc),.update_enable(update_enable));
								
	TAGE_Table#(IL,tag_len1,UL,CL )  bank4(.Clk(CLK), .wr(wr), .rd(table_read_en), .index(Index_bank4), .rdata_tag_bits(tag_bank4), .rdata_u_bits(U_bit_Bank4),
									.rdata_c_bits(C_bit_Bank4), .wdata_tag_bits(Comp_tag_bank4),
								.correct_prediction(correct_prediction), .inc_u_bit(inc_u_bit_bank4),.dec_u_bit(dec_u_bit_bank4),
								.inc_c_bit(inc_c_bit_bank4), .dec_c_bit(dec_c_bit_bank4), .alloc(Alloc),.update_enable(update_enable));
								
	wire tag_eq_bank1, tag_eq_bank2, tag_eq_bank3, tag_eq_bank4;
	
	comparator#(tag_len) Comparator_Bank1(.clk(CLK),.reset(reset), .a(Comp_tag_bank1), .b(tag_bank1), .eq(tag_eq_bank1));
	
	comparator#(tag_len) Comparator_Bank2(.clk(CLK),.reset(reset), .a(Comp_tag_bank2), .b(tag_bank2), .eq(tag_eq_bank2));
	
	comparator#(tag_len1) Comparator_Bank3(.clk(CLK),.reset(reset), .a(Comp_tag_bank3), .b(tag_bank3), .eq(tag_eq_bank3));
	
	comparator#(tag_len1) Comparator_Bank4(.clk(CLK),.reset(reset), .a(Comp_tag_bank4), .b(tag_bank4), .eq(tag_eq_bank4));
	
	wire branch_predicted;
	//overall prediction#
	prediction#(CL) prediction_1(.CLK(CLK),.reset(reset), .tag_eq_bank1(tag_eq_bank1), .tag_eq_bank2(tag_eq_bank2),
								.tag_eq_bank3(tag_eq_bank3), .tag_eq_bank4(tag_eq_bank4),
							.Bimodal_C_bit(Bimodal_C_bit), .C_bit_Bank1(C_bit_Bank1), .C_bit_Bank2(C_bit_Bank2), 
							.C_bit_Bank3(C_bit_Bank3), .C_bit_Bank4(C_bit_Bank4),.branch_prediction(branch_predicted));
							
	comparator#(1) compare_prediction(.clk(CLK),.reset(reset),.a(branch_predicted),.b(Actual_branch),.eq(correct_prediction));
	
	wire branch_pred_bank0, branch_pred_bank1, branch_pred_bank2, branch_pred_bank3, branch_pred_bank4; 
	comparator#(1) prediction_bank0(.clk(CLK), .reset(reset), .a(Bimodal_C_bit[CL-1]), .b(Actual_branch), .eq(branch_pred_bank0));
	comparator#(1) prediction_bank1(.clk(CLK), .reset(reset), .a(C_bit_Bank1[CL-1]), .b(Actual_branch), .eq(branch_pred_bank1));
	comparator#(1) prediction_bank2(.clk(CLK), .reset(reset), .a(C_bit_Bank2[CL-1]), .b(Actual_branch), .eq(branch_pred_bank2));
	comparator#(1) prediction_bank3(.clk(CLK), .reset(reset), .a(C_bit_Bank3[CL-1]), .b(Actual_branch), .eq(branch_pred_bank3));
	comparator#(1) prediction_bank4(.clk(CLK), .reset(reset), .a(C_bit_Bank4[CL-1]), .b(Actual_branch), .eq(branch_pred_bank4));
	wire dummy0;
	
	update_predictor#(UL)update_predictor1(.CLK(CLK),.Branch_predicted(branch_predicted), .Actual_branch(Actual_branch), .Alloc(Alloc),
						.u_bits_1(U_bit_Bank1), .u_bits_2(U_bit_Bank2), .u_bits_3(U_bit_Bank3), .u_bits_4(U_bit_Bank4),
						.dec_bank1(dec_u_bit_bank1), .dec_bank2(dec_u_bit_bank2), .dec_bank3(dec_u_bit_bank3), .dec_bank4(dec_u_bit_bank4),
						.inc_bank1(inc_u_bit_bank1), .inc_bank2(inc_u_bit_bank2), .inc_bank3(inc_u_bit_bank3), .inc_bank4(inc_u_bit_bank4),
						.dec_counter_bank0(dec_c_bit_Bimodal), .dec_counter_bank1(dec_c_bit_bank1), .dec_counter_bank2(dec_c_bit_bank2),
						.dec_counter_bank3(dec_c_bit_bank3), .dec_counter_bank4(dec_c_bit_bank4),
						.inc_counter_bank0(inc_c_bit_Bimodal), .inc_counter_bank1(inc_c_bit_bank1), .inc_counter_bank2(inc_c_bit_bank2),
						.inc_counter_bank3(inc_c_bit_bank3), .inc_counter_bank4(inc_c_bit_bank4),
						.prediction_bank0(dummy0), .prediction_bank1(tag_eq_bank1), .prediction_bank2(tag_eq_bank2), 
						.prediction_bank3(tag_eq_bank3), .prediction_bank4(tag_eq_bank4),
						.branch_pred_bank0(Bimodal_C_bit[CL-1]), .branch_pred_bank1(C_bit_Bank1[CL-1]),
						.branch_pred_bank2(C_bit_Bank2[CL-1]), .branch_pred_bank3(C_bit_Bank3[CL-1]),
						.branch_pred_bank4(C_bit_Bank4[CL-1]),
						.update_predictor_enable(update_predictor_enable)
						);
						
	update_history#(GlobLen,PLen,ADDRESS_SIZE)update_history1(.CLK(CLK),.reset(reset),.ghist(ghist),.phist(phist),
												.pc(pc),.Actual_branch(Actual_branch),.update_history_enable(update_enable));
	Statistics#(TRAINING_DATA_SIZE) Statistics_0(.Clk(CLK),.reset(reset), .BranchResult(correct_prediction), 
	                       .CorrectlyPredicted(CorrectlyPredicted), .TotalBranches(TotalBranches),.enable(update_enable));
	
											
  
endmodule
