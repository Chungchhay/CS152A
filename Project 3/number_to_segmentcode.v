`timescale 1 ns / 1 ps

//Converting num_to_convert into seg_code with combinational logic.
module num_to_seg_code(num_to_convert,
		       seg_code);
   
   input wire [3:0] num_to_convert;
   output reg [6:0] seg_code;

   always @*
     begin
	case (num_to_convert)
	  4'b0000: seg_code[6:0] = 7'b1000000;
	  4'b0001: seg_code[6:0] = 7'b1111001;
	  4'b0010: seg_code[6:0] = 7'b0100100;
	  4'b0011: seg_code[6:0] = 7'b0110000;
	  4'b0100: seg_code[6:0] = 7'b0011001;
	  4'b0101: seg_code[6:0] = 7'b0010010;
	  4'b0110: seg_code[6:0] = 7'b0000010;
	  4'b0111: seg_code[6:0] = 7'b1111000;
	  4'b1000: seg_code[6:0] = 7'b0000000;
	  4'b1001: seg_code[6:0] = 7'b0010000;
	  default: seg_code[6:0] = 7'b1000000; //middle dash
	endcase
     end
   // NOTE: we could modify this file to have if / else statements later 
endmodule 		