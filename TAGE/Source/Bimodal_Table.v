`timescale 1ns / 1ps

module 	Bimodal_Table(Clk, wr, rd, index/*pc*/, rdata_c_bits, correct_prediction, inc_counter, dec_counter,update_enable);
   
	parameter IL=13;	//Index size ie number of addresses
	parameter CL=3;		//Counter length

	reg [ CL-1 : 0 ] c_bits[(1 << IL) - 1 : 0];		//Counter table
	
	output [ CL-1 : 0 ] rdata_c_bits;
	reg [ CL-1 : 0 ] rdata_c_bits_reg;
	input [IL - 1 : 0]index;
	input Clk,rd,wr;
    input correct_prediction;
	input inc_counter;
	input dec_counter;
	input update_enable;

    integer i, j;
   
    initial
    begin
      for (i = 0; i < (1<<IL); i = i+1)
			begin	
				c_bits[i] = {CL{1'b0}};		//initialize the bits
			end
	end
   
   // Keep addr and write data
   
  always @(posedge Clk)
	begin
		    if (inc_counter==1'b1 && update_enable==1'b1 && c_bits[index]!= {CL{1'b1}})
				begin
						c_bits[index]<=c_bits[index] + 1'b1;
				end
			else if(dec_counter==1'b1 && update_enable==1'b1 && c_bits[index]!= {CL{1'b0}})
				begin	
						c_bits[index]<=c_bits[index] - 1'b1;
				end
			else
				begin
						c_bits[index]<=c_bits[index];
				end
					
	end


  //
  // Read process
  // ------------


  always @(posedge Clk)
	begin
		if (rd)
			begin
				rdata_c_bits_reg <= c_bits[index];
			end
		else
			begin
				rdata_c_bits_reg <= {CL{1'bX}};
			end
	end
		
  assign rdata_c_bits = rdata_c_bits_reg;
	
endmodule

