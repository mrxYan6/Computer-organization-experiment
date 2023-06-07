`timescale 1ns / 1ps
module Register(clk,rst_,Reg_write,Data_in,Reg);
    input clk,rst_,Reg_write;
    input [31:0]Data_in;
    output reg [31:0]Reg;
    always @(posedge clk or negedge rst_)
    begin
        if(!rst_) Reg <= 32'b0;
        else if (Reg_write) Reg <= Data_in;
    end
endmodule