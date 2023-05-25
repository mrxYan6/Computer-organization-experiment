`timescale 1ns / 1ps
module Register(clk,rst_,X,Y);
    input clk,rst_;
    input [31:0]X;
    output reg [31:0]Y;
    always @(posedge clk or negedge rst_)
    begin
        if(!rst_) Y <= 32'b0;
        else Y <= X;
    end
endmodule