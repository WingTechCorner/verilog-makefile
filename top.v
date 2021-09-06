// Definitions
`timescale 10ns/1ps

module double_edge_detect(clk,reset,in,out);
   input clk,in,reset;
   output out;
   reg last_in;
   reg out;
   reg [3:0] state_current, state_next;
   wire clk,in,reset;
   // Different triggered states
   reg [3:0]
      not_triggered = 3'b000,
      pos_triggered = 3'b001,
      pos_post      = 3'b011,
      neg_triggered = 3'b101,
      neg_post      = 3'b111;

    // when resetting, set the state back to not triggered, and also set
    // output to 0
   always @(posedge reset)
     if ( reset )
       begin
         out = 0;
         last_in = 0;
         state_current  = not_triggered;
       end
   
   always @(posedge in)
   begin
     if ( last_in == 0 )
     begin
       state_current = pos_triggered;
       last_in = 1;
     end
   end

   always @(negedge in)
   begin
     if ( last_in == 1 )
     begin
       state_current = neg_triggered;
       last_in = 0;
     end
   end

   // Okay, now let's have things change based on the positive edge of the
   // clock
   always @(posedge clk)
   begin
      state_next = state_current;

      case( state_current )
        not_triggered:
        begin
          if ( in == 0 )
          begin
            if ( last_in > 0 )
            begin
              // in = low, previously was high
              state_next = neg_triggered;
              last_in = in;
            end
            else
            begin
              // in = low and prev was low
              last_in = in;
            end
          end

          if ( in == 1 )
          begin
            if ( last_in < 1)
            begin
              // in = high, prev was low
              state_next = pos_triggered;
              last_in = in;
            end
            else
            begin
              // in = high, last was high
              last_in = in;
            end
          end
        end

        neg_triggered:
        begin
          out = 1;
          last_in = in;
          state_next = neg_post;
        end

        neg_post:
        begin
          out = 0;
          last_in = in;
          state_next = not_triggered;
        end

        pos_triggered:
        begin
          out = 1;
          last_in = in;
          state_next = pos_post;
        end

        pos_post:
        begin
          out = 0;
          last_in = in;
          state_next = not_triggered;
        end

/*
        default:
        begin
          state_next = not_triggered;
        end
*/
      endcase
  end
endmodule
