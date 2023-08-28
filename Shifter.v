`timescale 1ns/1ns
module Shifter( a, b, result );
    input [31:0] a, b;
    output [31:0] result;    // out = num<<shift

    wire[31:0] w[0:5];
    
    assign w[0] = a;

    genvar i, j;
    for( i = 0 ; i < 5 ; i = i + 1 ) begin
        for( j = 2**i-1 ; j >= 0 ; j = j - 1 ) // 控前面歸零的 2^0, 2^1....2^4
            mux2x1 mux( .a(1'b0), .b(w[i][j]), .out(w[i+1][j]), .sel(b[i]) );

        for( j = 2**i ; j < 32 ; j = j + 1 )
            mux2x1 mux( .a(w[i][j-2**i]), .b(w[i][j]), .out(w[i+1][j]), .sel(b[i]) );
    end
    assign result = w[5] ; // 想要把最終答案 copy 進 out 裡面 

endmodule