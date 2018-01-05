`timescale 1ns / 1ps

//Module that makes clk_new a clock signal with frequency freq_new/10, assuming master_clk is 100MHz.
module clock_converter(
               master_clk,
		       freq_new,
		       clk_new);

   input wire master_clk;
   input wire [26:0] freq_new;
   output reg clk_new;

   reg [26:0] counter;
   wire [26:0] toggle_on_reach = 50000000/freq_new;
	
	initial
	begin
		clk_new = 0;
		counter = 27'b0;
	end
   
   always @ (posedge master_clk)
     begin
	if (counter == toggle_on_reach)
	  begin
	     clk_new <= ~clk_new;
	     counter <= 0;
	  end
	else
	  counter <= counter + 1;
     end

endmodule