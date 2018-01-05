`timescale 1ns / 1ps
//Used for creating slight delay after pressing the button because humans arent perfect
//Debounces asynchronous btn_unstable into synchronous btn_stable.
module debouncer(master_clk,
		 btn_unstable,
		 btn_stable);

   input wire master_clk;
   input wire btn_unstable;
   output reg btn_stable;

   reg syncher0;
   reg syncher1;

   always @(posedge master_clk) // only do when master clock is running posedge
     begin
        syncher0 <= btn_unstable; // storing stability setting into temp variable
        syncher1 <= syncher0; // antialiasing
     end

   reg [15:0] count; // we can get away with messing with this value -- this tells us how much of a delay we allow
   
   always @(posedge master_clk)
     begin
        if(btn_stable == syncher1) // if the button is not stable again, like it was before, then continue creating the delay
            count <= 0;
        else // idle button because we havent pressed the button so both states are the same and havent changed
            begin
                count <= count + 1'b1;
                if (count == 16'hffff)
                    btn_stable <= ~btn_stable;
            end
     end
   
endmodule