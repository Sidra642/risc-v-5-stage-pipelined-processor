`timescale 1ns / 1ps
module EX_MEM_reg (
    input logic clk,
    input logic reset,
    input logic [31:0] ALU_result_in,
    input logic [31:0] Rd2_in,
    input logic [4:0] Rd_in,
    input logic RegWrite_in,
    input logic MemRead_in,
    input logic MemWrite_in,
    input logic [1:0] MemtoReg_in,
    input logic [1:0] jump_in,           // Added jump_in
    input logic [31:0] PC_branch_in,     // Added PC_branch_in
    output logic [31:0] ALU_result_out,
    output logic [31:0] Rd2_out,
    output logic [4:0] Rd_out,
    output logic RegWrite_out,
    output logic MemRead_out,
    output logic MemWrite_out,
    output logic [1:0] MemtoReg_out,
    output logic [1:0] jump_out,         // Added jump_out
    output logic [31:0] PC_branch_out    // Added PC_branch_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            ALU_result_out <= 32'b0;
            Rd2_out <= 32'b0;
            Rd_out <= 5'b0;
            RegWrite_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            MemtoReg_out <= 2'b0;
            jump_out <= 2'b0;
            PC_branch_out <= 32'b0;
        end else begin
            ALU_result_out <= ALU_result_in;
            Rd2_out <= Rd2_in;
            Rd_out <= Rd_in;
            RegWrite_out <= RegWrite_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            MemtoReg_out <= MemtoReg_in;
            jump_out <= jump_in;
            PC_branch_out <= PC_branch_in;
        end
    end
endmodule
