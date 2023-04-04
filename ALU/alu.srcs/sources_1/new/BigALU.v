`timescale 1ns/1ps

module BigALU(ALU_OP,Data_A,Data_B,rst_,clk_A,clk_B,clk_F,A,B,F,FR);
    input [3:0]ALU_OP;
    input [31:0]Data_A,Data_B;
    input rst_,clk_A,clk_B,clk_F;
    output [31:0]F;
    output [3:0]FR;
    output [31:0]A,B;
    wire [31:0]res;
    wire ZF,SF,CF,OF;
    Register RA(clk_A,rst_,Data_A,A);
    Register RB(clk_B,rst_,Data_B,B);
    ALU alu(ALU_OP,A,B,res,ZF,SF,CF,OF);
    Register RF(clk_F,rst_,res,F);
    Register flag_register(clk_F,rst_,{28'b0,ZF,SF,CF,OF},{28'b0,FR});
endmodule