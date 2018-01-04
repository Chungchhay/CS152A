`timescale 1ns / 1ps

module segdisplay(
	input wire [20:0] score,
	input wire segclk,		//7-segment clock
	input wire clr,			//asynchronous reset
	output reg [6:0] seg,	//7-segment display LEDs
	output reg [3:0] an		//7-segment display anode enable
	);

// constants for displaying letters on display
reg [6:0] segments;

// Finite State Machine (FSM) states
parameter left = 2'b00;
parameter midleft = 2'b01;
parameter midright = 2'b10;
parameter right = 2'b11;

// state register
reg [1:0] state;

// FSM which cycles though every digit of the display every 2.62ms.
// This should be fast enough to trick our eyes into seeing that
// all four digits are on display at the same time.
	always @ (*)
	begin
	if(state == right)
		begin
				if(score % 10 ==0) segments = 7'b1000000;
				else if(score % 10 ==4'd1) segments = 7'b1111001;
				else if(score % 10 ==4'd2) segments = 7'b0100100;
				else if(score % 10 ==4'd3) segments = 7'b0110000;
				else if(score % 10 ==4'd4) segments = 7'b0011001;
				else if(score % 10 ==4'd5) segments = 7'b0010010;
				else if(score % 10 ==4'd6) segments = 7'b0000010;
				else if(score % 10 ==4'd7) segments = 7'b1111000;
				else if(score % 10 ==4'd8) segments = 7'b0000000;
				else if(score % 10 ==4'd9) segments = 7'b0010000;
				else segments = 7'b1111111;
		end
		else if (state == midright)
		begin
				if(score / 10 % 10 == 0) segments = 7'b1000000;
				else if(score / 10 % 10 == 1 ) segments = 7'b1111001;
				else if(score / 10 % 10 == 2) segments = 7'b0100100;
				else if(score / 10 % 10 == 3) segments = 7'b0110000;
				else if(score / 10 % 10 == 4) segments = 7'b0011001;
				else if(score / 10 % 10 == 5) segments = 7'b0010010;
				else if(score / 10 % 10 == 6) segments = 7'b0000010;
				else if(score / 10 % 10 == 7) segments = 7'b1111000;
				else if(score / 10 % 10 == 8) segments = 7'b0000000;
				else if(score / 10 % 10 == 9) segments = 7'b0010000;
				else segments = 7'b1111111;
		end
	else if (state == midleft)
	begin
				if(score / 100 % 10 == 0) segments = 7'b1000000;
				else if(score / 100 % 10 == 1 ) segments = 7'b1111001;
				else if(score / 100 % 10 == 2) segments = 7'b0100100;
				else if(score / 100 % 10 == 3) segments = 7'b0110000;
				else if(score / 100 % 10 == 4) segments = 7'b0011001;
				else if(score / 100 % 10 == 5) segments = 7'b0010010;
				else if(score / 100 % 10 == 6) segments = 7'b0000010;
				else if(score / 100 % 10 == 7) segments = 7'b1111000;
				else if(score / 100 % 10 == 8) segments = 7'b0000000;
				else if(score / 100 % 10 == 9) segments = 7'b0010000;
				else segments = 7'b1111111;
		end
	else if (state == left)
	begin
				if(score / 1000 % 10 == 0) segments = 7'b1000000;
				else if(score / 1000 % 10 == 1 ) segments = 7'b1111001;
				else if(score / 1000 % 10 == 2) segments = 7'b0100100;
				else if(score / 1000 % 10 == 3) segments = 7'b0110000;
				else if(score / 1000 % 10 == 4) segments = 7'b0011001;
				else if(score / 1000 % 10 == 5) segments = 7'b0010010;
				else if(score / 1000 % 10 == 6) segments = 7'b0000010;
				else if(score / 1000 % 10 == 7) segments = 7'b1111000;
				else if(score / 1000 % 10 == 8) segments = 7'b0000000;
				else if(score / 1000 % 10 == 9) segments = 7'b0010000;
				else segments = 7'b1111111;
		end

	end
		
			
always @(posedge segclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		seg <= 7'b1111111;
		an <= 7'b1111;
		state <= left;
	end
	// display the character for the current position
	// and then move to the next state
	else

	begin
		case(state)
			left:
			begin
				seg <= segments;
				an <= 4'b0111;
				state <= midleft;
			end
			midleft:
			begin
				seg <= segments;
				an <= 4'b1011;
				state <= midright;
			end
			midright:
			begin
				seg <= segments;
				an <= 4'b1101;
				state <= right;
			end
			right:
			begin
				seg <= segments;
				an <= 4'b1110;
				state <= left;
			end
		endcase
	end
end
endmodule
