module reg_EX_MEM( opcode, funct, clk,reset, 
                   RW, MtoR, MR, MW, Branch, bne, // cin
                   ext_immed, zero, aluANS, rd2, WN,b_tgt,  // din
                   opcode_out, funct_out, RW_out, MtoR_out, MR_out, MW_out, Branch_out, bne_out, // cout
                   ext_immed_out, zero_out, aluANS_out, rd2_out, WN_out, b_tgt_out ); // dout
  // 
  
	input  clk,reset, bne;
	input RW, MtoR, MR, MW, Branch ;
  input[31:0] ext_immed, aluANS, rd2, b_tgt ;
  input[4:0] WN;
  input[5:0] funct, opcode ;
	input zero;
  output reg [5:0] funct_out, opcode_out ;
	output  RW_out, MtoR_out, MR_out, MW_out, Branch_out, bne_out;
    output[31:0] ext_immed_out, aluANS_out, rd2_out, b_tgt_out ;
    output[4:0] WN_out;
	output zero_out;

	reg  RW_out, MtoR_out, MR_out, MW_out, Branch_out;
	reg[31:0] ext_immed_out, aluANS_out, rd2_out, b_tgt_out;
  reg[4:0] WN_out;
  reg zero_out, bne_out ; // 多這個(bne_out

    always @( posedge clk ) begin // MEM_B ??
        opcode_out <= 5'd0;
        if(reset) begin
      funct_out <= 5'd0;
			ext_immed_out <=32'd0;
			zero_out <=1'd0;
			aluANS_out <=32'd0;
			rd2_out <=32'd0;
			WN_out <=5'd0;
			RW_out <=1'd0;
			MtoR_out <=1'd0;
			MR_out <=1'd0;
			MW_out <=1'd0;
            Branch_out <= 32'd0;
            bne_out <= 1'd0;
            b_tgt_out <= 1'd0;
		end
		else begin
      opcode_out <= opcode;
      funct_out <= funct;
			ext_immed_out<= ext_immed;
			zero_out<=zero;
			aluANS_out<=aluANS;
			rd2_out<=rd2;
			WN_out<=WN;
			RW_out<=RW;
			MtoR_out<=MtoR;
			MR_out<=MR;
			MW_out<=MW;
			Branch_out<=Branch;
            bne_out <= bne;
            b_tgt_out <= b_tgt;
		end

	end

endmodule

  