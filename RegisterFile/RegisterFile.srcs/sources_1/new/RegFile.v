`timescale 1ns / 1ps
module Register_File(data_write,Reg_Write,rst_,clk_W,A_addr,B_addr,W_addr,A_out,B_out);
    input [31:0]data_write;
    input [4:0]A_addr,B_addr,W_addr;
    input Reg_Write,clk_W;
    input rst_;
    output [31:0]A_out,B_out;

    reg [31:0]Reg_Files[0:31];

    assign A = Reg_Files[A_addr];
    assign B = Reg_Files[B_addr];
    
    integer i;
    
    always @(negedge rst_ or posedge clk_W) begin
        if(!rst_)begin
            for(i = 0; i < 32; i = i + 1) Reg_Files[i] <= 0;
            Reg_Files[7] <= 32'h0000_0007;
            Reg_Files[8] <= 32'hf7f7_f7f7;
            Reg_Files[9] <= 32'h37f7_f7f7;
            
            Reg_Files[30] <= 32'hffff_ffff;
            Reg_Files[31] <= 32'h7fff_ffff;
        end else if(Reg_Write && W_addr != 5'd0)Reg_Files[W_addr] <= data_write;
        
    end

endmodule
