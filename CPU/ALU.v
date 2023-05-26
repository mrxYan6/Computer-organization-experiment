`timescale 1ns / 1ps

module ALU(OP,A,B,F,ZF,SF,CF,OF);
    input [3:0]OP;
    input [31:0]A,B;
    output reg[31:0]F;
    output CF,OF,ZF,SF;

    integer i;
    reg C1,C2;
    assign ZF = F ? 0 : 1;
    assign SF = F[31];
    assign OF = A[31] ^ B[31] ^ C1 ^ F[31];
    assign CF = C1;
    always @(*)
    begin
        case(OP)
            4'b0000:
            begin
                {C1,F} = {1'b0,A} + {1'b0,B};
            end
            4'b0001: F = A << B;
            4'b0010: F = $signed(A) < $signed(B) ? 1 : 0;
            4'b0011: F = A < B ? 1'b1 : 1'b0;
            4'b0100: F = A ^ B;
            4'b0101: F = A >> B;
            4'b0110: F = A | B;
            4'b0111: F = A & B;
            4'b1000:
            begin
                {C1,F} = {1'b0,A} - {1'b0,B};
            end
            4'b1101: 
            begin
                F = $signed(A) >>> B;
            end
            default:F=0;
        endcase

    end

endmodule
