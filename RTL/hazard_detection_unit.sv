`timescale 1ns / 1ps

module hazard_detection_unit (
    input logic ID_EX_MemRead,     // ID/EX MemRead signal
    input logic [4:0] ID_EX_Rd,    // ID/EX destination register
    input logic [4:0] IF_ID_Rs1,   // IF/ID source register 1
    input logic [4:0] IF_ID_Rs2,   // IF/ID source register 2

    output logic stall,            // Stall signal to control pipeline registers and PC
    output logic PCWrite,          // PC write enable
    output logic IF_ID_Write       // IF/ID pipeline register write enable
);

    always_comb begin
        // Default: no stall
        stall = 0;
        PCWrite = 1;
        IF_ID_Write = 1;

        if ((ID_EX_MemRead == 1) && 
           ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2))) begin
            stall = 1;
            PCWrite = 0;
            IF_ID_Write = 0;
        end
    end
endmodule
