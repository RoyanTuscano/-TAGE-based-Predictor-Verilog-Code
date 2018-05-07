`timescale 1ns / 1ps

module controller(clk,reset,interrupt_in1,
                   en1,en2,
                     counter_enable,counter_reset,
                     inc_addr_enable1,inc_addr_enable2,
                     address_reset1,address_reset2,
                     address_full1,address_full2,
                     counter_full,interrupt_out1,
					 index_tag_enable,table_read_en,
					 update_enable, update_predictor_enable);
input clk,interrupt_in1,reset;
input address_full1, address_full2;
input counter_full;
output reg en1,en2;

output reg address_reset1,address_reset2;
output reg inc_addr_enable1,inc_addr_enable2;
output reg counter_enable;
output reg counter_reset;
output reg interrupt_out1;

output reg table_read_en, update_predictor_enable, update_enable, index_tag_enable;



parameter wstate=0,state_1=1,state_2=2,state_3=3,state_4=4,state_5=5,state_6=6,state_7=7,state_8=8,state_9=9,
		 comp1_cycle_1=10, comp1_cycle_2=11, comp1_cycle_3=12, comp1_cycle_4=13, comp1_cycle_5=14, comp1_cycle_6=15, comp1_cycle_7=16, comp1_cycle_8=17,
		 comp2_cycle_1=18, comp2_cycle_2=19, comp2_cycle_3=20, comp2_cycle_4=21, comp2_cycle_5=22, comp2_cycle_6=23, comp2_cycle_7=24, comp2_cycle_8=25;

reg [4:0]state;
reg [4:0]next_state;

initial begin
			en1<=1'b0;
			en2<=1'b0;
			counter_enable<=1'b0;
			counter_reset<=1'b1;
			inc_addr_enable1<=1'b0;
			inc_addr_enable2<=1'b0;
			interrupt_out1<=1'b0;
			address_reset1<=1'b1;
			address_reset2<=1'b1;
			index_tag_enable<=1'b0;
			table_read_en<=1'b0;
			update_predictor_enable<=1'b0;
			update_enable<=1'b0;
			interrupt_out1<=1'b0;
end


always @(posedge clk)
begin
	if(reset==1'b0)
		begin
			state<=wstate;
		end
	else
		begin
			state<=next_state;
		end
end


always @(state,interrupt_in1, counter_full,address_full1,address_full2)
begin
	case (state)
		wstate:	begin             //wait state for Buffer 1
				   	en1<=1'b0;
                    en2<=1'b0;
					interrupt_out1<=1'b0;
					address_reset1<=1'b1;
                    address_reset2<=1'b1;
					counter_enable=1'b0;
					counter_reset=1'b1;
					inc_addr_enable1=1'b0;
					inc_addr_enable2=1'b0;	
					index_tag_enable<=1'b0;
					table_read_en<=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					if(interrupt_in1==1'b1)
						next_state<=state_1;
					else
						next_state<=wstate;
				end
		state_1:begin             //enable the BRAM and enable the counter to put a delay before memory read is made
					en1<=1'b1;
					en2<=1'b0;
					interrupt_out1<=1'b0;
					address_reset1<=1'b0;
                    address_reset2<=1'b1;
					counter_enable<=1'b1;
					counter_reset<=1'b0;
					inc_addr_enable1<=1'b0;inc_addr_enable2=1'b0;
					index_tag_enable<=1'b0;
					table_read_en<=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					next_state<=comp1_cycle_1;
				end
		comp1_cycle_1:begin
					en1<=1'b1;en2<=1'b0;
		            interrupt_out1<=1'b0;
		        	address_reset1<=1'b0;address_reset2<=1'b1;
					inc_addr_enable1<=1'b0; inc_addr_enable2=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b1;
					table_read_en<=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					next_state<=comp1_cycle_2;
					end
		comp1_cycle_2:begin
					en1<=1'b1;en2<=1'b0;
		            interrupt_out1<=1'b0;
		        	address_reset1<=1'b0;address_reset2<=1'b1;
					inc_addr_enable1<=1'b0;inc_addr_enable2=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;				
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;					
					next_state<=comp1_cycle_3;					
					end
		comp1_cycle_3:begin
					en1<=1'b1;en2<=1'b0;
		            interrupt_out1<=1'b0;
		        	address_reset1<=1'b0;address_reset2<=1'b1;
					inc_addr_enable1<=1'b0;inc_addr_enable2=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;	
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					next_state<=comp1_cycle_4;					
					end					
		comp1_cycle_4:begin
					en1<=1'b1;en2<=1'b0;
		            interrupt_out1<=1'b0;
		        	address_reset1<=1'b0;address_reset2<=1'b1;
					inc_addr_enable1<=1'b0;inc_addr_enable2=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					next_state<=comp1_cycle_5;					
					end
		comp1_cycle_5:begin
					en1<=1'b1; en2<=1'b0;
		            interrupt_out1<=1'b0;
		        	address_reset1<=1'b0; address_reset2<=1'b1;
					inc_addr_enable1<=1'b0;inc_addr_enable2=1'b0;
					counter_reset<=1'b0 ;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;
					update_predictor_enable<=1'b1;
					update_enable<=1'b0;
					next_state<=comp1_cycle_6;					
					end
		comp1_cycle_6:begin
					en1<=1'b1;en2<=1'b0;
		            interrupt_out1<=1'b0;
		        	address_reset1<=1'b0;address_reset2<=1'b1;
					inc_addr_enable1<=1'b0;inc_addr_enable2=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;
					update_predictor_enable<=1'b0;
					update_enable<=1'b1;
					next_state<=state_3;					
					end
		state_3:begin             //increment the address and check if full address value is reached
                        en1<=1'b1;en2<=1'b0;
                        address_reset1<=1'b0;address_reset2<=1'b1;
					index_tag_enable<=1'b0;
					table_read_en<=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;inc_addr_enable2=1'b0;
                        // check if the address if full
                        if(address_full1==1'b1)
                        begin
                             interrupt_out1<=1'b1;
                            inc_addr_enable1<=1'b0;
                            counter_enable<=1'b0;
                            counter_reset<=1'b1;
                            next_state<=state_4;
                        end
                        else
                        begin
                             interrupt_out1<=1'b0;
                            inc_addr_enable1<=1'b1;
                            counter_enable<=1'b0;
                            counter_reset<=1'b1;
                            next_state<=state_1;
                        end
				end
		state_4:begin       //disable the buffer address counter      
                          en1<=1'b0; en2<=1'b0;
                          address_reset1<=1'b1; address_reset2<=1'b0;
                          interrupt_out1<=1'b1;
                          inc_addr_enable1<=1'b0;inc_addr_enable2=1'b0;
                          counter_enable<=1'b0; counter_reset<=1'b1;
						index_tag_enable<=1'b0;
						table_read_en<=1'b0;
						update_predictor_enable<=1'b0;
						update_enable<=1'b0;
                          next_state<=state_5;
		         end
		state_5:begin     //check if the second register can be read
                        en1<=1'b0;en2<=1'b1;
                        address_reset1<=1'b1;address_reset2<=1'b0;
                        interrupt_out1<=1'b1;
					index_tag_enable<=1'b0;
					table_read_en<=1'b0;
					inc_addr_enable1<=1'b0;inc_addr_enable2=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
                        if(interrupt_in1==1'b0)
                            next_state<=state_6;
                        else
                            next_state<=state_5;
		         end
		 state_6:begin        //enable the counter an
		                en1<=1'b0;en2<=1'b1;
		                address_reset1<=1'b1; address_reset2<=1'b0;
		                interrupt_out1<=1'b1;
                        counter_enable<=1'b1;counter_reset<=1'b0;
                        inc_addr_enable2<=1'b0;inc_addr_enable1<=1'b0;
					index_tag_enable<=1'b0;
					table_read_en<=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
                        next_state<= comp2_cycle_1;		              
		          end
		comp2_cycle_1:begin
		  		    en1<=1'b0; en2<=1'b1;
		            address_reset1<=1'b1; address_reset2<=1'b0;
		            interrupt_out1<=1'b1; 
					inc_addr_enable2<=1'b0;inc_addr_enable1<=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b1;
					table_read_en<=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					next_state<=comp2_cycle_2;
					end
		comp2_cycle_2:begin
		  		    en1<=1'b0; en2<=1'b1;
		            address_reset1<=1'b1; address_reset2<=1'b0;
		            interrupt_out1<=1'b1; 
					inc_addr_enable2<=1'b0;inc_addr_enable1<=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;				
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;					
					next_state<=comp2_cycle_3;					
					end
		comp2_cycle_3:begin
		  		    en1<=1'b0; en2<=1'b1;
		            address_reset1<=1'b1; address_reset2<=1'b0;
		            interrupt_out1<=1'b1; 
					inc_addr_enable2<=1'b0;inc_addr_enable1<=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;	
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					next_state<=comp2_cycle_4;					
					end					
		comp2_cycle_4:begin
		  		    en1<=1'b0; en2<=1'b1;
		            address_reset1<=1'b1; address_reset2<=1'b0;
		            interrupt_out1<=1'b1; 
					inc_addr_enable2<=1'b0;inc_addr_enable1<=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					next_state<=comp2_cycle_5;					
					end
		comp2_cycle_5:begin
		  		    en1<=1'b0; en2<=1'b1;
		            address_reset1<=1'b1; address_reset2<=1'b0;
		            interrupt_out1<=1'b1; 
					inc_addr_enable2<=1'b0;inc_addr_enable1<=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;
					update_predictor_enable<=1'b1;
					update_enable<=1'b0;
					next_state<=comp2_cycle_6;					
					end
		comp2_cycle_6:begin
		  		    en1<=1'b0; en2<=1'b1;
		            address_reset1<=1'b1; address_reset2<=1'b0;
		            interrupt_out1<=1'b1; 
					inc_addr_enable2<=1'b0;inc_addr_enable1<=1'b0;
					counter_reset<=1'b0;counter_enable<=1'b1;
					//
					index_tag_enable<=1'b0;
					table_read_en<=1'b1;
					update_predictor_enable<=1'b0;
					update_enable<=1'b1;
					next_state<=state_8;					
					end
		  state_8:begin
		  		        en1<=1'b0;en2<=1'b1;
		                address_reset1<=1'b1;address_reset2<=1'b0;
					index_tag_enable<=1'b0;
					table_read_en<=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
					inc_addr_enable1<=1'b0;
         // check if the address if full
                        interrupt_out1<=1'b1;
                        if(address_full2==1'b1)
                        begin
                            inc_addr_enable2<=1'b0;
                            counter_enable<=1'b0;
                            counter_reset<=1'b1;
                            next_state<=wstate;
                        end
                        else
                        begin
                            inc_addr_enable2<=1'b1;
                            counter_enable<=1'b0;
                            counter_reset<=1'b1;
                            next_state<=state_6;
                        end
		          end
		default:begin
		en1<=1'b0;en2<=1'b0;
                        counter_enable=1'b0;
                        counter_reset=1'b1;
                        inc_addr_enable1=1'b0;
                        inc_addr_enable2=1'b0;
						interrupt_out1<=1'b0;
						address_reset1<=1'b1;address_reset2<=1'b1;
					index_tag_enable<=1'b0;
					table_read_en<=1'b0;
					update_predictor_enable<=1'b0;
					update_enable<=1'b0;
                        next_state<=wstate;
				end
	endcase
end

endmodule




