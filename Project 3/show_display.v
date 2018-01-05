`timescale 1 ns / 1 ps

//Takes in display, adj, sel, clk_cycle, clk_blink.
//Produces an anode_code value that refreshes based on clk_cycle.
//Produces seg_code that corresponds to current "refreshing" digit and also blinks based on clk_blink/adj.
module display(number_to_disp,
	       adj,
	       sel,
	       clk_cycle,
	       clk_blink,
	       anode_code,
	       seg_code);

   
   input wire [11:0] number_to_disp;
   input wire adj;
   input wire sel;
   input wire clk_cycle;
   input wire clk_blink;
   output reg [3:0] anode_code;
   output reg [6:0] seg_code;    
   
   wire [3:0] digits[3:0];
   wire [6:0] digit_codes[3:0];
	
	initial
	begin
		anode_code[3:0] = 4'b1110;
		seg_code[6:0] = 7'b0;
	end

   //digits are number_to_disp translated into the values of the digits to display.
   assign digits[0] = number_to_disp % 10; // each of the four digits on board -- 1st digit minute
   assign digits[1] = number_to_disp/10 % 6; // each of the four digits on board -- 2nd digit minute
   assign digits[2] = number_to_disp/60 % 10; // each of the four digits on board -- 1st digit second
   assign digits[3] = number_to_disp/600 % 6; // each of the four digits on board -- 2nd digit second

   //digit_codes are the values of the digits translated into 7-segment code.
   num_to_seg_code seconds_ones(.num_to_convert(digits[0]),
				.seg_code(digit_codes[0]));
   
   num_to_seg_code seconds_tens(.num_to_convert(digits[1]),
				.seg_code(digit_codes[1]));

   num_to_seg_code minutes_ones(.num_to_convert(digits[2]),
				.seg_code(digit_codes[2]));

   num_to_seg_code minutes_tens(.num_to_convert(digits[3]),
				.seg_code(digit_codes[3]));
   
   
   //Cycle through anode_code so the display refreshes for each segment.
   //Note: assumes anode_code is composed of three 1s and one 0, e.g. 0111, 1011,...
   //See bottom of pg.19 of Nexys3.rm for further details.
   always @ (posedge clk_cycle)
	  begin
	     anode_code[3:0] <= {anode_code[0], anode_code[3:1]};
	  end

   //Constantly assign seg_code the 7-segment code depending on anode_code value.
   //If not adjusting, then assign the expected seg_code.
   //If adjusting, then alternate assignments between expected seg_code and 0 (blank segment).
   always @*
     begin
	if (adj && clk_blink)
	begin
	  //TODO: write the code out for this
	  //if sel ~ seconds blink && anode_code is refreshing minutes digit, then assign expected value.
	  //and vice-versa. Else assign 1111111.
	  if (sel == 1 && (anode_code[3:0] == 4'b0111 || anode_code[3:0] == 4'b1011)) //seconds
	  begin
	      case(anode_code[3:0])
			   4'b1011: seg_code = digit_codes[2];
	         4'b0111: seg_code = digit_codes[3];
		      default: seg_code = 7'b1000000; //middle dash
			endcase
	  end
	  else if (sel == 0 && (anode_code[3:0] == 4'b1101 || anode_code[3:0] == 4'b1110))
	  begin
	  	   case(anode_code[3:0])
			   4'b1101: seg_code = digit_codes[1];
	         4'b1110: seg_code = digit_codes[0];
		      default: seg_code = 7'b1000000; //middle dash
			endcase
	  end
	  else
		  seg_code = 7'b1111111; // see if it can run without because we think this case will never happen
	end
	else
	  case(anode_code[3:0])
	    4'b1110: seg_code = digit_codes[0];
	    4'b1101: seg_code = digit_codes[1];
	    4'b1011: seg_code = digit_codes[2];
	    4'b0111: seg_code = digit_codes[3];
		 default: seg_code = 7'b1000000; //middle dash
	  endcase
     end

endmodule