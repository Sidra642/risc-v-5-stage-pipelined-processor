`timescale 1ns / 1ps


module forwarding_unit (
    input  logic [4:0] EX_rs1,      // ID/EX Rs1
    input  logic [4:0] EX_rs2,      // ID/EX Rs2
    input  logic [4:0] MEM_rd,      // EX/MEM Rd
    input  logic       MEM_RegWrite,// EX/MEM RegWrite control
    input  logic [4:0] WB_rd,       // MEM/WB Rd
    input  logic       WB_RegWrite, // MEM/WB RegWrite control

    output logic [1:0] forwardA,    // Control signals for mux before ALU input A
    output logic [1:0] forwardB     // Control signals for mux before ALU input B
);
    always_comb begin
        // Default: no forwarding
        forwardA = 2'b00;
        forwardB = 2'b00;

        // Check EX hazard (EX/MEM forwarding)
        if ((MEM_RegWrite == 1) && (MEM_rd != 0) && (MEM_rd == EX_rs1)) begin
            forwardA = 2'b10;
        end
        if ((MEM_RegWrite == 1) && (MEM_rd != 0) && (MEM_rd == EX_rs2)) begin
            forwardB = 2'b10;
        end

        // Check MEM hazard (MEM/WB forwarding) - only if EX hazard not present
        if ((WB_RegWrite == 1) && (WB_rd != 0) && 
            !(MEM_RegWrite == 1 && (MEM_rd != 0) && (MEM_rd == EX_rs1)) &&
            (WB_rd == EX_rs1)) begin
            forwardA = 2'b01;
        end
        if ((WB_RegWrite == 1) && (WB_rd != 0) &&
            !(MEM_RegWrite == 1 && (MEM_rd != 0) && (MEM_rd == EX_rs2)) &&
            (WB_rd == EX_rs2)) begin
            forwardB = 2'b01;
        end
    end
endmodule
