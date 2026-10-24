`timescale 1ns / 1ps
module ID_EX_reg (
    input logic clk,
    input logic reset,
    input logic [31:0] PC_in,
    input logic [31:0] Rd1_in,
    input logic [31:0] Rd2_in,
    input logic [31:0] ImmExt_in,
    input logic [4:0] Rs1_in,
    input logic [4:0] Rs2_in,
    input logic [4:0] Rd_in,
    input logic RegWrite_in,
    input logic ALUSrc_in,
    input logic MemRead_in,
    input logic MemWrite_in,
    input logic [1:0] ALUOp_in,
    input logic [1:0] MemtoReg_in,
    input logic [1:0] jump_in,
    input logic [2:0] funct3_in,
    input logic fun7_in,
    input logic stall,  // New input
    output logic [31:0] PC_out,
    output logic [31:0] Rd1_out,
    output logic [31:0] Rd2_out,
    output logic [31:0] ImmExt_out,
    output logic [4:0] Rs1_out,
    output logic [4:0] Rs2_out,
    output logic [4:0] Rd_out,
    output logic RegWrite_out,
    output logic ALUSrc_out,
    output logic MemRead_out,
    output logic MemWrite_out,
    output logic [1:0] ALUOp_out,
    output logic [1:0] MemtoReg_out,
    output logic [1:0] jump_out,
    output logic [2:0] funct3_out,
    output logic fun7_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs
            PC_out <= 32'b0;
            Rd1_out <= 32'b0;
            Rd2_out <= 32'b0;
            ImmExt_out <= 32'b0;
            Rs1_out <= 5'b0;
            Rs2_out <= 5'b0;
            Rd_out <= 5'b0;
            RegWrite_out <= 1'b0;
            ALUSrc_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            ALUOp_out <= 2'b0;
            MemtoReg_out <= 2'b0;
            jump_out <= 2'b0;
            funct3_out <= 3'b0;
            fun7_out <= 1'b0;
        end else if (stall) begin
            // Insert NOP (bubble) when stalled
            RegWrite_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            // Keep other values as they are (or set to safe values)
        end else begin
            // Normal operation
            PC_out <= PC_in;
            Rd1_out <= Rd1_in;
            Rd2_out <= Rd2_in;
            ImmExt_out <= ImmExt_in;
            Rs1_out <= Rs1_in;
            Rs2_out <= Rs2_in;
            Rd_out <= Rd_in;
            RegWrite_out <= RegWrite_in;
            ALUSrc_out <= ALUSrc_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            ALUOp_out <= ALUOp_in;
            MemtoReg_out <= MemtoReg_in;
            jump_out <= jump_in;
            funct3_out <= funct3_in;
            fun7_out <= fun7_in;
        end
    end
endmodule
           
