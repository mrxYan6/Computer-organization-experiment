`timescale 1ns / 1ps


module Test_button(clk,in,out1,out);
  input clk;
  output reg[15:0]out = 0;
  output out1;
  input in;

  wire clk100us;
  Fdiv utt(1'd1,32'd1000000,clk,clk100us);//10ms
  core utu(clk100us,in,out1);
  always @(negedge out1) begin
      out <= out + 1;
  end
endmodule

module button(clk,in,out);
  input clk,in;
  output out;
  wire clk100us;
  Fdiv utt(1'd1,32'd1000000,clk,clk100us);
  core utt2(clk100us,in,out);
endmodule

module core(CP,in,out);
  input in,CP;
  output reg out;
  reg[2:0] ST;
  parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;
  always @( posedge CP)
  begin
    case(ST)
      S0:
        out <= 1'b0;
      S1:
        out <= in;
      S2:
        out <= 1'b0;
      S3:
        out <= 1'b1;
      S4:
        out <= in;
      S5:
        out <= in;
    endcase
    case(ST)
      S0:
        ST<=in?S1:S0;
      S1:
        ST<=in?S3:S2;
      S2:
        ST<=in?S1:S0;
      S3:
        ST<=in?S3:S4;
      S4:
        ST<=in?S5:S0;
      S5:
        ST<=in?S3:S4;
    endcase
  end
endmodule
