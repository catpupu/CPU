module Hazard( clk, rst, stay, instr, instr_out );
	input clk, rst;
    input [31:0] instr;
    
    output reg [31:0] instr_out;
    output reg stay;
    
    reg pass;
    reg [5:0] counter;
    
    wire [5:0] opcode;
    wire [5:0] funct;
    
  	assign opcode = instr[31:26];
   	assign funct = instr[5:0];
    
	parameter instr_NOP = 32'hFFFFFFFF;
    
  /**
    parameter R_FORMAT = 6'd0;
    parameter LW = 6'd35;
    parameter SW = 6'd43;
    parameter BEQ = 6'd4;
    parameter BNE = 6'd5;    
    parameter ORI = 6'd13;
	parameter J = 6'd2;
	parameter NOP = 6'd63;
*/

    initial begin
        pass = 1'b1;
        counter = 6'd0;
    end

    always @( instr ) begin
        if (pass) begin
            instr_out = instr;

            if(opcode==6'd2) begin // J
                counter = 6'd3;
                pass = 1'b0;
            end
            else if(opcode==6'd4) begin  //  beq
                counter = 6'd3;
                pass = 1'b0;
            end
            else if(opcode==6'd5) begin  //  bne
                counter = 6'd3;
                pass = 1'b0;
            end
            else if(opcode==6'd0 && funct==6'd27) begin // R format : divu
                counter = 6'd34;
                pass = 1'b0;
            end
            else if(opcode==6'd0) begin // R format
                counter = 6'd3;
                pass = 1'b0;
            end
        end

        stay = (counter != 6'd0);
    end

	always @( posedge clk ) begin
        if (counter != 6'd0) begin
            instr_out = instr_NOP;
            counter = counter - 1;
        end
        else begin
            instr_out = instr;
            pass = 1'b1;
        end
        
        stay = (counter != 6'd0);
	end


endmodule