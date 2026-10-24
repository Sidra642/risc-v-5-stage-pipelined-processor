`timescale 1ns / 1ps

// Left Shifter Module for Jump Instructions
module Imm_Shifter (
    input  logic [31:0] imm_in,     // Immediate input
    input  logic        shift_en,   // 1 = shift for jump, 0 = pass through
    output logic [31:0] imm_out     // Shifted or original immediate
);

    always_comb begin
        if (shift_en) begin
            // Left shift by 1 bit (for jump offset calculation)
            imm_out = {imm_in[30:0], 1'b0};
        end else begin
            // Pass through unchanged
            imm_out = imm_in;
        end
    end

endmodule