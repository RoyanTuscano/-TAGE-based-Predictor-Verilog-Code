`timescale 1ns / 1ps
//This module update the precictor in terms of useful bits, predictor bits and tag bits..It generates the control for respective enteries to update
module update_predictor(CLK,Branch_predicted, Actual_branch, Alloc,
						u_bits_1, u_bits_2, u_bits_3, u_bits_4,
						dec_bank1, dec_bank2, dec_bank3, dec_bank4,
						inc_bank1, inc_bank2, inc_bank3, inc_bank4,
						dec_counter_bank0, dec_counter_bank1, dec_counter_bank2, dec_counter_bank3, dec_counter_bank4,
						inc_counter_bank0, inc_counter_bank1, inc_counter_bank2, inc_counter_bank3, inc_counter_bank4,
						prediction_bank0, prediction_bank1, prediction_bank2, prediction_bank3, prediction_bank4,
						branch_pred_bank0, branch_pred_bank1, branch_pred_bank2, branch_pred_bank3, branch_pred_bank4,
						update_predictor_enable
						);




//parameter HistLen=16;	//History length..this is like the original length
//parameter GlobLen=131;	//This is the global history length
//parameter IL=10;		//Index size ie number of addresses...this is like the compressed length
//parameter OutLen=6 ; 	//this is the length that will be thrown out at the end and wont be used...HistLen%OutLen
//parameter PLen=16 ;		//this is length of path History
//parameter pc_len=32;	//length of the program counter
//parameter pc_shift=10;// IL -(NHIS-bank-1)
parameter UL=2;			// U bits length
//parameter NHIST =1;		//compute this at top layer
//parameter Num_bank=5;	//Number of Banks


//input[pc_len-1 : 0] pc_addr;
//input[GlobLen-1:0] ghist;
//input[PLen-1:0]  phist;
input CLK;
input Branch_predicted;
input Actual_branch;
input update_predictor_enable;

input[UL-1:0] u_bits_1, u_bits_2, u_bits_3, u_bits_4;

output reg Alloc;
output reg dec_bank1;		//Decide if you it as a reg or something else..Because it might continuously decrement
output reg dec_bank2;		//else use a control loop or a controller
output reg dec_bank3;
output reg dec_bank4;

output reg inc_bank1;
output reg inc_bank2;
output reg inc_bank3;
output reg inc_bank4;

input prediction_bank0;
input prediction_bank1;		//this is just to tell which bank is selected for prediction
input prediction_bank2;
input prediction_bank3;
input prediction_bank4;


input branch_pred_bank0;					//branch prediction of the banks
input branch_pred_bank1;
input branch_pred_bank2;
input branch_pred_bank3;
input branch_pred_bank4;

output reg inc_counter_bank0;
output reg inc_counter_bank1;
output reg inc_counter_bank2;
output reg inc_counter_bank3;
output reg inc_counter_bank4;

output reg dec_counter_bank0;
output reg dec_counter_bank1;
output reg dec_counter_bank2;
output reg dec_counter_bank3;
output reg dec_counter_bank4;

//output reg [Num_bank-1 : 0] select_bank;	//this is to select bank whose tags will be changed



	initial begin
		Alloc=1'b0;
	end


	
	always @(posedge CLK) begin

		if(Branch_predicted != Actual_branch && update_predictor_enable==1'b1) 		//incorrect branch prediction
			begin							
			inc_bank1<=1'b0;inc_bank2<=1'b0;inc_bank3<=1'b0;inc_bank4<=1'b0;
			if(prediction_bank1 != 1'b1 && prediction_bank2 != 1'b1 && prediction_bank3 != 1'b1 && prediction_bank4 != 1'b1)	//this is the bimodal table
						begin
							inc_counter_bank1 <= 1'b0; inc_counter_bank2 <= 1'b0; inc_counter_bank3 <= 1'b0; inc_counter_bank4 <= 1'b0;
							dec_counter_bank1 <= 1'b0; dec_counter_bank2 <= 1'b0; dec_counter_bank3 <= 1'b0; dec_counter_bank4 <= 1'b0;
							if(branch_pred_bank0==1'b1)	begin		//correct prediction that it is taken
                                  dec_counter_bank0 <= 1'b1;
                                  inc_counter_bank0 <= 1'b0;
                              end
                            else begin
                                dec_counter_bank0 <= 1'b0;
                                inc_counter_bank0 <= 1'b1;
                            end		//Branch predicted is taken,but its incorrect hence weaken it
							//Bank0_to_Update
							if(u_bits_1 != 0 && u_bits_2 != 0 && u_bits_3 !=0 &&u_bits_4 !=0)
								begin
									dec_bank1 <= 1'b1;
									dec_bank2 <= 1'b1;
									dec_bank3 <= 1'b1;
									dec_bank4 <= 1'b1;
									Alloc <= 1'b0;
								end	
							else
								begin
									Alloc <= 1'b1;
											if(u_bits_1 == 2'b00) 
												dec_bank1 <= 1'b1;	
											else
												dec_bank1 <= 1'b0;
											
											if(u_bits_2 == 2'b00 && u_bits_1 !=2'b00)
												dec_bank2 <= 1'b1;
											else
												dec_bank2 <= 1'b0;
												
											if(u_bits_3 == 2'b00 && u_bits_2 !=2'b00 && u_bits_1 !=2'b00)
												dec_bank3 <= 1'b1;
											else
												dec_bank3 <= 1'b0;
											
											if(u_bits_4 == 2'b00 && u_bits_3 !=2'b00 && u_bits_2 !=2'b00 && u_bits_1!=2'b00)
												dec_bank4 <= 1'b1;
											else
												dec_bank4 <= 1'b0;
								end

						end
			else if(prediction_bank1 == 1'b1 && prediction_bank2 != 1'b1 && prediction_bank3 != 1'b1 && prediction_bank4 != 1'b1 )
						begin
							inc_counter_bank0 <= 1'b0; inc_counter_bank2 <= 1'b0; inc_counter_bank3 <= 1'b0; inc_counter_bank4 <= 1'b0;
							dec_counter_bank0 <= 1'b0; dec_counter_bank2 <= 1'b0; dec_counter_bank3 <= 1'b0; dec_counter_bank4 <= 1'b0;
							if(branch_pred_bank1==1'b1)	begin		//correct prediction that it is taken
                                  dec_counter_bank1 <= 1'b1;
                                  inc_counter_bank1 <= 1'b0;
                              end
                            else begin
                                dec_counter_bank1 <= 1'b0;
                                inc_counter_bank1 <= 1'b1;
                            end	
										dec_bank1 <= 1'b1;
										//Bank1_to_Update
							if(u_bits_2 != 0 && u_bits_3 !=0 && u_bits_4 !=0)
								begin
									dec_bank2 <= 1'b1;
									dec_bank3 <= 1'b1;
									dec_bank4 <= 1'b1;
									Alloc <= 1'b0;
								end	
							else
								begin
									Alloc <= 1'b1;
									if(u_bits_2 == 2'b00) 
										dec_bank2 <= 1'b1;
									else
										dec_bank2 <= 1'b0;
											
									if(u_bits_3 == 2'b00 && u_bits_2 !=2'b00)
										dec_bank3 <= 1'b1;
									else
										dec_bank3 <= 1'b0;
											
									if(u_bits_4 == 2'b00 && u_bits_3 !=2'b00 && u_bits_2 !=2'b00)
										dec_bank4 <= 1'b1;
									else
										dec_bank4 <= 1'b0;
								end
						end	
			else if(prediction_bank2 == 1'b1 && prediction_bank3 != 1'b1 && prediction_bank4 != 1'b1) 
						begin
							inc_counter_bank0 <= 1'b0; inc_counter_bank1 <= 1'b0; inc_counter_bank3 <= 1'b0; inc_counter_bank4 <= 1'b0;
							dec_counter_bank0 <= 1'b0; dec_counter_bank1 <= 1'b0; dec_counter_bank3 <= 1'b0; dec_counter_bank4 <= 1'b0;
									//Branch predicted is taken,but its incorrect hence weaken it
							if(branch_pred_bank2==1'b1)	begin		//correct prediction that it is taken
                                  dec_counter_bank2 <= 1'b1;
                                  inc_counter_bank2 <= 1'b0;
                              end
                            else begin
                                dec_counter_bank2 <= 1'b0;
                                inc_counter_bank2 <= 1'b1;
                            end	
							dec_bank1<=1'b0;
							dec_bank2<=1'b1;
							//Bank2_to_Update
							if(u_bits_3 !=0 && u_bits_4 !=0)
								begin
									dec_bank3 <= 1'b1;
									dec_bank4 <= 1'b1;
									Alloc <= 1'b0;
								end	
							else
								begin
									Alloc <= 1'b1;
									if(u_bits_3 == 2'b00) 
										dec_bank3 <= 1'b1;
									else
										dec_bank3 <= 1'b0;
											
									if(u_bits_4 == 2'b00 && u_bits_3 !=2'b00)
										dec_bank4 <= 1'b1;
									else
										dec_bank4 <= 1'b0;
								end
							
						end			
			else if(prediction_bank3 == 1'b1 && prediction_bank4 != 1'b1)
						begin
							inc_counter_bank0 <= 1'b0; inc_counter_bank1 <= 1'b0; inc_counter_bank2 <= 1'b0; inc_counter_bank4 <= 1'b0;
							dec_counter_bank0 <= 1'b0; dec_counter_bank1 <= 1'b0; dec_counter_bank2 <= 1'b0; dec_counter_bank4 <= 1'b0;
							//Branch predicted is taken,but its incorrect hence weaken it
							if(branch_pred_bank3==1'b1)	begin		//correct prediction that it is taken
                                  dec_counter_bank3 <= 1'b1;
                                  inc_counter_bank3 <= 1'b0;
                              end
                            else begin
                                dec_counter_bank3 <= 1'b0;
                                inc_counter_bank3 <= 1'b1;
                            end	
							//Bank3_to_Update
										dec_bank1<=1'b0;
							dec_bank2<=1'b0;
							dec_bank3<=1'b1;
							if(u_bits_4 !=0)
								begin
									dec_bank4 <= 1'b1;
									Alloc <= 1'b0;
								end	
							else
								begin
									Alloc <= 1'b1;
									dec_bank4<=1'b1;
								end

						end
			else if(prediction_bank4 == 1'b1) 
						begin
							inc_counter_bank0 <= 1'b0; inc_counter_bank1 <= 1'b0; inc_counter_bank2 <= 1'b0; inc_counter_bank3 <= 1'b0;
							dec_counter_bank0 <= 1'b0; dec_counter_bank1 <= 1'b0; dec_counter_bank2 <= 1'b0; dec_counter_bank3 <= 1'b0;
							if(branch_pred_bank4==1'b1)	begin		//correct prediction that it is taken
                                  dec_counter_bank4 <= 1'b1;
                                  inc_counter_bank4 <= 1'b0;
                              end
                            else begin
                                dec_counter_bank4 <= 1'b0;
                                inc_counter_bank4 <= 1'b1;
                            end	
							dec_bank1 <= 1'b0; dec_bank2 <= 1'b0; dec_bank3 <= 1'b0; dec_bank4 <= 1'b1; 

						end
			
		end
		else if ((Branch_predicted == Actual_branch && update_predictor_enable==1'b1) )
		begin				//Correct Branch Prediction
				//This is for Bimodal
				Alloc<=1'b0;
				if(prediction_bank1 != 1'b1 && prediction_bank2 != 1'b1 && prediction_bank3 != 1'b1 && prediction_bank4 != 1'b1)	//this is the bimodal table
						begin
							if(branch_pred_bank0==1'b1)	begin		//correct prediction that it is taken
                                  inc_counter_bank0 <= 1'b1;
                                  dec_counter_bank0 <= 1'b0;
                              end
                            else begin
                                inc_counter_bank0 <= 1'b0;
                                dec_counter_bank0 <= 1'b1;
                            end		
						end
				else	
						begin
							inc_counter_bank0 <= 1'b0;
							dec_counter_bank0 <= 1'b0;
						end
						
				
				//This is for Table one
				if(prediction_bank1 == 1'b1 && prediction_bank2 != 1'b1 && prediction_bank3 != 1'b1 && prediction_bank4 != 1'b1 )
						begin
							inc_bank1 <= 1'b1;		//increse the usefulness of the bank tag
							dec_bank1 <= 1'b0;
							if(branch_pred_bank1==1'b1)	begin		//correct prediction that it is taken
                                  inc_counter_bank1 <= 1'b1;
                                  dec_counter_bank1 <= 1'b0;
                              end
                            else begin
                                inc_counter_bank1 <= 1'b0;
                                dec_counter_bank1 <= 1'b1;
                            end	
						end
				else if(prediction_bank1 == 1'b1 && (prediction_bank2 == 1'b1 || prediction_bank3 == 1'b1 || prediction_bank4 == 1'b1)) begin
							inc_counter_bank1<=1'b0;
							dec_counter_bank1 <= 1'b0;
							//Counter_Update(branch_pred_bank1,inc_bank1,dec_bank1);		//When incorrect or correct prediction is made by the alternative predictor that wont be used
							if(branch_pred_bank1==Branch_predicted)	begin		
                                  inc_bank1 <= 1'b1;
                                  dec_bank1 <= 1'b0;
                              end
                            else begin
                                inc_bank1 <= 1'b0;
                                dec_bank1 <= 1'b1;
                            end	
					end
				else begin
							inc_counter_bank1 <= 1'b0;
							dec_counter_bank1 <= 1'b0;
							inc_bank1 <= 1'b0;
							dec_bank1 <=1'b0;
				end
					
					
					
				//This is for table two	
				if(prediction_bank2 == 1'b1 && prediction_bank3 != 1'b1 && prediction_bank4 != 1'b1) 
						begin
							inc_bank2 <= 1'b1;
							dec_bank2<=1'b0;
							if(branch_pred_bank2==1'b1)	begin		//correct prediction that it is taken
                                  inc_counter_bank2 <= 1'b1;
                                  dec_counter_bank2 <= 1'b0;
                              end
                            else begin
                                inc_counter_bank2 <= 1'b0;
                                dec_counter_bank2 <= 1'b1;
                            end	
						end
				else if(prediction_bank2 == 1'b1 && (prediction_bank3 == 1'b1 || prediction_bank4 == 1'b1))
						begin
							inc_counter_bank2<=1'b0;
							dec_counter_bank2 <= 1'b0;
							//Counter_Update(branch_pred_bank2,inc_bank2,dec_bank2);		//When incorrect or correct prediction is made by the alternative predictor that wont be used
							if(branch_pred_bank2==Branch_predicted)	begin		
                                  inc_bank2 <= 1'b1;
                                  dec_bank2 <= 1'b0;
                              end
                            else begin
                                inc_bank2 <= 1'b0;
                                dec_bank2 <= 1'b1;
                            end						
						end
				else begin
							inc_counter_bank2 <= 1'b0;
							dec_counter_bank2 <= 1'b0;
							inc_bank2 <= 1'b0;
							dec_bank2 <=1'b0;
				end					
					
				//This is for Table 3	
				if(prediction_bank3 == 1'b1 && prediction_bank4 != 1'b1)
						begin
							inc_bank3 <= 1'b1;
							dec_bank3<=1'b0;
							if(branch_pred_bank3==1'b1)	begin		//correct prediction that it is taken
                                  inc_counter_bank3 <= 1'b1;
                                  dec_counter_bank3 <= 1'b0;
                              end
                            else begin
                                inc_counter_bank3 <= 1'b0;
                                dec_counter_bank3 <= 1'b1;
                            end	
						end
				else if(prediction_bank3 == 1'b1 && (prediction_bank4 == 1'b1))
						begin
							inc_counter_bank3<=1'b0;
							dec_counter_bank3 <= 1'b0;
							//Counter_Update(branch_pred_bank3,inc_bank3,dec_bank3);		//When incorrect or correct prediction is made by the alternative predictor that wont be used
							if(branch_pred_bank3==Branch_predicted)	begin		
                                  inc_bank3 <= 1'b1;
                                  dec_bank3 <= 1'b0;
                              end
                            else begin
                                inc_bank3 <= 1'b0;
                                dec_bank3 <= 1'b1;
                            end						
						end
				else begin
							inc_counter_bank3 <= 1'b0;
							dec_counter_bank3 <= 1'b0;
							inc_bank3 <= 1'b0;
							dec_bank3 <=1'b0;
				end								
				
				//this is for table 4
				if(prediction_bank4 == 1'b1) 
						begin
							inc_bank4 <= 1'b1;
							dec_bank4<=1'b0;
							if(branch_pred_bank4==1'b1)	begin		//correct prediction that it is taken
                                  inc_counter_bank4 <= 1'b1;
                                  dec_counter_bank4 <= 1'b0;
                              end
                            else begin
                                inc_counter_bank4 <= 1'b0;
                                dec_counter_bank4 <= 1'b1;
                            end						
						end
				else begin
							inc_counter_bank4 <= 1'b0;
							dec_counter_bank4 <= 1'b0;
							inc_bank4 <= 1'b0;
							dec_bank4 <=1'b0;
				end						
				
					
			end
	
		else begin
				inc_counter_bank0 <= 1'b0; inc_counter_bank1 <= 1'b0; inc_counter_bank2 <= 1'b0; inc_counter_bank3 <= 1'b0; inc_counter_bank4 <= 1'b0;
				dec_counter_bank0 <= 1'b0; dec_counter_bank1 <= 1'b0; dec_counter_bank2 <= 1'b0; dec_counter_bank3 <= 1'b0; dec_counter_bank4 <= 1'b0;
				dec_bank1 <= 1'b0; dec_bank2 <= 1'b0; dec_bank3 <= 1'b0; dec_bank4 <= 1'b0; 
				inc_bank1 <= 1'b0; inc_bank2 <= 1'b0; inc_bank3 <= 1'b0; inc_bank4 <= 1'b0; 
				Alloc<=1'b0;
				
		end
	end
endmodule


















