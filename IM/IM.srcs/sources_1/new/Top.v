`timescale 1ns / 1ps

// IF(IR_Write, PC_Write, clk_im, pc, ir, rs1, rs2, rd, opcode, func3, func7, imm)
module TOP(IR_Write, PC_Write, clk_100m, switch, AN, Seg, Led)
    input IR_Write, PC_Write, clk_100m;
    input [2:0]switch;
    output [7:0]AN;
    output [7:0]Seg;
    output reg [16:0]Led;

    wire [31:0]pc;
    wire [31:0]ir;
    wire [4:0]rs1, rs2, rd;
    wire [6:0]opcode;
    wire [2:0]func3;
    wire [6:0]func7;
    wire [31:0]imm;

    IF if1(
        .IR_Write(IR_Write),
        .PC_Write(PC_Write),
        .clk_im(clk_100m),
        .pc(pc),
        .ir(ir),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .imm(imm)
    );

    reg [31:0]data_tube;

    always @(*) begin
        case(switch[2])
            0: Led = {rs1,rs2,rd};
            1: Led = {opcode,func3,func7};
        endcase
    end

    always @(*) begin
        case(sw[1:0])
            0: data_tube = imm;
            1: data_tube = pc;
            2: data_tube = ir;
        endcase
    end

    scan_data(1'b1,data_tube,clk_100m,AN,Seg);
endmodule