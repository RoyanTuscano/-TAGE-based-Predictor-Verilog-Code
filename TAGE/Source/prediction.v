`timescale 1ns / 1ps

//This is the module for making prediction and choosing appropriate predictor
module prediction(CLK,reset, tag_eq_bank1, tag_eq_bank2,tag_eq_bank3, tag_eq_bank4,
				 Bimodal_C_bit, C_bit_Bank1, C_bit_Bank2, C_bit_Bank3, C_bit_Bank4,branch_prediction);
				 
parameter CL=3;
				 
input CLK,reset;
input tag_eq_bank1,tag_eq_bank2, tag_eq_bank3, tag_eq_bank4;
input [ CL-1 : 0 ] Bimodal_C_bit, C_bit_Bank1, C_bit_Bank2, C_bit_Bank3, C_bit_Bank4;

output reg branch_prediction;

always @(posedge CLK)
begin
	if(reset==1'b0)
		branch_prediction<=1'b0;
	else begin
		if(tag_eq_bank4==1'b1)
			branch_prediction<=C_bit_Bank4[CL-1];
		else if(tag_eq_bank3==1'b1 && tag_eq_bank4 != 1'b1)
			branch_prediction<=C_bit_Bank3[CL-1];
		else if(tag_eq_bank2==1'b1 && tag_eq_bank4 != 1'b1 && tag_eq_bank3 != 1'b1)
			branch_prediction<=C_bit_Bank2[CL-1];
		else if(tag_eq_bank1==1'b1 && tag_eq_bank2!=1'b1 && tag_eq_bank4 != 1'b1 && tag_eq_bank3 != 1'b1)
			branch_prediction<=C_bit_Bank1[CL-1];
		else 
			branch_prediction<=Bimodal_C_bit[CL-1];
	end
		
end 

endmodule
