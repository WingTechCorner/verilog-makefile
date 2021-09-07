// top.v - top level verilog file
`timescale 10ns/1ps

module top(clk,reset,in,out);

  input clk,reset,in;
  output out;

  reg out;
  wire ded_out;
  wire clk,reset,in;
  
  always @(*)
    out <= ded_out;

  double_edge_detect ded(.clk(clk),.reset(reset),.in(in),.out(ded_out)); // Instantiate the double edge detect

endmodule
