`timescale 1ns / 1ps

module ID(inst, rs1, rs2, rd, opcode, func3, func7, imm, ALU_OP, IS_R, IS_IMM, IS_LUI, IS_S, IS_B, IS_J, IS_CSR);
    input [31:0]inst;
    output [4:0]rs1, rs2, rd;
    output [6:0]opcode;
    output [2:0]func3;
    output [6:0]func7;
    output reg[31:0]imm;
    output [3:0]ALU_OP;
    output IS_R, IS_IMM, IS_LUI, IS_S, IS_B, IS_J, IS_CSR;
    wire [31:0]I_shift, I_imm, S_imm, B_imm, U_imm, J_imm;

    assign func7 = inst[31:25];
    assign rs2 = inst[24:20];
    assign rs1 = inst[19:15];
    assign func3 = inst[14:12];
    assign rd = inst[11:7];
    assign opcode = inst[6:0];

    assign I_shift = {27'b0, inst[24:20]};
    assign I_imm = {{20{inst[31]}}, inst[31:20]};
    assign S_imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
    // assign B_imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8],1'b0};
    assign B_imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
    assign U_imm = {inst[31:12],{ 12{0}}};
    assign J_imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
    assign CSR_uimm = {27'b0,inst[19:15]};

    assign IS_R = (opcode == 7'b0110011);
    assign IS_IMM = (opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b1100111);
    assign IS_LUI = (opcode == 7'b0110111);
    assign IS_S = (opcode == 7'b0100011);
    assign IS_B = (opcode == 7'b1100011);
    assign IS_J = (opcode == 7'b1101111);
    assign IS_CSR = (opcode == 7'b1110011);

    always @(*) begin
        if (IS_R) ALU_OP = {func7[5], func3};
        else if (IS_IMM) ALU_OP = (func3 == 3'b101) ? {func7[5],func3} : {1'b0, func7};
    end

    reg [3:0]type;

    always @(*) begin
        case(opcode)
            //R
            7'b0110011: type = 4'd1;
            //I
            7'b0010011: type = 4'd2;
            7'b0000011: type = 4'd2;
            7'b1100111: type = 4'd2;
            //U
            7'b0010111: type = 4'd3;
            //S
            7'b0100011: type = 4'd4;
            //B
            7'b1100011: type = 4'd5;
            //J
            7'b1101111: type = 4'd6;
            //csr
            7'b1110011: type = 4'd7;
            default: type = 4'd0;
        endcase
    end

    always @(*) begin
        case(type)
            //R
            4'd1:imm = 32'b0;
            //I
            4'd2:imm = (func3 == 3 || func3 == 1) ? I_shift : I_imm;
            //U
            4'd3:imm = U_imm;
            //S
            4'd4:imm = S_imm;
            //B
            4'd5:imm = B_imm;
            //J
            4'd6:imm = J_imm;
            //csr
            4'd7:imm = CSR_uimm;
            default: imm = 32'b0;
        endcase
    end

endmodule