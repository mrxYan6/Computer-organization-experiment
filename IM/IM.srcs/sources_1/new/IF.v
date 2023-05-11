`timescale 1ns / 1ps

module IF(rst_,IR_Write, PC_Write, clk_im, pc, ir);
    input rst_,IR_Write, PC_Write, clk_im;
    output [31:0]pc;
    output [31:0]ir;



    Reg PC(
        .clk(clk_im),
        .rst_(rst_),
        .Reg_write(PC_Write),
        .Data_in(pc + 4),
        .Reg(pc)
    );

    wire [31:0]inst_code;

    ROM IM (
        .clka(~clk_im),    // input wire clka
        .addra(pc[7:2]),  // input wire [5 : 0] addra
        .douta(inst_code)  // output wire [31 : 0] douta
    );
//     (
//   .clka(clka),    // input wire clka
//   .ena(ena),      // input wire ena
//   .addra(addra),  // input wire [5 : 0] addra
//   .douta(douta)  // output wire [31 : 0] douta
// );


    Reg IR (
        .clk(clk_im),
        .rst_(rst_),
        .Reg_write(IR_Write),
        .Data_in(inst_code),
        .Reg(ir)
    );

endmodule