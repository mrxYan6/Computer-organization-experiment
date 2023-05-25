`timescale 1ns / 1ps

// IF(IR_Write, PC_Write, clk_im, pc, ir, rs1, rs2, rd, opcode, func3, func7, imm)
module TOP(rst_, clk, switch, AN, Seg, Led);
    input rst_, clk;
    input [2:0]switch;
    output [7:0]AN;
    output [7:0]Seg;
    output reg [16:0]Led;

    

    wire CF, OF, ZF, SF;
    wire [3:0] ALU_OP;
    wire PC_Write, PC0_Write, IR_Write, Reg_Write, Mem_write;
    wire SE_s;
    wire [1:0] Size_s;
    wire [1:0] PC_s;            // 0: PC + 4, 1: PC0 + imm, 2: F
    wire rs2_imm_s;             // 0: rs2, 1: imm
    wire [2:0] w_data_s;        // 0: F, 1: imm, 2: MDR, 3: PC, 4: PC0 + imm 
    wire [6:0]opcode;
    wire [2:0]func3;
    wire [6:0]func7;
    
    CU cu(
        .rst_(rst_),
        .clk(clk),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .CF(CF),
        .OF(OF),
        .ZF(ZF),
        .SF(SF),
        .ALU_OP(ALU_OP),
        .PC_Write(PC_Write),
        .PC0_Write(PC0_Write),
        .IR_Write(IR_Write),
        .Reg_Write(Reg_Write),
        .Mem_write(Mem_write),
        .SE_s(SE_s),
        .Size_s(Size_s),
        .PC_s(PC_s),
        .rs2_imm_s(rs2_imm_s),
        .w_data_s(w_data_s)
    );


    wire [31:0]pc, pc0;
    wire [31:0]ir;
    wire [4:0]rs1, rs2, rd;

    wire [31:0]imm;

    wire [31:0] pc_in;

    assign pc_in = (PC_s == 0) ? pc + 4 : (PC_s == 1) ? pc0 + imm : 32'h0000_0000;

    Register PC(
        .clk(clk),
        .rst_(rst_),
        .Reg_write(PC_Write),
        .Data_in(pc_in),
        .Reg(pc)
    );

    Register PC0(
        .clk(clk),
        .rst_(rst_),
        .Reg_write(PC0_Write),
        .Data_in(pc),
        .Reg(pc0)
    );

    wire [31:0]inst_code;

    ROM IM (
        .clka(~clk),    // input wire clka
        .addra(pc[7:2]),  // input wire [5 : 0] addra
        .douta(inst_code)  // output wire [31 : 0] douta
    );


    Register IR (
        .clk(clk),
        .rst_(rst_),
        .Reg_write(IR_Write),
        .Data_in(inst_code),
        .Reg(ir)
    );

    ID1 id1(
        .inst(ir),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .imm(imm)
    );

    //regfile + alu

    wire [31:0]W_data, R_Data_A, R_Data_B;
    Register_File reg_files(
        .data_write(W_data),
        .Reg_Write(Reg_Write),
        .rst_(rst_),
        .clk_W(clk),
        .A_addr(rs1),
        .B_addr(rs2),
        .W_addr(rd),
        .A_out(R_Data_A),
        .B_out(R_Data_B)
    );

    wire [31:0] A,B;

    Register RA(
        .clk(clk),
        .rst_(rst_),
        .Data_in(R_Data_A),
        .Reg(A)
    );
    
    Register RB(
        .clk(clk),
        .rst_(rst_),
        .Data_in(R_Data_B),
        .Reg(B)
    );
    wire [31:0] ALU_B;
    assign ALU_B = rs2_imm_s ? imm : B; 
    
    wire [31:0] res;
    wire _ZF, _SF, _CF, _OF;
    wire [31:0] F;

    ALU alu(
        .OP(ALU_OP),
        .A(A),
        .B(ALU_B),
        .F(res),
        .ZF(_ZF),
        .SF(_SF),
        .CF(_CF),
        .OF(_OF)
    );

    // Register RF(clk,rst_,res,F);
    // Register flag_register(clk,rst_,{28'b0,_ZF,_SF,_CF,_OF},{ZF,SF,CF,OF});
    Register RF(
        .clk(clk),
        .rst_(rst_),
        .Data_in(res),
        .Reg(F)
    );

    Register flag_register(
        .clk(clk),
        .rst_(rst_),
        .Data_in({28'b0,_ZF,_SF,_CF,_OF}),
        .Reg({ZF,SF,CF,OF})
    );


    //module RAM(clk_DM,DM_Addr,RAM_Write,siz,SE_s,RAM_in,RAM_out);
    // input clk_DM;
    // input [7:0]DM_Addr;
    // input [1:0]siz;
    // input SE_s;
    // input [31:0]RAM_in;
    // output [31:0]RAM_out;                
    // input RAM_Write;

    wire [31:0]RAM_out;
    wire [31:0] mdr;

    assign W_data =   (w_data_s == 0) ? F :
                        (w_data_s == 1) ? imm :
                        (w_data_s == 2) ? mdr :
                        (w_data_s == 3) ? pc :
                        (w_data_s == 4) ? pc0 + imm
                        : 32'h0000_0000;

    RAM ram (
        .clk_DM(~clk),
        .DM_Addr(F),
        .RAM_Write(Mem_write),
        .siz(Size_s),
        .SE_s(SE_s),
        .RAM_in(B),
        .RAM_out(RAM_out)
    );

    Register MDR (
        .clk(clk),
        .rst_(rst_),
        .Data_in(RAM_out),
        .Reg(mdr)
    );
endmodule