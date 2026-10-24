`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2025 02:34:28 PM
// Design Name: 
// Module Name: IF_ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module IF_ID_reg (
    input logic clk,
    input logic reset,
    input logic [31:0] PC_in,
    input logic [31:0] instruction_in,
    input logic IF_ID_Write,  // New input
    output logic [31:0] PC_out,
    output logic [31:0] instruction_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_out <= 32'b0;
            instruction_out <= 32'b0;
        end else if (IF_ID_Write) begin  // Only update if write is enabled
            PC_out <= PC_in;
            instruction_out <= instruction_in;
        end
    end
endmodule
