`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2017 03:21:16 PM
// Design Name: 
// Module Name: Comparator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Index_Tag_Generator(CLK,reset,ghist,pc_addr, Index_bank1,Index_bank2,
							Index_bank3, Index_bank4,
							Comp_tag_bank1, Comp_tag_bank2, Comp_tag_bank3
							,Comp_tag_bank4, index_tag_enable);
							
	//parameter HistLen_Bank1=8;
	//parameter HistLen_Bank2=15;
	//parameter HistLen_Bank3=44;
	//parameter HistLen_Bank4=130;
	
	parameter GlobLen=131;	//This is the global history length
	
	//parameter OutLen1=0 ; 	//this is the length that will be thrown out at the end and wont be used...HistLen%OutLen
	//parameter OutLen2=7 ;
	//parameter OutLen3=4 ;
	//parameter OutLen4=2;
	parameter ADDRESS_SIZE=32;	//length of the program counter
	parameter tag_len=8;	//length of the tag used
	parameter IL=10;		//Index size ie number of addresses...this is like the compressed length

							
	input CLK,reset;
	input [GlobLen-1:0] ghist;
	input [ADDRESS_SIZE - 1:0] pc_addr;
	input index_tag_enable;
	
	output reg [tag_len-1 : 0] Comp_tag_bank1, Comp_tag_bank2;
	output reg [tag_len : 0] Comp_tag_bank3, Comp_tag_bank4;
	output reg [IL-1 : 0] Index_bank1, Index_bank2, Index_bank3, Index_bank4;
	
		always @(posedge CLK) begin
		if(reset==1'b0)begin
			Comp_tag_bank1<={tag_len{1'b0}};
			Comp_tag_bank2<={tag_len{1'b0}};
			Comp_tag_bank3<={9{1'b0}};
			Comp_tag_bank4<={9{1'b0}};
			Index_bank1<={IL{1'b0}};
			Index_bank2<={IL{1'b0}};
			Index_bank3<={IL{1'b0}};
			Index_bank4<={IL{1'b0}};
			
		end
		else if(index_tag_enable==1'b1) begin
			//compute index
			//This is for Index size 10
			Index_bank1<=(pc_addr[9:0])^(pc_addr[19:10])^(pc_addr[29:20])^({2'b00,{ghist[7:0]}});
			Index_bank2<=(pc_addr[9:0])^(pc_addr[19:10])^(pc_addr[29:20])^(ghist[9:0])^({5'b0000,{ghist[14:10]}});
			Index_bank3<=(pc_addr[9:0])^(pc_addr[19:10])^(pc_addr[29:20])^(ghist[9:0])^(ghist[19:10])^(ghist[29:20])^(ghist[39:30])^({6'b000000,{ghist[43:40]}});
			Index_bank4<=(pc_addr[9:0])^(pc_addr[19:10])^(pc_addr[29:20])^(ghist[9:0])^(ghist[19:10])^(ghist[29:20])^(ghist[39:30])
							^(ghist[49:40])^(ghist[59:50])^(ghist[69:60])^(ghist[79:70])^(ghist[89:80])^(ghist[99:90])^(ghist[109:100])
							^(ghist[119:110])^(ghist[129:120]); 
							 
			/*
			//This is for Index Size 8
			Index_bank1<=(pc_addr[7:0])^(pc_addr[15:8])^(pc_addr[23:16])^(pc_addr[31:24])^(ghist[7:0]);
			Index_bank2<=(pc_addr[7:0])^(pc_addr[15:8])^(pc_addr[23:16])^(pc_addr[31:24])^(ghist[7:0])
							^({1'b0,ghist[14:8]});
			Index_bank3<=(pc_addr[7:0])^(pc_addr[15:8])^(pc_addr[23:16])^(pc_addr[31:24])^(ghist[7:0])
							^(ghist[15:8])^(ghist[23:16])^(ghist[31:24])^(ghist[39:32])^({4'h0,ghist[43:40]});
			Index_bank4<=(pc_addr[7:0])^(pc_addr[15:8])^(pc_addr[23:16])^(pc_addr[31:24])^(ghist[7:0])
							^(ghist[15:8])^(ghist[23:16])^(ghist[31:24])^(ghist[39:32])				
							^(ghist[47:40])^(ghist[55:48])^(ghist[63:56])^(ghist[71:64])^(ghist[79:72])
							^(ghist[87:80])^(ghist[95:88])^(ghist[103:96])^(ghist[111:104])^(ghist[119:112])
							^(ghist[127:120])^({6'b000000,ghist[129:128]});
			*/
			//Compute tag
			/*
			Comp_tag_bank1<=ghist[7:0];
			Comp_tag_bank2<=(ghist[7:0])^({1'b0,ghist[14:8]});
			Comp_tag_bank3<=(ghist[7:0])^(ghist[15:8])^(ghist[23:16])^(ghist[31:24])^(ghist[39:32])^({4'b0000,ghist[43:40]});
			Comp_tag_bank4<=(ghist[7:0])^(ghist[15:8])^(ghist[23:16])^(ghist[31:24])^(ghist[39:32])^(ghist[47:40])^(ghist[55:48])
							^(ghist[63:56])^(ghist[71:64])^(ghist[79:72])^(ghist[87:80])^(ghist[95:88])^(ghist[103:96])^(ghist[111:104])
							^(ghist[119:112])^(ghist[127:120])^({6'b000000,ghist[129:128]});
		
            Comp_tag_bank1<=(pc_addr[7:0])^ghist[7:0];
            Comp_tag_bank2<=(pc_addr[7:0])^(ghist[7:0])^({1'b0,ghist[14:8]});
            Comp_tag_bank3<=(pc_addr[7:0])^(ghist[7:0])^(ghist[15:8])^(ghist[23:16])^(ghist[31:24])^(ghist[39:32])^({4'b0000,ghist[43:40]});
            Comp_tag_bank4<=(pc_addr[7:0])^(ghist[7:0])^(ghist[15:8])^(ghist[23:16])^(ghist[31:24])^(ghist[39:32])^(ghist[47:40])^(ghist[55:48])
                            ^(ghist[63:56])^(ghist[71:64])^(ghist[79:72])^(ghist[87:80])^(ghist[95:88])^(ghist[103:96])^(ghist[111:104])
                            ^(ghist[119:112])^(ghist[127:120])^({6'b000000,ghist[129:128]});
		
		
		*/
		/*
		    Comp_tag_bank1<=(pc_addr[7:0])^ghist[7:0] ^({ghist[6:0],1'b0});
            Comp_tag_bank2<=(pc_addr[7:0])^(ghist[7:0])^({1'b0,ghist[14:8]})^({ghist[6:0],1'b0})^({ghist[13:7],1'b0});
            Comp_tag_bank3<=(pc_addr[8:0])^(ghist[8:0])^(ghist[17:9])^(ghist[26:18])^(ghist[35:27])^({1'b0,ghist[43:36]})
							^({ghist[7:0],1'b0})^({ghist[15:8],1'b0})^({ghist[23:16],1'b0})^({ghist[31:24],1'b0})
							^({ghist[39:32],1'b0})^({4'h0,ghist[43:40],1'b0});
            Comp_tag_bank4<=(pc_addr[8:0])^(ghist[8:0])^(ghist[17:9])^(ghist[26:18])^(ghist[35:27])^(ghist[44:36])^(ghist[53:45])
                            ^(ghist[62:54])^(ghist[71:63])^(ghist[80:72])^(ghist[89:81])^(ghist[98:90])^(ghist[107:99])^(ghist[116:108])
                            ^(ghist[125:117])^({5'b0,ghist[129:126]})
							^({ghist[7:0],1'b0})^({ghist[15:8],1'b0})^({ghist[23:16],1'b0})^({ghist[31:24],1'b0})^({ghist[39:32],1'b0})
							^({ghist[47:40],1'b0})^({ghist[55:48],1'b0})^({ghist[63:56],1'b0})^({ghist[71:64],1'b0})^({ghist[79:72],1'b0})
							^({ghist[87:80],1'b0})^({ghist[95:88],1'b0})^({ghist[103:96],1'b0})^({ghist[111:104],1'b0})^({ghist[119:112],1'b0})
							^({ghist[127:120],1'b0})^({6'b000000,ghist[129:128],1'b0});
							*/
			 Comp_tag_bank1<=(pc_addr[4:0])^(ghist[4:0]) ^({ghist[3:0],1'b0});
			 Comp_tag_bank2<=(pc_addr[4:0])^(ghist[4:0])^(ghist[9:5])^(ghist[14:10])^({ghist[3:0],1'b0})^({ghist[7:4],1'b0})^({ghist[11:8],1'b0})^({1'b0,ghist[14:12],1'b0});
			 Comp_tag_bank3<=(pc_addr[4:0])^(ghist[4:0])^(ghist[9:5])^(ghist[14:10])^(ghist[19:15])^(ghist[24:20])^
							(ghist[29:25])^(ghist[34:30])^(ghist[39:35])^(ghist[44:40])
							^({ghist[3:0],1'b0})^({ghist[7:4],1'b0})^({ghist[11:8],1'b0})^({ghist[15:12],1'b0})^({ghist[19:16],1'b0})
							^({ghist[23:20],1'b0})^({ghist[27:24],1'b0})^({ghist[31:28],1'b0})^({ghist[35:32],1'b0})
							^({ghist[39:36],1'b0})^({ghist[43:40],1'b0});
			 Comp_tag_bank4<=(pc_addr[4:0])^(ghist[4:0])^(ghist[9:5])^(ghist[14:10])^(ghist[19:15])^(ghist[24:20])^
							(ghist[29:25])^(ghist[34:30])^(ghist[39:35])^(ghist[44:40])
							^(ghist[49:45])^(ghist[54:50])^(ghist[59:55])^(ghist[64:60])^(ghist[69:65])
							^(ghist[74:70])^(ghist[79:75])^(ghist[84:80])^(ghist[89:85])^(ghist[94:90])
							^(ghist[99:95])^(ghist[104:100])^(ghist[109:105])^(ghist[114:110])^(ghist[119:115])
							^(ghist[124:120])^(ghist[129:125])^({ghist[3:0],1'b0})^({ghist[7:4],1'b0})^({ghist[11:8],1'b0})^({ghist[15:12],1'b0})^({ghist[19:16],1'b0})
							^({ghist[23:20],1'b0})^({ghist[27:24],1'b0})^({ghist[31:28],1'b0})^({ghist[35:32],1'b0})
							^({ghist[39:36],1'b0})^({ghist[43:40],1'b0})^({ghist[47:44],1'b0})^({ghist[51:48],1'b0})^
							({ghist[55:52],1'b0})^({ghist[59:56],1'b0})^({ghist[63:60],1'b0})^({ghist[67:64],1'b0})^
							({ghist[71:68],1'b0})^({ghist[75:72],1'b0})^({ghist[79:76],1'b0})^({ghist[83:80],1'b0})^({ghist[87:84],1'b0})^
							({ghist[91:88],1'b0})^({ghist[95:92],1'b0})^({ghist[99:96],1'b0})^({ghist[103:100],1'b0})^
							({ghist[107:104],1'b0})^({ghist[111:108],1'b0})^({ghist[115:112],1'b0})^({ghist[119:116],1'b0})
							^({ghist[123:120],1'b0})^({ghist[127:124],1'b0})^({2'b00,ghist[129:128],1'b0})	;						
									
		
		end
		else begin
			Index_bank2<=Index_bank1;
			Index_bank2<=Index_bank2;
			Index_bank3<=Index_bank3;
			Index_bank4<=Index_bank4;
			Comp_tag_bank1<=Comp_tag_bank1;
			Comp_tag_bank2<=Comp_tag_bank2;
			Comp_tag_bank3<=Comp_tag_bank3;
			Comp_tag_bank4<=Comp_tag_bank4;
		end

		
	end
	
endmodule