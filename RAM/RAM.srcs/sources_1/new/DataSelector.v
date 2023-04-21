`timescale 1ns / 1ps

module DataSelector(select,out);
    input [2:0]select;
    output reg [31:0]out;

    always @(*) begin
        case (select)
            0: out = 32'h7fffffff;
            1: out = 32'hffffffff;
            2: out = 32'h7;
            3: out = 32'b1;
            4: out = 32'b0;
            5: out = 32'h0aaaaaaa;
            6: out = 32'h5;
            7: out = 32'h11223344;
        endcase
    end

endmodule