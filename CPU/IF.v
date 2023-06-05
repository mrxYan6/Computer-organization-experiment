`timescale 1ns / 1ps

module IF(IR_Write, PC_Write, clk_im, pc, ir, rs1, rs2, rd, opcode, func3, func7, imm);
    input IR_Write, PC_Write, clk_im;
    output [4:0]rs1, rs2, rd;
    output [6:0]opcode;
    output [2:0]func3;
    output [6:0]func7;
    output [31:0]imm;
    output [31:0]pc;
    output [31:0]ir;



    Reg PC(
        .clk(~clk_im),
        .rst_(1'b1),
        .Reg_write(PC_Write),
        .Data_in(pc + 4),
        .Reg(pc)
    );

    wire [31:0]inst_code;

    ROM IM (
        .clka(clk_im),
        .addra(pc[7:2]),
        .wea(4'b1111),
        .douta(inst_code)
    );


    Reg IR (
        .clk(clk_im),
        .rst_(1'b1),
        .Reg_write(IR_Write),
        .Data_in(inst_code),
        .Reg(ir)
    );

    ID1 id1(
        .inst(ir),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .imm(imm)
    );
endmodule