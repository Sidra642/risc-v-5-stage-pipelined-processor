`timescale 1ns / 1ps

module Data_Memory #(
    parameter DEPTH_WORDS = 32   // number of 32-bit words
)(
    input  logic        clk,
    input  logic        reset,
    input  logic        MemWrite,
    input  logic        MemRead,
    input  logic [2:0]  funct3,       // load/store type (RISC-V funct3)
    input  logic [31:0] read_address, // byte address
    input  logic [31:0] Write_data,   // rs2 value
    output logic [31:0] MemData_out
);

    localparam int ADDR_W = $clog2(DEPTH_WORDS);

    // 32-bit word memory
    logic [31:0] D_Memory [0:DEPTH_WORDS-1];

    // --- Address decode ---
    wire [ADDR_W-1:0] widx     = read_address[ADDR_W+1:2]; // word index (drop 2 LSBs)
    wire [1:0]        byte_off = read_address[1:0];        // byte offset inside word

    // --- READ path ---
    logic [31:0] word_r;
    logic [7:0]  byte_sel;
    logic [15:0] half_sel;

    always_comb begin
        word_r   = D_Memory[widx];
        MemData_out = 32'h0;

        // select byte and halfword
        byte_sel = (byte_off == 2'b00) ? word_r[7:0]   :
                   (byte_off == 2'b01) ? word_r[15:8]  :
                   (byte_off == 2'b10) ? word_r[23:16] :
                                         word_r[31:24];

        half_sel = (byte_off[1]==1'b0) ? word_r[15:0] : word_r[31:16];

        if (MemRead) begin
            unique case (funct3)
                3'b000: MemData_out = {{24{byte_sel[7]}}, byte_sel};   // lb
                3'b100: MemData_out = {24'b0, byte_sel};               // lbu
                3'b001: MemData_out = {{16{half_sel[15]}}, half_sel};  // lh
                3'b101: MemData_out = {16'b0, half_sel};               // lhu
                3'b010: MemData_out = word_r;                          // lw
                default: MemData_out = 32'h0;
            endcase
        end
    end

    // --- WRITE path ---
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            unique case (funct3)
                3'b000: begin // sb
                    case (byte_off)
                        2'b00: D_Memory[widx][7:0]   <= Write_data[7:0];
                        2'b01: D_Memory[widx][15:8]  <= Write_data[7:0];
                        2'b10: D_Memory[widx][23:16] <= Write_data[7:0];
                        2'b11: D_Memory[widx][31:24] <= Write_data[7:0];
                    endcase
                end
                3'b001: begin // sh
                    if (byte_off[0]==1'b0) begin
                        if (byte_off[1]==1'b0)
                            D_Memory[widx][15:0]  <= Write_data[15:0];
                        else
                            D_Memory[widx][31:16] <= Write_data[15:0];
                    end
                end
                3'b010: begin // sw
                    if (byte_off==2'b00)
                        D_Memory[widx] <= Write_data;
                end
            endcase
        end
    end

    // --- Preload memory contents ---
    initial begin
        D_Memory[0]  = 32'h00000000;
        D_Memory[1]  = 32'h00000004;
        D_Memory[2]  = 32'h00000002;
        D_Memory[3]  = 32'h00000018;
        D_Memory[4]  = 32'h00000004;
        D_Memory[5]  = 32'h00000001;
        D_Memory[6]  = 32'h0000002C;
        D_Memory[7]  = 32'h00000004;
        D_Memory[8]  = 32'h00000002;
        D_Memory[9]  = 32'h00000001;
        D_Memory[10] = 32'h00000017;
        D_Memory[11] = 32'h00000004;
        D_Memory[12] = 32'h00000009;
        D_Memory[13] = 32'h00000001;
        D_Memory[14] = 32'h00000002;
        D_Memory[15] = 32'h00000003;
        D_Memory[16] = 32'h00000004;
        D_Memory[17] = 32'h00000005;
        D_Memory[18] = 32'h00000006;
        D_Memory[19] = 32'h00000003;
        D_Memory[20] = 32'h00000004;
        D_Memory[21] = 32'h00000005;
        D_Memory[22] = 32'h00000006;
        D_Memory[23] = 32'h00000003;
        D_Memory[24] = 32'h00000004;
        D_Memory[25] = 32'h00000005;
        D_Memory[26] = 32'h00000006;
        D_Memory[27] = 32'h00000003;
        D_Memory[28] = 32'h00000004;
        D_Memory[29] = 32'h00000005;
        D_Memory[30] = 32'h00000006;
        D_Memory[31] = 32'h00000003;
    end

endmodule
