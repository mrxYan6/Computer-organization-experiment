`timescale 1ns / 1ps

module ID1(inst, rs1, rs2, rd, opcode, fun3, func7, imm);
    input [31:0]inst;
    output [4:0]rs1, rs2, rd;
    output [6:0]opcode;
    output [2:0]fun3;
    output [6:0]func7;
    output reg[31:0]imm;

    wire [31:0]I_shift, I_imm, S_imm, B_imm, U_imm, J_imm;

    assign func7 = inst[31:25];
    assign rs2 = inst[24:20];
    assign rs1 = inst[19:15];
    assign fun3 = inst[14:12];
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
            4'd2:imm = (opcode == 7'bb0010011 && (func3 == 3'b101 || func3 == 3'b001)) ? I_shift : I_imm;
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