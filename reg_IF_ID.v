module reg_IF_ID( clk, rst, pc_incr, instr, pc_incr_out, instr_out ); // ok
	input   clk, rst ;
	input  [31:0] pc_incr, instr;

    output reg [31:0] pc_incr_out, instr_out;

	always @(posedge clk)begin
		if (rst) begin

			pc_incr_out <= 32'd0;
			instr_out <= 32'd0;
		end
		else begin

			pc_incr_out <= pc_incr;
			instr_out <= instr;
		end
		
	end

endmodule
