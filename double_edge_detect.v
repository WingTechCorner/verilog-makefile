// Definitions
`timescale 10ns/1ps


module double_edge_detect(clk,reset,in,out);
   input clk,in,reset;
   output out;
   reg last_in;
   reg out;
   reg [2:0] state_current, state_next;
   wire clk,in,reset;
   // Different triggered states
   localparam [2:0]
      not_triggered_neg = 3'b000,
      pos_triggered     = 3'b001,
      pos_one_clk       = 3'b010,
      pos_post          = 3'b011,
      not_triggered_pos = 3'b100,
      neg_triggered     = 3'b101,
      neg_one_clk       = 3'b110,
      neg_post          = 3'b111;

    // when resetting, set the state back to not triggered, and also set
    // output to 0
   always @(posedge reset)
     if ( reset )
       begin
         out = 0;
         last_in = 0;
         state_current  = not_triggered_neg;
       end

   // Okay, now let's have things change based on the positive edge of the
   // clock
   always @(negedge clk)
   begin
     state_current = state_next;
   end

   always @(posedge clk)
   begin
     state_next = state_current;
      case (state_current)
        not_triggered_neg:
        begin
          state_next = state_next + in;
        end

        pos_triggered:
        begin
          out = 1;
          state_next = state_next + 1;
        end

        pos_one_clk:
        begin
          out = 0;
          state_next = state_next + 1;
        end

        pos_post:
        begin
          state_next = state_next + 1;
        end

        not_triggered_pos:
        begin
          state_next = state_next + ( 1 - in );
        end

        neg_triggered:
        begin
          out = 1;
          state_next = state_next + 1;
        end

        neg_one_clk:
        begin
          out = 0;
          state_next = state_next + 1;
        end

        neg_post:
        begin
          state_next = state_next + 1;
        end

      endcase
  end
endmodule
