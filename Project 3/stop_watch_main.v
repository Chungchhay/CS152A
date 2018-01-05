`timescale 1 ns / 1 ps

module stop_watch(
          master_clk, 
		  btn_rst, 
		  btn_pause, 
		  sw,
		  an, 
		  seg); 

   //Assume inputs won't be assigned values, so we can call them wires.
   //Note: "The types reg/wire only apply in the current module and are not carried over port connections."
   input wire master_clk; //master clock
   input wire btn_rst; //reset clock button
   input wire btn_pause; //pause clock button   
   input wire [1:0] sw; // both of the switches
   output wire [3:0] an; // analog -- for selecting which one of the four 7 segments 
   output wire [6:0] seg; // seven segment display 
   wire sel = sw[0]; 
   wire adj = sw[1];

   //Debouncing rst and pause, and assigning pause a state register.
   //pause_state toggles on posedge pause (or synchronized button press).
   wire rst;			
   wire pause;
   reg pause_state = 0;

   //Clocks
   wire clk_2hz;
   wire clk_cycle;
   wire clk_blink;

   //Underlying counter value that will be formatted/outputted to display.
   reg [11:0] displayer = 0;

   //Toggle to get 1hz clock from 2hz clock.
   reg onoff = 1;			       

      //PAUSE
   debouncer db_pause(
              .master_clk(master_clk),
		      .btn_unstable(btn_pause),
		      .btn_stable(pause));
      //RESET
   debouncer db_rst(
            .master_clk(master_clk),
		    .btn_unstable(btn_rst),
		    .btn_stable(rst));
      //MASTER CLOCK
   all_clock master_clock (
               .master_clk(master_clk),
			   .clk_2hz(clk_2hz),
			   .clk_cycle(clk_cycle),
			   .clk_blink(clk_blink));
      //DISPLAY
   display disp(
        .number_to_disp(displayer),
		.adj(adj),
		.sel(sel),
		.clk_cycle(clk_cycle),
		.clk_blink(clk_blink),
		.anode_code(an),
		.seg_code(seg));

   always @ (posedge pause or posedge master_clk)
     begin
        if(pause)
            pause_state <= ~pause_state;
     end

   //Logic for the counter's value.
   always @ (posedge clk_2hz or posedge rst)
     begin
	//If paused, don't increment counter.
    if (rst) 
            displayer = 0;
    else 
    begin
	if (!pause_state)
	  begin
	     //If adj, then increment counter at 2hz.
	     //Else if toggled on, then increment counter (at 1hz) and toggle off.
	     //Else if not toggled, toggle on.
	     if (adj)
	       begin
			if ((displayer % 60 == 59) && sel) //overflow for second
				displayer = displayer - 59;
			else if (sel) 
				displayer = (displayer + 1) % 3600; //Update the second & overflow for everything (set everything to 0)
			else 
				displayer = (displayer + 60) % 3600; //Update the minute & overflow for everything (set everything to 0)
	       end
	     else if (onoff) //When back to normal update
			begin
                displayer = (displayer + 1) % 3600;
                onoff = 0;
            end
	     else
	       onoff = 1;
	  end
      end
     end
endmodule