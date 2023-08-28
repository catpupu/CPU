module mux2( sel, a, b, out );
    parameter bitwidth = 32 ;
    input  sel; 
    input  [bitwidth-1:0] a, b;
    output [bitwidth-1:0] out;
    
    assign out = sel ? a : b;
endmodule