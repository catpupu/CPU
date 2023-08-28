module memory( clk, MemRead, MemWrite, wd, addr, rd );
    input  clk, MemRead, MemWrite;
    input  [31:0] addr, wd;
    output reg [31:0] rd;

    // 1 KB
    reg [7:0] mem_array[0:1023];

    always @(MemRead or mem_array[addr] or mem_array[addr+1] or mem_array[addr+2] or mem_array[addr+3]) begin
        if (MemRead) begin
            rd[7:0] = mem_array[addr];
            rd[15:8] = mem_array[addr+1];
            rd[23:16] = mem_array[addr+2];
            rd[31:24] = mem_array[addr+3];
        end
        else rd = 32'hxxxxxxxx;
    end

    always @(posedge clk) begin
        if (MemWrite) begin
            mem_array[addr] <= wd[7:0];
            mem_array[addr+1] <= wd[15:8];
            mem_array[addr+2] <= wd[23:16];
            mem_array[addr+3] <= wd[31:24];
        end
    end

endmodule