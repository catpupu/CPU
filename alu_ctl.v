module alu_ctl(ALUOp, Funct, ALUOperation, DIVU, ALUSEL);
    input  [1:0] ALUOp;
    input  [5:0] Funct;
    output reg DIVU;
    output reg [1:0] ALUSEL;
    output reg [2:0] ALUOperation;

    parameter F_sll = 6'd0;
    parameter F_mfhi = 6'd10;
    parameter F_mflo = 6'd12;
    parameter F_divu = 6'd27;
    parameter F_add = 6'd32;
    parameter F_sub = 6'd34;
    parameter F_and = 6'd36;
    parameter F_or = 6'd37;
    parameter F_slt = 6'd42;

    parameter ALU_sll = 3'b011;
    parameter ALU_add = 3'b010;
    parameter ALU_sub = 3'b110;
    parameter ALU_and = 3'b000;
    parameter ALU_or = 3'b001;
    parameter ALU_slt = 3'b111;

    always @(ALUOp or Funct) begin
        ALUSEL = 2;
        case (ALUOp)
        2'b00 : ALUOperation = ALU_add;
        2'b01 : ALUOperation = ALU_sub;
        2'b11 : ALUOperation = ALU_or ;
        2'b10 : case (Funct)
                F_sll : ALUOperation = ALU_sll;
                F_add : ALUOperation = ALU_add;
                F_sub : ALUOperation = ALU_sub;
                F_and : ALUOperation = ALU_and;
                F_or : ALUOperation = ALU_or;
                F_slt : ALUOperation = ALU_slt;
                F_divu: DIVU = 1;
                F_mfhi: ALUSEL = 0;
                F_mflo: ALUSEL = 1;
                default : ALUOperation = 3'bxxx;
                endcase
        default ALUOperation = 3'bxxx;
        endcase
    end

endmodule