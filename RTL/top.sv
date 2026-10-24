`timescale 1ns / 1ps

module top_pipelined (
    input logic clk,
    input logic reset
);

    // === IF Stage Wires ===
    logic [31:0] PC_IF, PC_next_IF, instruction_IF;
    logic PCWrite;  // From hazard detection

    // === IF/ID Pipeline Register Wires ===
    logic [31:0] PC_ID, instruction_ID;
    logic IF_ID_Write;  // From hazard detection

    // === ID Stage Wires ===
    logic [31:0] Rd1_ID, Rd2_ID;
    logic [31:0] ImmExt_ID, raw_imm_ID, shifted_imm_ID;
    logic [4:0] Rs1_ID, Rs2_ID, Rd_ID;
    logic RegWrite_ID, ALUSrc_ID, MemWrite_ID, MemRead_ID;
    logic [1:0] ALUOp_ID, MemtoReg_ID, jump_ID;
    logic [2:0] funct3_ID;
    logic fun7_ID;
    logic [3:0] control_ID;
    logic zero_EX, negative_EX, carry_EX, overflow_EX;
    logic shift_en_ID;
    logic stall;  // From hazard detection

    // === ID/EX Pipeline Register Wires ===
    logic [31:0] PC_EX, Rd1_EX, Rd2_EX, ImmExt_EX;
    logic [4:0] Rs1_EX, Rs2_EX, Rd_EX;
    logic RegWrite_EX, ALUSrc_EX, MemWrite_EX, MemRead_EX;
    logic [1:0] ALUOp_EX, MemtoReg_EX, jump_EX;
    logic [2:0] funct3_EX;
    logic fun7_EX;
    logic [3:0] control_EX;

    // === EX Stage Wires ===
    logic [31:0] mux1_EX, ALU_result_EX, branch_target_EX, jalr_target_EX;
    logic [31:0] forwardA_mux_out, forwardB_mux_out;
    logic zero_EX_stage, negative_EX_stage, carry_EX_stage, overflow_EX_stage;
    logic [1:0] forwardA, forwardB;  // From forwarding unit

    // === EX/MEM Pipeline Register Wires ===
    logic [31:0] ALU_result_MEM, Rd2_MEM, PC_branch_MEM;
    logic [4:0] Rd_MEM;
    logic RegWrite_MEM, MemWrite_MEM, MemRead_MEM;
    logic [1:0] MemtoReg_MEM, jump_MEM;

    // === MEM Stage Wires ===
    logic [31:0] DataMem_out_MEM;

    // === MEM/WB Pipeline Register Wires ===
    logic [31:0] MemData_WB, ALU_result_WB;
    logic [4:0] Rd_WB;
    logic RegWrite_WB;
    logic [1:0] MemtoReg_WB;

    // === WB Stage Wires ===
    logic [31:0] WriteBack_WB;

    // ============== Hazard Detection Unit ==============
    hazard_detection_unit hazard_unit (
        .ID_EX_MemRead(MemRead_EX),
        .ID_EX_Rd(Rd_EX),
        .IF_ID_Rs1(Rs1_ID),
        .IF_ID_Rs2(Rs2_ID),
        .stall(stall),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write)
    );

    // ============== Forwarding Unit ==============
    forwarding_unit forwarding_unit (
        .EX_rs1(Rs1_EX),
        .EX_rs2(Rs2_EX),
        .MEM_rd(Rd_MEM),
        .MEM_RegWrite(RegWrite_MEM),
        .WB_rd(Rd_WB),
        .WB_RegWrite(RegWrite_WB),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    // ============== IF Stage ==============

    program_counter PC_inst (
        .clk(clk),
        .reset(reset),
        .PC_in(PC_next_IF),
        .PC_out(PC_IF),
        .PCWrite(PCWrite)  // Add PCWrite input to program_counter
    );

    PC_plus4 PC_plus4_inst (
        .fromPC(PC_IF),
        .NextoPC(PC_next_IF)
    );

    Instruction_Memory Inst_Mem (
        .read_address(PC_IF),
        .instruction_out(instruction_IF)
    );

    // IF/ID Pipeline Register
    IF_ID_reg IF_ID_reg_inst (
        .clk(clk),
        .reset(reset),
        .PC_in(PC_IF),
        .instruction_in(instruction_IF),
        .PC_out(PC_ID),
        .instruction_out(instruction_ID),
        .IF_ID_Write(IF_ID_Write)  // Add write enable
    );

    // ============== ID Stage ==============

    // Extract fields from instruction
    assign Rs1_ID = instruction_ID[19:15];
    assign Rs2_ID = instruction_ID[24:20];
    assign Rd_ID  = instruction_ID[11:7];
    assign funct3_ID = instruction_ID[14:12];
    assign fun7_ID = instruction_ID[30];
    assign shift_en_ID = (instruction_ID[6:0] == 7'b1101111) || (instruction_ID[6:0] == 7'b1100111);

    Register_File Reg_File_ID (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite_WB),
        .Rs1(Rs1_ID),
        .Rs2(Rs2_ID),
        .Rd(Rd_WB),
        .Write_data(WriteBack_WB),
        .read_data1(Rd1_ID),
        .read_data2(Rd2_ID)
    );

    ImmGen ImmGen_ID (
        .opcode(instruction_ID[6:0]),
        .instruction(instruction_ID),
        .ImmExt(raw_imm_ID)
    );

    Imm_Shifter Imm_Shifter_ID (
        .imm_in(raw_imm_ID),
        .shift_en(shift_en_ID),
        .imm_out(shifted_imm_ID)
    );

    assign ImmExt_ID = shifted_imm_ID;

    control_unit Control_unit_ID (
        .reset(reset),
        .opcode(instruction_ID[6:0]),
        .funct3(funct3_ID),
        .zero(1'b0),
        .negative(1'b0),
        .carry(1'b0),
        .overflow(1'b0),
        .RegWrite(RegWrite_ID),
        .ALUSrc(ALUSrc_ID),
        .ALUOp(ALUOp_ID),
        .MemRead(MemRead_ID),
        .MemWrite(MemWrite_ID),
        .MemtoReg(MemtoReg_ID),
        .jump(jump_ID)
    );

    ALU_Control ALU_Control_ID (
        .fun7(fun7_ID),
        .fun3(funct3_ID),
        .ALUOp(ALUOp_ID),
        .Control_out(control_ID)
    );

    // ID/EX Pipeline Register
    ID_EX_reg ID_EX_reg_inst (
        .clk(clk),
        .reset(reset),
        .PC_in(PC_ID),
        .Rd1_in(Rd1_ID),
        .Rd2_in(Rd2_ID),
        .ImmExt_in(ImmExt_ID),
        .Rs1_in(Rs1_ID),
        .Rs2_in(Rs2_ID),
        .Rd_in(Rd_ID),
        .RegWrite_in(RegWrite_ID),
        .ALUSrc_in(ALUSrc_ID),
        .MemRead_in(MemRead_ID),
        .MemWrite_in(MemWrite_ID),
        .ALUOp_in(ALUOp_ID),
        .MemtoReg_in(MemtoReg_ID),
        .jump_in(jump_ID),
        .funct3_in(funct3_ID),
        .fun7_in(fun7_ID),
        .PC_out(PC_EX),
        .Rd1_out(Rd1_EX),
        .Rd2_out(Rd2_EX),
        .ImmExt_out(ImmExt_EX),
        .Rs1_out(Rs1_EX),
        .Rs2_out(Rs2_EX),
        .Rd_out(Rd_EX),
        .RegWrite_out(RegWrite_EX),
        .ALUSrc_out(ALUSrc_EX),
        .MemRead_out(MemRead_EX),
        .MemWrite_out(MemWrite_EX),
        .ALUOp_out(ALUOp_EX),
        .MemtoReg_out(MemtoReg_EX),
        .jump_out(jump_EX),
        .funct3_out(funct3_EX),
        .fun7_out(fun7_EX),
        .stall(stall)  // Add stall input
    );

    // ============== EX Stage ==============

    // Forwarding MUX for ALU input A
    always_comb begin
        case (forwardA)
            2'b00: forwardA_mux_out = Rd1_EX;        // No forwarding
            2'b01: forwardA_mux_out = WriteBack_WB;  // Forward from WB stage
            2'b10: forwardA_mux_out = ALU_result_MEM; // Forward from MEM stage
            default: forwardA_mux_out = Rd1_EX;
        endcase
    end

    // Forwarding MUX for ALU input B (before ALU source mux)
    always_comb begin
        case (forwardB)
            2'b00: forwardB_mux_out = Rd2_EX;        // No forwarding
            2'b01: forwardB_mux_out = WriteBack_WB;  // Forward from WB stage
            2'b10: forwardB_mux_out = ALU_result_MEM; // Forward from MEM stage
            default: forwardB_mux_out = Rd2_EX;
        endcase
    end

    // ALU MUX selects between forwarded Rd2_EX and immediate value
    Mux1 ALU_mux_EX (
        .sel1(ALUSrc_EX),
        .A1(forwardB_mux_out),  // Use forwarded value
        .B1(ImmExt_EX),
        .Mux1_out(mux1_EX)
    );

    ALU ALU_EX (
        .A(forwardA_mux_out),   // Use forwarded value
        .B(mux1_EX),
        .Control_in(control_ID),
        .ALU_Result(ALU_result_EX),
        .zero(zero_EX_stage),
        .negative(negative_EX_stage),
        .carry(carry_EX_stage),
        .overflow(overflow_EX_stage)
    );

    // Branch target calculation
    assign branch_target_EX = PC_EX + ImmExt_EX;

    // JALR target calculation
    assign jalr_target_EX = forwardA_mux_out + ImmExt_EX;  // Use forwarded value

    // EX/MEM Pipeline Register
EX_MEM_reg EX_MEM_reg_inst (
    .clk(clk),
    .reset(reset),
    .ALU_result_in(ALU_result_EX),
    .Rd2_in(forwardB_mux_out),
    .Rd_in(Rd_EX),
    .RegWrite_in(RegWrite_EX),
    .MemRead_in(MemRead_EX),
    .MemWrite_in(MemWrite_EX),
    .MemtoReg_in(MemtoReg_EX),
    .jump_in(jump_EX),              // Changed from jump_in to jump_in
    .PC_branch_in(branch_target_EX), // Changed from PC_branch_in to PC_branch_in
    .ALU_result_out(ALU_result_MEM),
    .Rd2_out(Rd2_MEM),
    .Rd_out(Rd_MEM),
    .RegWrite_out(RegWrite_MEM),
    .MemRead_out(MemRead_MEM),
    .MemWrite_out(MemWrite_MEM),
    .MemtoReg_out(MemtoReg_MEM),
    .jump_out(jump_MEM),            // Changed from jump_out to jump_out
    .PC_branch_out(PC_branch_MEM)   // Changed from PC_branch_out to PC_branch_out
);


    // ============== MEM Stage ==============

    Data_Memory Data_Mem_inst (
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite_MEM),
        .MemRead(MemRead_MEM),
        .funct3(funct3_EX),
        .read_address(ALU_result_MEM),
        .Write_data(Rd2_MEM),
        .MemData_out(DataMem_out_MEM)
    );

    // MEM/WB Pipeline Register
MEM_WB_reg MEM_WB_reg_inst (
    .clk(clk),
    .reset(reset),
    .MemData_in(DataMem_out_MEM),   // Changed from MemData_in to MemData_in
    .ALU_result_in(ALU_result_MEM),
    .Rd_in(Rd_MEM),
    .RegWrite_in(RegWrite_MEM),
    .MemtoReg_in(MemtoReg_MEM),
    .MemData_out(MemData_WB),       // Changed from MemData_out to MemData_out
    .ALU_result_out(ALU_result_WB),
    .Rd_out(Rd_WB),
    .RegWrite_out(RegWrite_WB),
    .MemtoReg_out(MemtoReg_WB)
);
    // ============== WB Stage ==============

    Mux3 WriteBack_mux_WB (
        .sel3(MemtoReg_WB),
        .A3(ALU_result_WB),
        .B3(MemData_WB),
        .C3(PC_next_IF),
        .D3(32'b0),
        .Mux3_out(WriteBack_WB)
    );

endmodule