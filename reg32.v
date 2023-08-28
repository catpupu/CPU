module reg32(clk, rst, d_in, d_out );
    input  clk, rst;
    input  [31:0] d_in;
    output reg [31:0] d_out;

    always @(posedge clk) begin
        if (rst)
            d_out <= 32'b0;
      else 
            d_out <= d_in;
    end
endmodule