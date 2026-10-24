`timescale 1ns / 1ps

module AND_logic (
    input  logic branch,
    input  logic zero,
    output logic and_out
);

    assign and_out = branch & zero;

endmodule
