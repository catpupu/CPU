`timescale 1ns/1ns
module mux2x1( a, b, out, sel );
    input a, b, sel;
    output out;
    
    assign out = sel ? a : b;
endmodule