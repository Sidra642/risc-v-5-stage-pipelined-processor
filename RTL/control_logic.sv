`timescale 1ns / 1ps

module control_unit (
    input  logic       reset,
    input  logic [6:0] opcode,      // instruction[6:0]
    input  logic [2:0] funct3,      // instruction[14:12]
    input  logic       zero,        // ALU Zero flag
    input  logic       negative,    // ALU Negative flag (signed less-than)
    input  logic       carry,       // ALU Carry flag (for unsigned compare)
    input  logic       overflow,    // ALU Overflow flag (not always needed)

    // main control signals
    output logic       RegWrite,    
    output logic       ALUSrc,      
    output logic [1:0] ALUOp,      
    output logic       MemRead,    
    output logic       MemWrite,    
    output logic [1:0] MemtoReg,    

    // PC control
    output logic [1:0] jump         // 00 = PC+4, 01 = PC+offset, 10 = JALR
);

    // internal signals
    logic Branch;
    logic jal, jalr;
    logic branch_taken;

    always_comb begin
        // ---- default values (NOP) ----
        RegWrite = 0;
        ALUSrc   = 0;
        ALUOp    = 2'b00;
        MemRead  = 0;
        MemWrite = 0;
        MemtoReg = 2'b00;
        Branch   = 0;
        jal      = 0;
        jalr     = 0;
        branch_taken = 0;

        if (reset) begin
            // all outputs remain default (0)
        end
        else begin
            case (opcode)

                7'b0110011: begin // R-type
                    RegWrite = 1;
                    ALUSrc   = 0;
                    ALUOp    = 2'b10;
                    MemtoReg = 2'b00;
                end

                7'b0010011: begin // I-type ALU
                    RegWrite = 1;
                    ALUSrc   = 1;
                    ALUOp    = 2'b11;
                    MemtoReg = 2'b00;
                end

                7'b0000011: begin // Load
                    RegWrite = 1;
                    ALUSrc   = 1;
                    ALUOp    = 2'b00;
                    MemRead  = 1;
                    MemtoReg = 2'b01;
                end

                7'b0100011: begin // Store
                    ALUSrc   = 1;
                    ALUOp    = 2'b00;
                    MemWrite = 1;
                end

                7'b1100011: begin // Branch group
                    ALUSrc   = 0;
                    ALUOp    = 2'b01;  
                    Branch   = 1;

                    case (funct3)
                        3'b000: branch_taken = (zero == 1);       // BEQ
                        3'b001: branch_taken = (zero == 0);       // BNE
                        3'b100: branch_taken = (negative == 1);   // BLT (signed)
                        3'b101: branch_taken = (negative == 0);   // BGE (signed)
                        3'b110: branch_taken = (carry == 1);      // BLTU (unsigned)
                        3'b111: branch_taken = (carry == 0);      // BGEU (unsigned)
                        default: branch_taken = 0;
                    endcase
                end

                7'b1101111: begin // JAL
                    RegWrite = 1;      
                    ALUOp    = 2'b00;  
                    MemtoReg = 2'b10;  // PC+4
                    jal      = 1;
                end

                7'b1100111: begin // JALR
                    RegWrite = 1;      
                    ALUSrc   = 1;      // rs1 + imm
                    ALUOp    = 2'b00;
                    MemtoReg = 2'b10;  // PC+4
                    jalr     = 1;
                end

                7'b0110111: begin // LUI
                    RegWrite = 1;
                    ALUSrc   = 1;      // use immediate
                    ALUOp    = 2'b00;  
                    MemtoReg = 2'b11;  // imm << 12 (u_result)
                end

                7'b0010111: begin // AUIPC
                    RegWrite = 1;
                    ALUSrc   = 1;      // PC + imm
                    ALUOp    = 2'b00;  
                    MemtoReg = 2'b11;  // PC + imm (u_result)
                end
                
                default: begin
                    // all outputs remain default (0)
                end
            endcase
        end
    end

    // ---- Final Jump Decision ----
    always_comb begin
        if (reset) begin
            jump = 2'b00; // PC+4 on reset
        end
        else if (jal) begin
            jump = 2'b01; // JAL ? PC+offset
        end
        else if (jalr) begin
            jump = 2'b10; // JALR ? target
        end
        else if (Branch && branch_taken) begin
            jump = 2'b01; // Branch taken
        end
        else begin
            jump = 2'b00; // Default ? PC+4
        end
    end

endmodule