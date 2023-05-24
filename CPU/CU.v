`timescale 1ns/1ps

module CU(st, PC_Write, IR_Write, Reg_Write, rs2_imm_s, w_data_s);
    input [3:0]st;
    output reg PC_Write, IR_Write, Reg_Write, rs2_imm_s;
    output reg[1:0]w_data_s;
    always @(*) begin
        case(st)
            4'd0:{PC_Write, IR_Write, Reg_Write, rs2_imm_s} = 4'b0000;
            4'd1:{PC_Write, IR_Write, Reg_Write} = 3'b110;
            4'd2:{PC_Write, IR_Write, Reg_Write, rs2_imm_s} = 4'b0000;
            4'd3:{PC_Write, IR_Write, w_data_s} = 4'b0000;
            4'd4:{PC_Write, IR_Write, Reg_Write} = 3'b001;
            4'd5:{PC_Write, IR_Write, rs2_imm_s, w_data_s} = 5'b00100;
            4'd6:{PC_Write, IR_Write, w_data_s, Reg_Write} = 5'b00011;
        endcase
    end
endmodule