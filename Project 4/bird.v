`timescale 1ns / 1ps

module bird(input clk, 
	input pause, 
	input jump, 
	input [1:0] status, 
	output reg signed[10:0] y_pos
);
	 reg signed [10:0] velocity; 	 
     reg [4:0] new_clock;
     reg [8:0] count;

	 initial begin 
      count = 0;
		new_clock = 0;
		y_pos = 300;
		velocity = 0;
		end		
	 always @ (posedge clk)
		new_clock <= new_clock + 1;
		
	always @ (posedge new_clock[4]) // this determines the speed of the bird jumping 
	 begin
        if (status == 0)
            velocity <= 0;
        else if (status == 1)
            begin
                velocity <= 0;
                y_pos <= 250;
            end
        else if(!pause && status == 2) // if not paused and game has started
		begin
			if(y_pos <= 25 || y_pos + velocity <= 25)
				y_pos <= 25;
			else if((y_pos + velocity) > 0 && (y_pos + velocity) < 465)
				y_pos <= y_pos + velocity;
            //bird flight start
			if(jump && velocity < 3)
				velocity <= velocity + 'd10; // acceleration
            //jump button not pressed
			else if (velocity > -5)
				velocity <= velocity - 1;//decelerration
		end
	 end
endmodule
