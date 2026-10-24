`timescale 1ns / 1ps
module Register_File (
    input  logic        clk,
    input  logic        reset,
    input  logic        RegWrite,       // Write enable
    input  logic [4:0]  Rs1,            // Source register 1
    input  logic [4:0]  Rs2,            // Source register 2
    input  logic [4:0]  Rd,             // Destination register
    input  logic [31:0] Write_data,     // Data to write
    output logic [31:0] read_data1,     // Output from Rs1
    output logic [31:0] read_data2      // Output from Rs2
);

    // 32 registers, 32-bit wide
    logic [31:0] Registers [0:31];
    integer i;
    // Synchronous write (at clock edge)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            Registers[0]  <= 32'd0;   // x0 always 0
            Registers[1]  <= 32'd12;
            Registers[2]  <= 32'd24;
            Registers[3]  <= 32'd36;
            Registers[4]  <= 32'd48;
            Registers[5]  <= 32'd60;
            Registers[6]  <= 32'd72;
            Registers[7]  <= 32'd84;
            Registers[8]  <= 32'd96;
            Registers[9]  <= 32'd15;
            Registers[10] <= 32'd27;
            Registers[11] <= 32'd39;
            Registers[12] <= 32'd51;
            Registers[13] <= 32'd63;
            Registers[14] <= 32'd75;
            Registers[15] <= 32'd87;
            Registers[16] <= 32'd99;
            Registers[17] <= 32'd13;
            Registers[18] <= 32'd26;
            Registers[19] <= 32'd38;
            Registers[20] <= 32'd50;
            Registers[21] <= 32'd62;
            Registers[22] <= 32'd74;
            Registers[23] <= 32'd86;
            Registers[24] <= 32'd23;
            Registers[25] <= 32'd35;
            Registers[26] <= 32'd47;
            Registers[27] <= 32'd59;
            Registers[28] <= 32'd71;
            Registers[29] <= 32'd83;
            Registers[30] <= 32'd95;
            Registers[31] <= 32'd7;
       
           
        
        end
        else if (RegWrite && (Rd != 0)) begin
            Registers[Rd] <= Write_data;   // x0 is always 0
        end
    end

    // Combinational read
    always_comb begin
        read_data1 = Registers[Rs1];
        read_data2 = Registers[Rs2];
    end

endmodule

   