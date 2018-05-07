`timescale 1ns / 1ps
//This is the module that is responsible for controlling the operations of the TAGE predictor, you can pipeline the operations for higher speedup
module TAGE_Controller(CLK,reset,
						index_tag_enable,instruction_inc_en,table_read_en, update_enable, update_predictor_enable);


input CLK,reset;


output reg index_tag_enable;		//This is to enable the calculation of Table Address
output reg instruction_inc_en;				//This is to load the instruction
output reg table_read_en, update_predictor_enable, update_enable;


wire temp1;
wire temp2;
reg[3:0] state, next_state;

initial begin

end



parameter[3:0] wait_state=0, state_1 = 1, state_2 = 2, state_3 = 3, state_4 = 4, state_5 = 5,
				state_6 = 6, state_7 = 7, state_8 = 8, state_9 = 9;

		always @(posedge CLK)begin
			if(reset==0) begin
				state<=wait_state;
				end
			else begin
			state<=next_state;
				end
			end

	always @(state)
	begin
		case(state)
			wait_state: 		
					begin
						instruction_inc_en <= 1'b0;		
						index_tag_enable<=1'b0;
						table_read_en<=1'b0;
						update_predictor_enable<=1'b0;
						update_enable<=1'b0;
						next_state<=state_1;
					end
			state_1:begin			
						instruction_inc_en <= 1'b1;	
						index_tag_enable<=1'b0;
						table_read_en<=1'b0;
						update_predictor_enable<=1'b0;
						update_enable<=1'b0;
						next_state <= state_2;
					end
			state_2:begin			
						instruction_inc_en <= 1'b0;	
						index_tag_enable<=1'b1;
						table_read_en<=1'b0;
						update_predictor_enable<=1'b0;
						update_enable<=1'b0;						
						next_state <= state_3;
						
					end
			state_3:begin			
						instruction_inc_en <= 1'b0;	
						index_tag_enable<=1'b0;
						table_read_en<=1'b1;
						next_state <= state_4;						
						update_predictor_enable<=1'b0;
						update_enable<=1'b0;					
					end
					
			state_4:begin		//comparasion of the tags takes place	
						instruction_inc_en <= 1'b0;	
						index_tag_enable<=1'b0;
						table_read_en<=1'b1;
						next_state <= state_5;
						update_predictor_enable<=1'b0;
						update_enable<=1'b0;
						end
			state_5:begin	//predicition takes place
						instruction_inc_en <= 1'b0;	
						index_tag_enable<=1'b0;
						table_read_en<=1'b1;
						update_predictor_enable<=1'b0;
						update_enable<=1'b0;
						next_state <= state_6;						
					end
			state_6:begin
						instruction_inc_en <= 1'b0;	
						index_tag_enable<=1'b0;
						table_read_en<=1'b1;
						update_predictor_enable<=1'b1;
						update_enable<=1'b0;
						next_state <= state_7;	
					end
			state_7:begin
						instruction_inc_en <= 1'b0;	
						index_tag_enable<=1'b0;
						table_read_en<=1'b1;
						update_predictor_enable<=1'b0;
						update_enable<=1'b1;
						next_state <= state_1;						
					end
			default:begin
					end
		

	       endcase
	     end

			
			


  
endmodule


















