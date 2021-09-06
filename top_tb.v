// Definitions
`timescale 10ns/1ps
// Test Stimulus
//
module stimulus;
  reg clk,reset,in;
  wire out;
  double_edge_detect h1( .clk(clk), .reset(reset), .in(in), .out(out));
  integer tally=0;
  reg [2:0] sigtog;

  initial
  begin
     clk = 1'b0;
     in  = 1'b0;
     sigtog = 5'b0;
     #1 reset = 1'b0;
     #3 reset = 1'b1;
     #2 reset = 1'b0;
  end
  always
     #5 clk = ~clk;

  always @(posedge clk)
  begin
    if ( tally > 1000 )
      $finish;
    else
      tally <= tally + 1;

    if (sigtog == 0 )
      in = 1;
    
    if (sigtog == 2 )
      in = 0;

    sigtog <= sigtog + 1;
  end


  initial
  begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0,clk);
    $dumpvars(1,reset);
    $dumpvars(0,in);
    $dumpvars(0,out);
    $dumpvars(0,sigtog);
  end

endmodule
