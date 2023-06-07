`timescale 1ns / 1ps

module Fdiv(input reset,input[31:0] mult,input clk_1M,output reg clk_1K);
    reg [31:0]counter;
    initial begin counter = 32'd0;end
    initial begin clk_1K = 0;end
    always @(posedge clk_1M or negedge reset) begin
        if(!reset)begin
                counter <= 32'd0;
                clk_1K <= 1'b0;
            end
        else if(counter == mult) begin
                clk_1K <= ~clk_1K;
                counter <= 32'd0;
            end
        else begin
            counter <= counter + 1'b1;
        end
    end
endmodule
