// Definitions
`timescale 10ns/1ps
// Test Stimulus
//
module stimulus;
  reg clk;
  wire[7:0] out;
  hello h1(clk,out);
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
    $dumpfile("top_tb.vcd");
    $dumpvars(0,clk);
    $dumpvars(1,out);
  end

endmodule
