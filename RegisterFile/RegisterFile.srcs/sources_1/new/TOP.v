`timescale 1ns / 1ps
module BigBigALU(A_addr,B_addr,W_Addr,ALU_OP,Reg_Write,clk_100M,rst_,clk_Read,clk_F,clk_Write,F,FR);   //链接寄存器堆和ALU
    input [4:0]A_addr,B_addr,W_Addr;
    input [3:0]ALU_OP;
    input Reg_Write,clk_100M;
    input rst_,clk_Read,clk_F,clk_Write;
    output [3:0]FR;
    output [31:0]F;

    wire [31:0]Reg_A,Reg_B;

    Register_File rgf(
        .rst_(rst_),
        .data_write(F),
        .Reg_Write(Reg_Write),
        .clk_W(clk_Write),
        .A_addr(A_addr),
        .B_addr(B_addr),
        .W_addr(W_Addr),
        .A_out(Reg_A),
        .B_out(Reg_B));
    
    BigALU alu(
        .ALU_OP(ALU_OP),
        .Data_A(Reg_A),
        .Data_B(Reg_B),
        .rst_(rst_),
        .clk_A(clk_Read),
        .clk_B(clk_Read),
        .clk_F(clk_F),
        .F(F),
        .FR(FR));
endmodule



module TOP(A_addr,B_addr,W_Addr,ALU_OP,Reg_Write,clk_100M,rst_,clk_Read,clk_F,clk_Write,AN,Seg,FR); //顶层模块
    input [4:0]A_addr,B_addr,W_Addr;
    input [3:0]ALU_OP;
    input Reg_Write,clk_100M;
    input rst_,clk_Read,clk_F,clk_Write;
    output [7:0]AN;
    output [7:0]Seg;
    output [3:0]FR;

    wire [31:0]F;
    
    BigBigALU aluu(
        .A_addr(A_addr),
        .B_addr(B_addr),
        .W_Addr(W_Addr),
        .ALU_OP(ALU_OP),
        .Reg_Write(Reg_Write),
        .clk_100M(clk_100M),
        .rst_(rst_),
        .clk_Read(clk_Read),
        .clk_F(clk_F),
        .clk_Write(clk_Write),
        .F(F),
        .FR(FR));

    scan_data tube(rst_,F,clk_100M,AN,Seg);
endmodule
