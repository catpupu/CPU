module HiLo( clk, DivAns, HiOut, LoOut );

    input clk ;
    input [63:0] DivAns ;
    output [31:0] HiOut, LoOut ;
    reg [63:0] REM;
    
    always@( posedge clk )
        REM = DivAns;

    assign HiOut = REM[63:32];
    assign LoOut = REM[31:0];
  
endmodule