`timescale 1ns/1ps

module State(clk, rst_, opcode, func3, func7, IS_R, IS_IMM, IS_LUI, IS_S, IS_B, IS_J, st);
    input clk, rst_;
    input [6:0] opcode;
    input [2:0] func3;
    input [6:0] func7;
    output IS_R, IS_IMM, IS_LUI, IS_S, IS_B, IS_J;
    output reg [3:0] st;

    always @(posedge clk or negedge rst_) begin
        if (!rst_) st <= 4'd0;
        else begin
            case (st)
                4'd0: st <= 4'd1;
                4'd1:
                begin
                    if (IS_R || IS_IMM) st <= 4'd2;
                    else if (IS_LUI) st <= 4'd6;
                end
                4'd2:
                begin
                    if (IS_R) st <= 4'd3;
                    else if (IS_IMM) st <= 4'd5;
                end
                4'd3:
                begin
                    st <= 4'd4;
                end
                4'd4:
                begin
                    st <= 4'd1;
                end
                4'd5:
                begin
                    st <= 4'd4;
                end
                4'd6:
                    st <= 4'd1;
                default;
            endcase
        end
    end
