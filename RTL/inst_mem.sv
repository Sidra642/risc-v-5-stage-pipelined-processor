`timescale 1ns / 1ps

module Instruction_Memory (
 
    input  logic [31:0] read_address,
    output logic [31:0] instruction_out
);

    // Declare memory (128 x 32-bit)
    logic [31:0] I_Memory [0:127];
    //integer k;
    
    // Initialize / reset memory
    initial begin
        
           
           
            I_Memory[0]  <= 32'h00500113; 
            I_Memory[1]  <= 32'h00C00193; 
            I_Memory[2]  <= 32'hFF718393; 
            I_Memory[3] <= 32'h0023E233; 
            I_Memory[4] <= 32'h0041F2B3;
            I_Memory[5] <= 32'h004282B3; 
            I_Memory[6] <= 32'h02728863; 
            I_Memory[7] <= 32'h0041A233; 
            I_Memory[8] <= 32'h00020463; 
            I_Memory[9] <= 32'h00000293; 

            I_Memory[10] <= 32'h0023A233; 
            I_Memory[11] <= 32'h005203B3; 
            I_Memory[12] <= 32'h402383B3; 
            I_Memory[13] <= 32'h0471AA23; 
            I_Memory[14] <= 32'h06002103; 
            I_Memory[15] <= 32'h005104B3; 
            I_Memory[16] <= 32'h008001EF; 
            I_Memory[17] <= 32'h00100113; 
            I_Memory[18] <= 32'h00910133; 

            
            I_Memory[19] <= 32'h0221A023; // lw x22, 8(x1)
            I_Memory[20] <= 32'h00210063; // lb x23, 7(x1)
           /*   I_Memory[22] <= 32'b000000001001_00001_100_11000_0000011; // lbu x24, 9(x1)
            I_Memory[23] <= 32'b000000001100_00001_001_11001_0000011; // lh x25, 12(x1)
            I_Memory[24] <= 32'b000000001110_00001_101_11010_0000011; // lhu x26, 14(x1)

            // Store instructions (rs1=x1, rs2=x2)
            I_Memory[25]  <= 32'b0000000_00010_00001_010_10000_0100011; // sw x2, 16(x1)
            I_Memory[26] <= 32'b0000000_00010_00001_000_00101_0100011; // sb x2, 5(x1)
            I_Memory[27] <= 32'b0000000_00010_00001_001_10010_0100011; // sh x2, 18(x1)

            // Branch instructions (rs1=x1, rs2=x2)
            I_Memory[28] <= 32'b0_000000_00010_00001_000_1100_0_1100011; // beq x1, x2, 12
            I_Memory[29] <= 32'b0_000000_00010_00001_001_1100_0_1100011; // bne x1, x2, 12
            I_Memory[30] <= 32'b0_000000_00010_00001_100_1100_0_1100011; // blt x1, x2, 12
            I_Memory[31] <= 32'b0_000000_00010_00001_101_1100_0_1100011; // bge x1, x2, 12
            I_Memory[32] <= 32'b0_000000_00010_00001_110_1100_0_1100011; // bltu x1, x2, 12
            I_Memory[33] <= 32'b0_000000_00010_00001_111_1100_0_1100011; // bgeu x1, x2, 12

            // Jump instructions
            I_Memory[34] <= 32'b0_0000000000_0_00000000_11011_1101111; // jal x27, 0
            I_Memory[35] <= 32'b000000000000_00001_000_11100_1100111;   // jalr x28, 0(x1)

            // U-type instructions (rd sequential)
            I_Memory[28] <= 32'b00000000000000000000_11101_0110111;     // lui x29, 0
            I_Memory[29] <= 32'b00000000000000000000_11110_0010111;     // auipc x30, 0
            
            // More instructions using higher registers (x25 to x31)
            // I_Memory[152] <= 32'b0000000_00010_00001_000_11111_0110011;  // add x31, x1, x2*/
        end
   
    
    // Read instruction (word-aligned addresses only)
    assign instruction_out = I_Memory[read_address[31:2]];

endmodule