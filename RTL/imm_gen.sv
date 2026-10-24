  `timescale 1ns / 1ps

// Immediate Generator in SystemVerilog
module ImmGen (
    input  logic [6:0]  opcode,
    input  logic [31:0] instruction,
    output logic [31:0] ImmExt
);

    always_comb begin
        case (opcode)
            7'b0010011 :  // I-type (ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI)
                ImmExt = {{20{instruction[31]}}, instruction[31:20]};
            
            7'b0110011 :  // R-type (no immediate)
                ImmExt = 32'b0;
                
            7'b0000011 : 
                ImmExt = {{20{instruction[31]}}, instruction[31:20]}; //L-type
	    
	    	7'b0100011 : 
	    	    ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction [11:7]}; // s_type
	    
	    	7'b1100011 : 
	    	    ImmExt = {{20{instruction[31]}}, instruction[7],instruction [30:25], instruction [11:8], 1'b0}; //branch

            7'b1101111 : ImmExt = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-type
            
            7'b0110111 : ImmExt = {instruction[31:12], 12'b0}; // LUI
            
            7'b0010111 : ImmExt = {instruction[31:12], 12'b0}; // AUIPC

            default : 
                ImmExt = 32'b0;  // Default case
        endcase
    end

endmodule
