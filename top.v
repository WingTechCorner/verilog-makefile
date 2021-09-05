// Definitions
`timescale 10ns/1ps
module hello(clk,out);
   output [7:0] out;
   input clk;
   reg out=0;
   always @(posedge clk)
     out <= out + 1;
endmodule
