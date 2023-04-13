`timescale 1ns / 1ps

module simu_RegFile();

    reg [4:0]A_addr,B_addr,W_Addr;
    wire[31:0]A_out,B_out;
    reg rst_,clk_W;
    Register_File rf(32'd233,1'b1,rst_,clk_W,A_addr,B_addr,W_addr,A_out,B_out);

    integer x;
    initial begin
        rst_ <= 1;
        #10
        rst_ <= 0;
        #10 rst_ <= 1;

        for(x = 0;x < 32; x = x + 1)begin
        #5
        A_addr <= x;
        end
    end
endmodule
