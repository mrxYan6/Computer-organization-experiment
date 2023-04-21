`timescale 1ns / 1ps
module sim();

    reg clk;
    reg write;
    reg [7:0]addr;
    reg [31:0]data_in;
    wire [31:0]data_out;
    reg [1:0]siz;
    reg SE_s;

    RAM ram(
        .clk_DM(clk),
        .DM_Addr(addr),
        .RAM_Write(write),
        .siz(siz),
        .SE_s(SE_s),
        .RAM_in(data_in),
        .RAM_out(data_out)
    );

    always @(*)begin
        #2
        clk <= ~clk;
    end
    always @(*)begin
        #128
        write <= ~write;
    end

    always @(*)begin
        #8
        addr[1:0] <= addr[1:0]+1;
    end
    always @(*)begin
        #4
        SE_s <= ~SE_s;
    end

    always @(*)begin
        #32
        siz <= siz + 1;
    end

    initial begin
        clk = 0;
        write = 0;
        addr = 0;
        data_in = 32'h12345678;
        SE_s = 0;
        siz = 0;

    end

endmodule
