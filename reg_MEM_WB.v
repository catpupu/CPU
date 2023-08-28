module reg_MEM_WB( opcode, funct, clk, rst, regWrite, memtoReg, dataMemrd, ALU_result, WN,
                   opcode_out, funct_out, regWrite_out, memtoReg_out, dataMemrd_out, ALU_result_out, WN_out) ;
    input clk, rst, regWrite, memtoReg ;
    input [4:0] WN;
    input [31:0] dataMemrd, ALU_result; 
  input[5:0] funct, opcode;
    output regWrite_out, memtoReg_out ;
    output [4:0] WN_out ;
    output [31:0] dataMemrd_out, ALU_result_out ;
  output reg [5:0] funct_out, opcode_out;
    reg  regWrite_out, memtoReg_out ;
    reg [4:0] WN_out ;
    reg [31:0] dataMemrd_out, ALU_result_out ;

    always@(posedge clk )begin
        if ( rst ) begin
          opcode_out <= 5'd0;
          funct_out <= 5'd0;
            regWrite_out <= 0;
            memtoReg_out <= 0; 
            dataMemrd_out <= 32'd0;
            ALU_result_out <= 32'd0;
            WN_out <= 5'd0;
        end 
        else begin
          opcode_out <= opcode;
            funct_out <= funct;
            regWrite_out <= regWrite;
            memtoReg_out <= memtoReg;
            dataMemrd_out <= dataMemrd;
            ALU_result_out <= ALU_result;
            WN_out <= WN;
        end
    end // always
  
    
endmodule