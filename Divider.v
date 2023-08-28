module Divider( clk, rst, a, b, result );

    input  clk, rst ;
    input  [31:0] a ;
    input  [31:0] b ;
    output [63:0] result ;

    reg [63:0] REM;
    reg [63:0] div;
    reg [6:0]  counter;

    always @( posedge clk or rst ) begin
        if ( rst ) begin
            REM = {31'b0, a, 1'b0};
            div = b;
            counter = 33;
        end

        if ( counter > 1 ) begin
            REM[63:32] = REM[63:32] - div;
            REM[0] = ~REM[63];
            if(REM[63] == 1)
                REM[63:32] = REM[63:32] + div;
            
            REM = REM << 1;
            counter = counter-1;
        end
        else if ( counter == 1 ) begin
            REM <= (REM >> 1);
            counter = 0;
        end
    end

    assign result = REM;

endmodule