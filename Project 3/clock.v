`timescale 1ns / 1ps

//Outputs 4 types of clock signals, assuming master_clk input is 100MHz.
module all_clock(master_clk,
		 clk_2hz,
		 clk_cycle,
		 clk_blink);

   input wire master_clk;
   output wire clk_2hz;
   output wire clk_cycle;
   output wire clk_blink;

   wire [26:0] freq_2hz = 27'd2; // select -- updating the minutes or seconds when you use select and adjust switch
   wire [26:0] freq_cycle = 27'd500; // clock (the 50 - 700 Hz part) -- for multiplexing the seven segment display
   wire [26:0] freq_blink = 27'd5; // how fast you see the blinking when you select and adjust

   clock_converter clk_make_2hz (.master_clk(master_clk), .freq_new(freq_2hz), .clk_new(clk_2hz));
   clock_converter clk_make_cycle (.master_clk(master_clk), .freq_new(freq_cycle), .clk_new(clk_cycle));
   clock_converter clk_make_blnk(.master_clk(master_clk), .freq_new(freq_blink), .clk_new(clk_blink));

endmodule