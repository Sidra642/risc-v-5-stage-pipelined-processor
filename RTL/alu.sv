`timescale 1ns / 1ps

module ALU (
    input  logic [31:0] A, B,
    input  logic [3:0]  Control_in,
    output logic [31:0] ALU_Result,
    output logic        zero,
    output logic        negative,   // 1 if A < B (signed)
    output logic        carry,      // 1 if A < B (unsigned)
    output logic        overflow    // 1 if signed overflow (ADD/SUB)
);

    always_comb begin
        // Default values
        ALU_Result = 32'b0;
        
        case (Control_in)
            // --- Arithmetic ---
            4'b0010: ALU_Result = A + B;                      // ADD / ADDI / Load / Store / JAL / JALR
            4'b0110: ALU_Result = A - B;                      // SUB (for BEQ, BNE, R-type SUB)
            
            // --- Logic ---
            4'b0000: ALU_Result = A & B;                      // AND / ANDI
            4'b0001: ALU_Result = A | B;                      // OR / ORI
            4'b0011: ALU_Result = A ^ B;                      // XOR / XORI
            
            // --- Shifts ---
            4'b0100: ALU_Result = A << B[4:0];                // SLL / SLLI
            4'b0101: ALU_Result = A >> B[4:0];                // SRL / SRLI
            4'b0111: ALU_Result = $signed(A) >>> B[4:0];      // SRA / SRAI
            
            // --- Comparisons (for ALU instructions) ---
            4'b1000: ALU_Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT / SLTI
            4'b1001: ALU_Result = (A < B) ? 32'd1 : 32'd0;    // SLTU / SLTIU

            // --- Default ---
            default: ALU_Result = 32'b0;
        endcase
    end

    // ---------------- Flags ----------------
    assign zero     = (ALU_Result == 32'b0);                  // BEQ / BNE
    assign negative = ($signed(A) < $signed(B));              // BLT / BGE
    assign carry    = (A < B);                                // BLTU / BGEU
    
    // Overflow detection for ADD and SUB operations only
    assign overflow = ((Control_in == 4'b0010) || (Control_in == 4'b0110)) ?
                     ((A[31] == B[31] ^ (Control_in == 4'b0110)) && (ALU_Result[31] != A[31])) : 1'b0;

endmodule