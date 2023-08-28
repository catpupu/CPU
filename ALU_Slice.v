module ALU_Slice( a, b, cin, cout, inv, ctl, out );

    input a, b, cin, inv;
    input [2:0] ctl;
    output cout, out;

    wire and_out, or_out, fa_out;
    wire bx, e1, e2, e3;
    
    parameter ALU_add = 3'b010;
    parameter ALU_sub = 3'b110;
    parameter ALU_and = 3'b000;
    parameter ALU_or = 3'b001;
    parameter ALU_slt = 3'b111;
    
    and (and_out, a, b);
    or (or_out, a, b);
    xor (bx, b, inv);
    
    // Full Adder
    xor (e1, a, bx);
    and (e2, a, bx);
    and (e3, e1, cin);
    or (cout, e2, e3);
    xor (fa_out, e1, cin);

    assign out = (ctl == ALU_and ? and_out : 
                  ctl == ALU_or ? or_out : 
                  ctl == ALU_add ? fa_out :
                  ctl == ALU_sub ? fa_out :
                  ctl == ALU_slt ? fa_out : 0);

endmodule