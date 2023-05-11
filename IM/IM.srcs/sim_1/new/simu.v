`timescale 1ns / 1ps

module simu();

// module IF(IR_Write, PC_Write, clk_im, pc, ir);

    reg IR_Write, PC_Write, clk_im, rst_;
    wire [31:0]pc;
    wire [31:0]inst;
    IF if0(
        .rst_(rst_),
        .IR_Write(IR_Write),
        .PC_Write(PC_Write),
        .clk_im(clk_im),
        .pc(pc),
        .ir(inst)
    );
    always @(*) begin
        #10
        clk_im <= ~clk_im;
    end

    initial begin
        clk_im = 1;
        IR_Write = 0;
        PC_Write = 0;
        rst_ = 1;
        #6
        rst_ = 0;
        #6
        rst_ = 1;
        PC_Write = 1;
        IR_Write = 1;

    end
endmodule
