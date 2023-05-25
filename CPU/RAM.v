`timescale 1ns / 1ps

module W_Process(siz,EN,Low_Addr,RAM_in,D_in,wea);
    input [1:0]siz;
    input [31:0]RAM_in;
    input [1:0]Low_Addr;
    input EN;
    output [31:0] D_in;  
    output[3:0] wea;
    assign wea = EN ? siz == 2'b00 ? 4'b0001 << Low_Addr[1:0] 
                    :siz == 2'b01 ? 4'b0011 << {Low_Addr[1],1'b0}
                    :4'b1111
                :4'b0000;
    
    assign D_in = siz == 2'b00 ? {RAM_in[7:0],RAM_in[7:0],RAM_in[7:0],RAM_in[7:0]}
                :siz == 2'b01 ? {RAM_in[15:0],RAM_in[15:0]}
                :RAM_in;
endmodule


module SE(siz,SE,Low_Addr,D_in,Ex_out);
    input [1:0]siz;
    input SE;
    input [31:0]D_in;
    input [1:0]Low_Addr;
    output [31:0]Ex_out;

    wire [31:0] cur;
    assign cur = siz == 2'b00 ? D_in >> {Low_Addr[1:0],3'b0} 
                :siz == 2'b01 ? D_in >> {Low_Addr[1],4'b0}
                :D_in;

    assign Ex_out = siz == 2'b00 ? {{24{cur[7] & SE}},cur[7:0]}
                :   siz == 2'b01 ? {{16{cur[15] & SE}},cur[15:0]}
                :   cur;
endmodule

module RAM(clk_DM,DM_Addr,RAM_Write,siz,SE_s,RAM_in,RAM_out);
    input clk_DM;
    input [7:0]DM_Addr;
    input [1:0]siz;
    input SE_s;
    input [31:0]RAM_in;
    output [31:0]RAM_out;                
    input RAM_Write;

    wire [3:0]wea;    
    wire [31:0]D_in;
    wire [31:0]D_out;

    W_Process read_process(
        .siz(siz),
        .RAM_in(RAM_in),
        .D_in(D_in),
        .wea(wea),
        .EN(RAM_Write),
        .Low_Addr(DM_Addr[1:0])
    );

    RAM_A Data_RAM (
        .clka(clk_DM),    // input wire clka
        .addra(DM_Addr[7:2]),  // input wire [5 : 0] addra
        .dina(D_in),    // input wire [31 : 0] dina
        .wea(wea),        // input wire [3 : 0] wea
        .douta(D_out)  // output wire [31 : 0] douta
    );

    SE se(
        .siz(siz),
        .SE(SE_s),
        .D_in(D_out),
        .Ex_out(RAM_out),
        .Low_Addr(DM_Addr[1:0])
    );
endmodule
