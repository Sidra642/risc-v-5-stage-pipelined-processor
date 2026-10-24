// Testbench for top module
module tb_top;
reg clk, reset;
top_pipelined uut (.clk(clk), .reset(reset)); // Instantiating the top module
  
  // Initialize clock and reset
initial begin
clk = 0;
reset = 1;
#10; // Hold reset high for a short duration
reset = 0;
#4000; // Run the simulation for some time
//$finish; // End the simulation
end

  // Clock generation
always begin
#5 clk = ~clk; // Toggle clock every 5 time units

end

initial begin
$dumpfile("tb.vcd");
$dumpvars(0, tb_top);
end
endmodule
