`timescale 1ns / 1ps


module RAM(clr,clk_100Mhz,clk_DM,DM_Addr,DM_Write,Data_selector,Seg,AN);
    input clr,clk_100Mhz,clk_DM;
    input [7:0]DM_Addr;
    input DM_Write;
    input [2:0]Data_selector;
    output [7:0]Seg;
    output [7:0]AN;

    wire [31:0]DM_in,DM_out;

    reg [31:0]data_show;

    DataSelector selecotr(
        .select(Data_selector),
        .out(DM_in)
    );

    RAM_A Data_RAM (
        .clka(clk_dm),    // input wire clka
        .wea(DM_Write),      // input wire [0 : 0] wea
        .addra(DM_Addr[7:2]),  // input wire [5 : 0] addra
        .dina(DM_in),    // input wire [31 : 0] dina
        .douta(DM_out)  // output wire [31 : 0] douta
    );

    always @(posedge clk_dm)begin
        if(!DM_Write) data_show <= DM_out;
    end

    scan_data tube(
        .reset(clr),
        .data(data_show),
        .clk(clk_100Mhz),
        .AN(AN),
        .seg(Seg)
    );
endmodule
