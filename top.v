// Definitions
`timescale 10ns/1ps

module double_edge_detect(clk,reset,in,out);
   input clk,in,reset;
   output out;
   reg out;
   reg [3:0] state_current, state_next;
   // Different triggered states
   reg [3:0]
      not_triggered = 3'b000,
      pos_triggered = 3'b001,
      neg_triggered = 3'b010,
      nxt_triggered = 3'b011;

    // when resetting, set the state back to not triggered, and also set
    // output to 0
   always @(reset)
     if ( reset )
       begin
         out <= 0;
         state_current  <= not_triggered;
       end
     else
       begin
         state_next <= state_current;
       end
     
   // Okay, now let's have things change based on the positive edge of the
   // clock
   always @(posedge clk)
   begin
      state_next = state_current;

      case( state_current )
        not_triggered:
          if ( in )
            begin
              state_next = pos_triggered;
              out = 1;
            end
          else
            begin
              state_next = neg_triggered;
              out = 1;
            end

        pos_triggered:
        begin
          state_next = nxt_triggered;
          out = 1;
        end

        neg_triggered:
        begin
          state_next = nxt_triggered;
          out = 1;
        end

        nxt_triggered:
        begin
          state_next = not_triggered;
          out = 0;
        end

      endcase
  end
endmodule
