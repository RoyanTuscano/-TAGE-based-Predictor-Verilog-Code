`timescale 1ns / 1ps
//This is the TAGE precitor component or table.. hear  you modify and update the TAG bits, Useful bits and predictor bits
module TAGE_Table(Clk, wr, rd, index, rdata_tag_bits, rdata_u_bits, rdata_c_bits, wdata_tag_bits,
					correct_prediction, inc_u_bit,dec_u_bit, inc_c_bit, dec_c_bit, alloc,update_enable);
   
	parameter IL=10;	//Index size ie number of addresses
	parameter tag_len=8;	//Tag length
	parameter UL=2;		//Useful length
	parameter CL=3;		//Counter length

    
	reg [ tag_len-1 : 0 ] tag_bits[(1 << IL) - 1 : 0];	//tag table 
	reg [ UL-1 : 0 ] u_bits[(1 << IL) - 1 : 0];		//Useful table
	reg [ CL-1 : 0 ] c_bits[(1 << IL) - 1 : 0];		//Counter table
	reg[CL-1:0] rdata_c_bits_reg;
	reg[UL-1:0] rdata_u_bits_reg;
	reg [ tag_len-1 : 0 ] rdata_tag_bits_reg;
	output [ tag_len-1 : 0 ] rdata_tag_bits;
	output [ UL-1 : 0 ] rdata_u_bits;
	output [ CL-1 : 0 ] rdata_c_bits;
	
	input [ tag_len-1 : 0 ] wdata_tag_bits;
	input [IL - 1 : 0]index;
	input Clk,rd,wr;
    input correct_prediction;
	input inc_u_bit,dec_u_bit;
	input inc_c_bit, dec_c_bit;
	input alloc;
	input update_enable;

    integer i;
   
    initial
    begin
      for (i = 0; i < (1<<IL); i = i+1)
			begin
				tag_bits[i] = {tag_len{1'b0}};		//initialize the bits
				u_bits[i] =	{UL{1'b0}};	
				c_bits[i] = {CL{1'b0}};
			end
	end
   
   // Keep addr and write data
  always @(posedge Clk)
	begin
		//update useful bits
			if(alloc==1'b0 && inc_c_bit==1'b1 && update_enable==1'b1 && c_bits[index]!= {CL{1'b1}})
				c_bits[index]<=c_bits[index] + 1;
			else if(alloc==1'b0 && dec_c_bit==1'b1 && update_enable==1'b1 && c_bits[index]!= {CL{1'b0}})
				c_bits[index]<=c_bits[index] - 1;
			else
				c_bits[index]<=c_bits[index];
				
		//update counter bits
			if(inc_u_bit==1'b1 && update_enable==1'b1 && u_bits[index]!={UL{1'b1}})
				u_bits[index]<=u_bits[index]+1;
			else if(dec_u_bit==1'b1 && update_enable==1'b1 && u_bits[index]!={UL{1'b0}})
				u_bits[index]<=u_bits[index]-1;
			else
				u_bits[index]<=u_bits[index];
				
		//update the tags

			if(alloc==1'b1 && dec_u_bit==1'b1 && update_enable==1'b1)
				tag_bits[index]<=wdata_tag_bits;
			else
				tag_bits[index]<=tag_bits[index];
					
	end


  //
  // Read process
  // ------------


  always @(posedge Clk)
	begin
		if (rd)
			begin
				rdata_tag_bits_reg <= tag_bits[index];
				rdata_u_bits_reg <= u_bits[index];
				rdata_c_bits_reg <= c_bits[index];
			end
		else
			begin
				rdata_tag_bits_reg <= {tag_len{1'bX}};
				rdata_u_bits_reg <= {UL{1'bX}};
				rdata_c_bits_reg <= {CL{1'bX}};
			end
	end
		
  assign rdata_tag_bits = rdata_tag_bits_reg;
  assign rdata_u_bits = rdata_u_bits_reg;
  assign rdata_c_bits = rdata_c_bits_reg;
	

endmodule
/*
always @(posedge clk)
	begin
		    if (wr && correct_prediction)
				begin
					tag_bits[index]<=new_tag_bits;
					if(branch_taken || c_bits[index] !=3'b111)
						c_bits[index]<=c_bits[index] + 1;
					else if(~branch_taken || c_bits[index] !=3'b000)
						c_bits[index]<=c_bits[index] - 1;
					else
						c_bits[index]<=c_bits[index];
					
					if(u_bits !=2'b11)
						u_bits[index]<=u_bits[index]+1;
					else	
						u_bits[index]<=u_bits[index];
				end
			else if(wr && ~correct_prediction)
				begin	
					tag_bits[index]<=new_tag_bits;
					if(branch_taken || c_bits[index] !=3'b000)		//branch_taken is predicted but since its wrong we decrement the c bit
						c_bits[index]<=c_bits[index] - 1'b1;
					else if(~branch_taken || c_bits[index] !=3'b111)	//branch not taken is predicted but since its wrong we increment the c bit
						c_bits[index]<=c_bits[index] + 1'b1;
					else
						c_bits[index]<=c_bits[index];
					
					if(u_bits !=2'b00)
						u_bits[index]<=u_bits[index]-1;
					else	
						u_bits[index]<=u_bits[index];
				end
					
	end

*/
