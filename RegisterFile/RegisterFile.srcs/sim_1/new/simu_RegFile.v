`timescale 1ns / 1ps

module simu_RegFile();

    reg [4:0]A_addr,B_addr,W_Addr;
    wire[31:0]A_out,B_out;
    reg rst_,clk_W;
    reg [31:0]data_write;
    Register_File rf(data_write,1'b1,rst_,clk_W,A_addr,B_addr,W_Addr,A_out,B_out);

    integer x;
    initial begin
        rst_ = 1;
        clk_W = 1;
        A_addr = 0;
        B_addr = 0;
        W_Addr = 0;
        #10
        rst_ = 0;
        #10 rst_ = 1;
        
        for(x = 0;x < 32; x = x + 1)begin
        #5
        A_addr = x;
        end

        for(x = 0;x < 32; x = x + 1)begin
            W_Addr = x;
            B_addr = x;
            data_write  = x + 233;
            clk_W = 1;
            #2
            clk_W = 0;
            #2 
            clk_W = 1;
        end

        for(x = 0;x < 32; x = x + 1)begin
        #5
        A_addr = x;
        end
    end
endmodule
