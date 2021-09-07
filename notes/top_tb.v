// Definitions
`timescale 10ns/1ps
// Test Stimulus
//
module sim;
  reg clk,reset,in;
  wire out;
  top top( .clk(clk), .reset(reset), .in(in), .out(out));
  integer tally=0;
  reg [2:0] sigtog;

  initial
  begin
     clk = 1'b0;
     in  = 1'b0;
     sigtog = 5'b0;
     #2 reset = 1'b0;
     #6 reset = 1'b1;
     #2 reset = 1'b0;
  end
  always
     #3 clk = ~clk;

  always @(posedge clk)
  begin
    if ( tally > 1000 )
      $finish;
    else
      tally <= tally + 1;

    if (sigtog == 7 )
      in = ~in;
    if (sigtog == 8 )
      in = ~in;

    sigtog <= sigtog + 1;
  end


  initial
  begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0,clk);
    $dumpvars(0,reset);
    $dumpvars(0,in);
    $dumpvars(0,out);
    $dumpvars(0,sigtog);
    $dumpvars(0,top.ded.state_current);
    $dumpvars(0,top.ded.last_in);
    $dumpvars(0,top.ded.in);
  end

endmodule