module pc_mux (
    input  logic [31:0] pc_plus4,
    input  logic [31:0] pc_offset,
    input  logic [31:0] jalr_target,
    input  logic [1:0]  jump,        // from CU
    output logic [31:0] pc_next
);
    always_comb begin
        case (jump)
            2'b00: pc_next = pc_plus4;        // normal
            2'b01: pc_next = pc_offset;       // JAL or branch taken
            2'b10: pc_next = jalr_target;     // JALR target
            default: pc_next = pc_plus4;
        endcase
    end
endmodule