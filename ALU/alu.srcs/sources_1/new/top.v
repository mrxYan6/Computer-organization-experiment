`timescale 1ns/1ps
module top(clk_100M,rst_,clk_A,clk_B,clk_F,load,data_in,choose_out,choose_in,ALU_OP,FR,seg,AN);
    input clk_100M;
    input [7:0]data_in;
    input rst_,clk_A,clk_B,clk_F;
    input load;
    input [1:0]choose_out;
    input [2:0]choose_in;
    input [3:0]ALU_OP;
    output [3:0]FR;
    output [7:0]seg;
    output [7:0]AN;
    
    reg [31:0]A_input,B_input;
    reg [31:0]out;
    wire [31:0]A,B,F;

    BigALU alu(ALU_OP,A_input,B_input,rst_,clk_A,clk_B,clk_F,A,B,F,FR);
    scan_data show(rst_,out,clk_100M,AN,seg);

    always @(negedge rst_ or posedge load)
    begin
        if(!rst_)
        begin
            A_input <= 32'd0;
            B_input <= 32'd0;
        end
        else
        begin
            case(choose_in)
                3'b000:A_input[31:24] <= data_in;
                3'b001:A_input[23:16] <= data_in;
                3'b010:A_input[15:8] <= data_in;
                3'b011:A_input[7:0] <= data_in;
                3'b100:B_input[31:24] <= data_in;
                3'b101:B_input[23:16] <= data_in;
                3'b110:B_input[15:8] <= data_in;
                3'b111:B_input[7:0] <= data_in;
            endcase
        end
    end

    always @(*)
    begin
        if(!rst_)
        begin
            out <= 32'd0;
        end
        else
        begin
            case(choose_out)
                2'b00:out <= A_input;
                2'b01:out <= B_input;
                2'b10:out <= F;
                2'b11:out <= {28'b0,FR};
            endcase
        end
    end

endmodule