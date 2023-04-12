`timescale 1ns / 1ps
module ALU_sim();
reg[31:0]A,B;
reg[3:0]OP;
wire[31:0]F;
wire ZF,SF,CF,OF;
ALU alu(OP,A,B,F,ZF,SF,CF,OF);
initial
begin
    A=32'h7fff_fff0;B=32'h7fff_ffff;
    OP=4'b0;
end
always
begin
    #100;
    OP=OP+1'b1;
end
endmodule
