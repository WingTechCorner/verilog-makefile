// Definitions
`timescale 10ns/1ps
// Test Stimulus
//
module stimulus;
  reg clk;
  reg reset;
  wire[3:0] q;
  ripple_carry_counter r1(q,clk,reset);
  integer tally=0;

  initial
     clk = 1'b0;
  always
     #5 clk = ~clk;

  always @(posedge clk)
    if ( tally > 1000 )
      $finish;
    else
      tally <= tally + 1;

  initial
  begin
     reset = 1'b1;
     #15 reset = 1'b0;
     #180 reset = 1'b1;
     #10 reset = 1'b0;
  end

  initial
  begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0,q);
    $dumpvars(1,reset);
    $dumpvars(2,clk);
  end

endmodule
