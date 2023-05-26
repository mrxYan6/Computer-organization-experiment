`timescale 1ns/1ps

module CU(rst_, clk, opcode, func3, func7, CF, OF, ZF, SF, ALU_OP, PC_Write, PC0_Write, IR_Write, Reg_Write, Mem_write, SE_s, Size_s, PC_s, rs2_imm_s, w_data_s);
    input rst_, clk;
    input [6:0] opcode;
    input [2:0] func3;
    input [6:0] func7;
    input CF, OF, ZF, SF;
    output [3:0] ALU_OP;
    output reg PC_Write, PC0_Write, IR_Write, Reg_Write, Mem_write;
    output reg SE_s;
    output reg [1:0] Size_s;
    output reg [1:0] PC_s;            // 0: PC + 4, 1: PC0 + imm, 2: F
    output reg rs2_imm_s;             // 0: rs2, 1: imm
    output reg [2:0] w_data_s;        // 0: F, 1: imm, 2: MDR, 3: PC, 4: PC0 + imm


    wire IS_R, IS_IMM, IS_LUI, IS_S, IS_B, IS_J,IS_L, IS_AUIPC, IS_JALR;
// ID2(opcode, func3, func7, ALU_OP, IS_R, IS_IMM, IS_LUI, IS_S, IS_B, IS_J, IS_CSR, IS_L, IS_AUIPC, IS_JALR);

    ID2 id2(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .IS_S(IS_S),
        .IS_B(IS_B),
        .IS_J(IS_J),
        .IS_CSR(),
        .IS_L(IS_L),
        .IS_AUIPC(IS_AUIPC),
        .IS_JALR(IS_JALR),
        .ALU_OP(ALU_OP)
    );

    reg cc;
    // generate cc
    always @(*) begin
        if (IS_B) begin
            case(func3)
                3'b000: cc = ZF;                        //beq
                3'b001: cc = ~ZF;                       //bne
                3'b100: cc = (SF ^ OF) & (~ZF);         //blt
                3'b101: cc = ~((SF ^ OF) & (~ZF));      //bge
                3'b110: cc = CF;                        //bltu
                3'b111: cc = ~CF;                       //bgeu
                default: cc = 1'b0;
            endcase
        end
        else cc = 1'b0;
    end

    // generate Size_s, SE_s
    always@(*) begin
        if (IS_L || IS_S) begin
            Size_s = func3[1:0];
            SE_s = func3[2];
        end else begin
            Size_s = 2'b00;
            SE_s = 1'b0;
        end
    end


    // status update
    reg [3:0] st, next_st;
    always @(posedge clk or negedge rst_) begin
        if (!rst_) st <= 4'd0;
        else st <= next_st;
    end

    // generate next status
    always @(*) begin
        next_st = 4'd0;
        case (st)
            4'd0: next_st = 4'd1;
            4'd1: begin
                if (IS_IMM || IS_R || IS_L || IS_S || IS_JALR) next_st = 4'd2;                     //I+R
                else if (IS_LUI) next_st = 4'd6;                        //lui
                else if (IS_J) next_st = 4'd1;                          //jal
                else next_st = 4'd15;                                   //auipc
            end
            4'd2: begin
                if(IS_R) next_st = 4'd3;                                //R
                else if (IS_IMM) next_st = 4'd5;                        //I
                else if (IS_L || IS_S || IS_JALR) next_st = 4'd7;       //L + S + JARL
                else next_st = 4'd13;                                   //B
            end
            4'd3: next_st = 4'd4;                                       //R
            4'd4: next_st = 4'd1;                                       //ret
            4'd5: next_st = 4'd4;                                       //I
            4'd6: next_st = 4'd1;                                       //ret
            4'd7: begin
                if(IS_L) next_st = 4'd8;                                //L
                else if(IS_S) next_st = 4'd10;                          //S
                else next_st = 4'd12;                                   //JALR
            end
            4'd8: next_st = 4'd9;                                       //L
            4'd9: next_st = 4'd1;                                       //ret
            4'd10: next_st = 4'd1;                                      //ret
            4'd11: next_st = 4'd1;                                      //ret
            4'd12: next_st = 4'd1;                                      //ret
            4'd13: next_st = 4'd14;                                     //B
            4'd14: next_st = 4'd1;                                      //ret
            4'd15: next_st = 4'd1;                                      //ret
            default: next_st = 4'd0;
        endcase
    end

    // generate signals 
    always @(posedge clk or negedge rst_) begin
        if(!rst_) begin
            {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b0;
            SE_s <= 1'b0;
            Size_s <= 2'b0;
            PC_s <= 2'b0;
            rs2_imm_s <= 1'b0;
            w_data_s <= 3'b0;
        end else begin
            case (next_st)
                4'd1: begin 
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b11100;
                    PC_s <= 2'b00;
                end
                4'd2: {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00000;
                4'd3: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00000;   
                    rs2_imm_s <= 1'b0;
                end
                4'd4: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00010;
                    w_data_s <= 3'b00;
                end
                4'd5: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00000;
                    rs2_imm_s <= 1'b1;
                end
                4'd6: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00010;
                    w_data_s <= 3'b01;
                end
                4'd7: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00000;
                    rs2_imm_s <= 2'b1;
                end
                4'd8: {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00000;
                4'd9: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00010;
                    w_data_s <= 3'b10;
                end
                4'd10: {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00001;
                4'd11: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b10010;
                    PC_s <= 2'b01;
                    w_data_s <= 3'b11;
                end
                4'd12: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b10010;
                    PC_s <= 2'b10;
                    w_data_s <= 3'b11;
                end
                4'd13: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00000;
                    rs2_imm_s <= 1'b0;
                end
                4'd14: begin
                    {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= {cc, 4'b00000};
                    PC_s <= 2'b01;
                end
                4'd15: {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b00000;
                default: {PC_Write, PC0_Write, IR_Write,Reg_Write, Mem_write} <= 5'b0;
            endcase
        end
    end
endmodule
