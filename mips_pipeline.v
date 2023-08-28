    module mips_pipeline(clk, rst);
    input clk, rst;
    
    wire [31:0] pc, pc_incr, ID_pc_incr, pc_next, dmem_rdata, jump_addr, branch_addr, wd;
    wire [31:0] instr, ID_instr, IF_instr;

    // datapath signals 
    wire [31:0] alu_b, b_tgt, EX_b_tgt;

    // control signals
    wire RegWrite, Branch, PCSrc, RegDst, MemtoReg, MemRead, MemWrite, ALUSrc, Zero, Jump, bne, ID_RegWrite;
    wire [1:0] ALUOp;
    wire [2:0] Operation;


    // --------------------- IF Region ---------------------
    
    reg32 PC( .clk(clk), .rst(rst), .d_in(pc_next), .d_out(pc) );
    wire stay;
    wire[31:0] pc_add;
    
    memory InstrMem( .clk(clk), .MemRead(1'b1), .MemWrite(1'b1), .wd(32'b0), .addr(pc), .rd(IF_instr) ); 
    
    Hazard hazard( .clk(clk), .rst(rst), .stay(stay), .instr(IF_instr), .instr_out(instr) );
    
    add32 PCADD( .a(pc), .b(32'd4), .result(pc_incr) );  
    mux2 #(32) STMUX( .sel(stay), .a(pc), .b(pc_incr), .out(pc_add) );
    mux2 #(32) PCMUX( .sel(PCSrc), .a(b_tgt), .b(pc_add), .out(branch_addr) );
    mux2 #(32) JMUX( .sel(Jump), .a(jump_addr), .b(branch_addr), .out(pc_next) );
    
      reg_IF_ID REG_IF_ID( .clk(clk), .rst(rst), .pc_incr(pc_incr), .instr(instr), .pc_incr_out(ID_pc_incr),   .instr_out(ID_instr));

    // --------------------- ID Region ---------------------
    
    wire [1:0] EX_ALUOp;
    wire [5:0] opcode;
    wire [4:0] rs, rt, rd, wn;
    wire [15:0] immed;
    wire [25:0] jumpoffset;
    wire [31:0] ext_immed, EX_pc_incr, EX_instr;
    wire [31:0] rd1, rd2;
    wire ID_MemWrite, EX_RegDst, EX_ALUSrc, EX_MemRead, EX_MemWrite, EX_Branch, EX_MemtoReg, EX_RegWrite;
    // R-type
    assign opcode = ID_instr[31:26];
    assign rs = ID_instr[25:21];
    assign rt = ID_instr[20:16];
    assign rd = ID_instr[15:11];

    // I-type: Immediate
    assign immed = ID_instr[15:0];
    
    // J-type: Jump
    assign jumpoffset = ID_instr[25:0];
    assign jump_addr = { ID_pc_incr[31:28], jumpoffset <<2 };
    
    sign_extend SignExtend( .immed_in(immed), .ext_immed_out(ext_immed) );

	reg_file RegFile( .clk(clk), .RegWrite(RegWrite), .RN1(rs), .RN2(rt), .WN(wn), 
					  .WD(wd), .RD1(rd1), .RD2(rd2) );

    control CTL(.opcode(opcode), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
                .RegWrite(ID_RegWrite), .MemRead(MemRead), .MemWrite(ID_MemWrite), .Branch(Branch), 
              .Jump(Jump), .ALUOp(ALUOp), .bne(bne));

    // Register ID/EX
      wire [5:0] EX_opcode;
    wire EX_bne;
    wire [4:0]  EX_wn, EX_rd, EX_rt;
    wire [31:0] EX_ext_immed, EX_rd1, EX_rd2;
    
      reg_ID_EX REG_ID_EX(.opcode(opcode), .clk(clk), .rst(rst), .RegDst(RegDst), .ALUSrc(ALUSrc), .ALUOp(ALUOp), .MemRead(MemRead), .MemWrite(ID_MemWrite), .Branch(Branch), .MemtoReg(MemtoReg), .RegWrite(ID_RegWrite), .bne(bne), .rfile_rd1(rd1), .rfile_rd2(rd2), .ext_immed(ext_immed), .rt(rt), .rd(rd), .pc_incr(ID_pc_incr),
                         .opcode_out(EX_opcode),.RegDst_out(EX_RegDst), .ALUSrc_out(EX_ALUSrc), .ALUOp_out(EX_ALUOp), 
                         .MemRead_out(EX_MemRead), .MemWrite_out(EX_MemWrite), .Branch_out(EX_Branch),     
                         .MemtoReg_out(EX_MemtoReg),.RegWrite_out(EX_RegWrite), 
                        .bne_out(EX_bne)/*.instr_out(EX_instr)*/, .rfile_rd1_out(EX_rd1), .rfile_rd2_out(EX_rd2),   .ext_immed_out(EX_ext_immed), 
                         .rt_out(EX_rt), .rd_out(EX_rd), .pc_incr_out(EX_pc_incr) );
        // EX_instr, EX_pc_incr
    // --------------------- EX Region --------------------- 

    wire MEM_zero, MEM_bne, DIVU ;
    wire [1:0] ALUSEL;
    wire [5:0] MEM_funct, funct, MEM_opcode;
    wire [4:0] MEM_shamt, shamt, MEM_wn;
    wire [31:0] MEM_ext_immed, MEM_pc_incr, MEM_instr; // MEM_pc_incr 
    wire [31:0] MEM_rd1, MEM_rd2, MEM_aluANS, MEM_result ; // ok
    wire MEM_RegDst, MEM_ALUSrc, MEM_MemRead, MEM_MemWrite, MEM_Branch, MEM_MemtoReg;
    wire [63:0] div_out ;
    wire [31:0] hi, lo, alu_out;
    wire [31:0] result, b_offset; 
    
    assign funct = EX_ext_immed[5:0]; 
    assign shamt = EX_ext_immed[10:6];
    assign b_offset = EX_ext_immed << 2; // branch offset
    
      add32 BRADD( .a(EX_pc_incr), .b(b_offset), .result(EX_b_tgt) );// ( pc + 4 ) + branch offset // 傳入 b 的大小有問題 by 56
    mux2 #(32) ALUMUX( .sel(EX_ALUSrc), .a(EX_ext_immed), .b(EX_rd2), .out(alu_b) ); // alu source

    alu_ctl ALUCTL( .ALUOp(EX_ALUOp), .Funct(funct), .ALUOperation(Operation), .DIVU(DIVU), .ALUSEL(ALUSEL) ); // 3 to 5 parameter missing DIVU, ALUSEL 
    
    Divider divider( .clk(clk), .rst(DIVU), .a(EX_rd1), .b(EX_rd2), .result(div_out) );
    HiLo HILO( .clk(clk), .DivAns(div_out), .HiOut(hi), .LoOut(lo) );
    
      ALU alu( .ctl(Operation), .a(EX_rd1), .b(alu_b), .result(alu_out), .zero(Zero)); 
    
      mux3 ALURMUX( .sel(ALUSEL), .a(hi), .b(lo), .c(alu_out), .out(result) );    // ALU result // sel 2 or 3  ?? by 56
    
      mux2 #(5)  RFMUX( .sel(EX_RegDst), .a(EX_rd), .b(EX_rt), .out(EX_wn) ); // Register destination
  
      reg_EX_MEM REG_EX_MEM( .opcode(EX_opcode), .funct(funct),  .clk (clk) , .reset(rst), .RW(EX_RegWrite), .MtoR(EX_MemtoReg), .MR(EX_MemRead), .MW(EX_MemWrite),.Branch(EX_Branch), .bne(EX_bne), .ext_immed(EX_ext_immed), .zero(Zero), .rd2(EX_rd2), .WN(EX_wn), .aluANS(result), .b_tgt(EX_b_tgt), 
                            .opcode_out(MEM_opcode), .funct_out(MEM_funct), .RW_out(MEM_RegWrite), .MtoR_out(MEM_MemtoReg), .MR_out(MEM_MemRead), .MW_out(MEM_MemWrite), .Branch_out(MEM_Branch), .bne_out(MEM_bne),                       .ext_immed_out(MEM_ext_immed), .zero_out(MEM_zero), .aluANS_out(MEM_result), .rd2_out(MEM_rd2), .WN_out(MEM_wn), .b_tgt_out(b_tgt) ) ;
    // aluANS, aluANS_outS, WM_out
    // --------------------- MEM Region ---------------------
    wire[5:0]  WB_opcode;
    wire[31:0] WB_dataMemrd, WB_result;
    wire WB_Branch, WB_MemtoReg, MEM_cmp;
    wire [4:0] MUX;
      wire [5:0] WB_funct;
    xor (MEM_cmp, MEM_bne, MEM_zero);
    and BRAND(PCSrc, MEM_cmp, MEM_Branch);
  
  
      memory DataMemory(.clk(clk), .MemRead(MEM_MemRead), .MemWrite(MEM_MemWrite), .wd(MEM_rd2), .addr(MEM_result), .rd(dmem_rdata) ) ; 

      reg_MEM_WB REG_MEM_WB( .opcode(MEM_opcode), .funct(MEM_funct), .clk(clk), .rst(rst), .regWrite(MEM_RegWrite), .memtoReg(MEM_MemtoReg), .dataMemrd(dmem_rdata), .ALU_result(MEM_result), .WN(MEM_wn), .opcode_out(WB_opcode), .funct_out(WB_funct), .regWrite_out(RegWrite), .memtoReg_out(WB_MemtoReg), .dataMemrd_out(WB_dataMemrd), .ALU_result_out(WB_result), .WN_out(wn) ) ;
// 新增 regWrite port
// RegWrite、MUX 去掉WB


      // opcode & funct :  WB_opcode, WB_funct !! 
    // --------------------- WB Region ---------------------
    mux2 #(32) WRMUX(  .sel(WB_MemtoReg), .a(WB_dataMemrd), .b(WB_result), .out(wd) );  
  
  
endmodule