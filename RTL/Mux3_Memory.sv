`timescale 1ns / 1ps

module Mux3 (
    input  logic [1:0]  sel3,         // 2-bit select (MemtoReg)
    input  logic [31:0] A3,           // 00 -> ALU result
    input  logic [31:0] B3,           // 01 -> Data memory
    input  logic [31:0] C3,           // 10 -> PC+4 (for JAL/JALR)
    input  logic [31:0] D3,           // 11 -> u_result (imm<<12 for LUI or PC+imm for AUIPC)
    output logic [31:0] Mux3_out
);

    always_comb begin
        case (sel3)
            2'b00: Mux3_out = A3;    // ALU result
            2'b01: Mux3_out = B3;    // Load result from memory
            2'b10: Mux3_out = C3;    // PC+4 for JAL/JALR
            2'b11: Mux3_out = D3;    // u_result for LUI/AUIPC
            default: Mux3_out = A3;  // default safe case (ALU result)
        endcase
    end

endmodule