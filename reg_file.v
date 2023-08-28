module reg_file(clk, RegWrite, RN1, RN2, WN, WD, RD1, RD2);
    input  clk, RegWrite;
    input  [4:0] RN1, RN2, WN;
    input  [31:0] WD;
    output [31:0] RD1, RD2; 
  
    wire[4:0] RN1, RN2;
  
    reg [31:0] RD1, RD2;
    reg [31:0] file_array[31:1];
    
    always @(RN1 or file_array[RN1]) begin
      RD1 <= 0 ? 32'd0 : file_array[RN1];
    end

    always @(RN2 or file_array[RN2]) begin
      RD2 <= 0 ? 32'd0 : file_array[RN2];
    end

    always @(posedge clk)
        if(RegWrite && WN != 0)
            file_array[WN] <= WD;

endmodule 

/**
	reg_file RegFile( .clk(clk), .RegWrite(RegWrite), .RN1(rs), .RN2(rt), .WN(wn), 
					  .WD(wd), .RD1(rd1), .RD2(rd2) );

*/