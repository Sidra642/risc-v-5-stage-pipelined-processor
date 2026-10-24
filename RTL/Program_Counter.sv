module program_counter (
    input logic clk,
    input logic reset,
    input logic [31:0] PC_in,
    input logic PCWrite,  // New input
    output logic [31:0] PC_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_out <= 32'b0;
        end else if (PCWrite) begin  // Only update if PCWrite is enabled
            PC_out <= PC_in;
        end
    end
endmodule