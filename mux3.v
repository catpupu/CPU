module mux3( sel, a, b, c, out );
    parameter bitwidth = 32 ;
    input  [1:0]  sel; 
    input  [bitwidth-1:0] a, b, c;
    output [bitwidth-1:0] out;
    
    assign out = sel == 0 ? a : sel == 1 ? b : c;
endmodule