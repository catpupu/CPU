module ALU( ctl, a, b, result, zero );

    input [2:0]   ctl ;
    input [31:0]  a, b ;

    output [31:0] result ;
    output zero ;

    wire [31:0] c, ALUOut, ShifterOut;
    wire inv;
    
    parameter ALU_sll = 3'b011;
    parameter ALU_add = 3'b010;
    parameter ALU_sub = 3'b110;
    parameter ALU_and = 3'b000;
    parameter ALU_or = 3'b001;
    parameter ALU_slt = 3'b111;
    
    assign inv = (ctl == ALU_sub || ctl == ALU_slt);
    
    genvar i;
    ALU_Slice slice( .a(a[0]), .b(b[0]), .cin(inv), .cout(c[0]), .ctl(ctl), .out(ALUOut[0]), .inv(inv) );
    for(i = 1 ; i<32 ; i=i+1)
        ALU_Slice slice( .a(a[i]), .b(b[i]), .cin(c[i-1]), .cout(c[i]), .ctl(ctl), .out(ALUOut[i]), .inv(inv) );

    Shifter shifter( .a(a), .b(b), .result(ShifterOut) );

    assign result = ( ctl == ALU_sll ? ShifterOut :
                      ctl == ALU_slt ? {31'b0, ALUOut[31]} : ALUOut); 

    assign zero = (result == 32'b0);
endmodule