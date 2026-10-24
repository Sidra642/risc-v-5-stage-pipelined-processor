`timescale 1ns / 1ps

// ALU Control in SystemVerilog
module ALU_Control (
    input  logic       fun7,        // funct7[5] bit (for SUB/SRA)
    input  logic [2:0] fun3,        // funct3 field
    input  logic [1:0] ALUOp,       // from Control Unit
    output logic [3:0] Control_out  // to ALU
);

    always_comb begin
        Control_out = 4'b0000; // default

        case (ALUOp)
            // =======================
            // R-type instructions (ALUOp = 2'b10)
            // =======================
            2'b10: begin
                case ({fun7, fun3})
                    // Arithmetic
                    4'b0_000: Control_out = 4'b0010; // ADD
                    4'b1_000: Control_out = 4'b0110; // SUB
                    
                    // Logical
                    4'b0_100: Control_out = 4'b0011; // XOR
                    4'b0_110: Control_out = 4'b0001; // OR
                    4'b0_111: Control_out = 4'b0000; // AND
                    
                    // Shifts
                    4'b0_001: Control_out = 4'b0100; // SLL
                    4'b0_101: Control_out = 4'b0101; // SRL
                    4'b1_101: Control_out = 4'b0111; // SRA
                    
                    // Comparisons
                    4'b0_010: Control_out = 4'b1000; // SLT
                    4'b0_011: Control_out = 4'b1001; // SLTU
                    
                    default: Control_out = 4'b0010; // Default to ADD
                endcase
            end

            // =======================
            // I-type instructions (ALUOp = 2'b11)
            // =======================
            2'b11: begin
                case (fun3)
                    3'b000: Control_out = 4'b0010; // ADDI
                    3'b100: Control_out = 4'b0011; // XORI
                    3'b110: Control_out = 4'b0001; // ORI
                    3'b111: Control_out = 4'b0000; // ANDI
                    3'b001: Control_out = 4'b0100; // SLLI
                    3'b101: Control_out = (fun7) ? 4'b0111 : 4'b0101; // SRAI : SRLI
                    3'b010: Control_out = 4'b1000; // SLTI
                    3'b011: Control_out = 4'b1001; // SLTIU
                    default: Control_out = 4'b0010; // Default to ADDI
                endcase
            end

            // =======================
            // Load/Store instructions (ALUOp = 2'b00)
            // =======================
            2'b00: Control_out = 4'b0010; // ADD (for address calculation)

            // =======================
            // Branch instructions (ALUOp = 2'b01)
            // =======================
            2'b01: Control_out = 4'b0110; // SUB (for comparison)

            // =======================
            // JAL/JALR/LUI/AUIPC (ALUOp handled by control unit)
            // =======================
            default: Control_out = 4'b0010; // Default to ADD
        endcase
    end

endmodule