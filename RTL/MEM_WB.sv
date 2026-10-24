`timescale 1ns / 1ps
module MEM_WB_reg (
    input logic clk,
    input logic reset,
    input logic [31:0] MemData_in,      // Changed from MemData_in
    input logic [31:0] ALU_result_in,
    input logic [4:0] Rd_in,
    input logic RegWrite_in,
    input logic [1:0] MemtoReg_in,
    output logic [31:0] MemData_out,    // Changed from MemData_out
    output logic [31:0] ALU_result_out,
    output logic [4:0] Rd_out,
    output logic RegWrite_out,
    output logic [1:0] MemtoReg_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            MemData_out <= 32'b0;
            ALU_result_out <= 32'b0;
            Rd_out <= 5'b0;
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 2'b0;
        end else begin
            MemData_out <= MemData_in;
            ALU_result_out <= ALU_result_in;
            Rd_out <= Rd_in;
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
        end
    end
endmodule
