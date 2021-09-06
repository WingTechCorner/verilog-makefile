// Definitions
`timescale 10ns/1ps
// Test Stimulus
//
module stimulus;
  reg clk,reset,in;
  wire out;
  double_edge_detect h1( .clk(clk), .reset(reset), .in(in), .out(out));
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
    $dumpvars(1,reset);
    $dumpvars(2,in);
    $dumpvars(3,out);
  end

endmodule
