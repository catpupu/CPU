module reg_ID_EX( opcode, clk, rst, RegDst, ALUSrc, ALUOp, MemRead, MemWrite, Branch, MemtoReg, RegWrite, bne,
                  rfile_rd1, rfile_rd2, ext_immed, rt, rd, pc_incr,
                   opcode_out, RegDst_out, ALUSrc_out, ALUOp_out, MemRead_out, MemWrite_out, Branch_out, MemtoReg_out,RegWrite_out, bne_out,
                  rfile_rd1_out , rfile_rd2_out, ext_immed_out, rt_out, rd_out, pc_incr_out );
  // immed 32 bit => 6bit func, 26bit offset
  input clk, rst, RegDst, ALUSrc, MemRead, MemWrite, Branch, MemtoReg, RegWrite, bne;
  input [1:0]  ALUOp;
  input [4:0]  rt, rd ;
  input [31:0] ext_immed, rfile_rd1, rfile_rd2, pc_incr ; // ID_instr = PC+4
  input[5:0] opcode;
  output reg [5:0] opcode_out;
  output reg RegDst_out, ALUSrc_out, MemRead_out, MemWrite_out, Branch_out, MemtoReg_out, RegWrite_out, bne_out; // output 多加reg 
  output reg [1:0]  ALUOp_out;
  output reg [4:0] rt_out, rd_out ;
  output reg [31:0] ext_immed_out, rfile_rd1_out, rfile_rd2_out, pc_incr_out ;

    always @(posedge clk) begin
		if (rst) begin
 
			pc_incr_out <= 32'd0;
      opcode_out <= 6'd0;
            RegDst_out <= RegDst;
            ALUSrc_out <= 0;
            ALUOp_out <= 2'd0;
            MemWrite_out <=0;
            Branch_out <= 0;
            MemRead_out <= 0;
            MemtoReg_out <= 0;
            RegWrite_out <= 0;
            ext_immed_out <= 32;
            rt_out <= 5'd0;
            rd_out <= 5'd0;
            rfile_rd1_out <= 32'd0;
            rfile_rd2_out <= 32'd0;
            bne_out <= 1'd0;
		end
        else begin
  opcode_out <= opcode;
            RegDst_out <= RegDst;
            ALUSrc_out <= ALUSrc;
            ALUOp_out <= ALUOp;
            MemRead_out <= MemRead;
            MemWrite_out <= MemWrite;
            Branch_out <= Branch;
            MemtoReg_out <= MemtoReg;
            RegWrite_out <= RegWrite;
            ext_immed_out <= ext_immed;
            rt_out <= rt;
            rd_out <= rd;
            rfile_rd1_out <= rfile_rd1;
            rfile_rd2_out <= rfile_rd2;
            pc_incr_out <= pc_incr; // this
            bne_out = bne;
        end
		
	end

endmodule