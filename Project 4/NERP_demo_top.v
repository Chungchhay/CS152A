`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NERP_demo_top(
	input jump_btn,
	input pause_btn,
	input rst_btn,
	input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset
	output wire [6:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync,			//vertical sync out
	output vcc // output for the sound
	);
// 7-segment clock interconnect
wire segclk;
// VGA display clock interconnect
wire dclk;
wire soundclock;
wire soundclock2;
// disable the 7-segment decimal points
assign dp = 1;
assign vcc = (soundclock & flag);
//bird stuff -- NEW 
wire [10:0] y_pos;
//pipe stuff -- NEW
reg [17:0] wallspeed; // higher value results in slower movement. lower value results in faster movement
always @ (posedge dclk) 
begin 
if(newspeed == 0)
	wallspeed <= wallspeed + 1;
if (score > 10)
	wallspeed <= wallspeed + 2;
if (score > 30)
	wallspeed <= wallspeed + 4;
end
wire [12:0] numRand;
reg [7:0] wallOne;
reg [7:0] wallTwo;
reg [9:0] wall_pos;
//scorekeeping -- NEW
reg [20:0] score;
//game status -- NEW
reg [1:0] status; //0 is game over, 1 is restart, and 2 is start game
reg jump;
reg pause;
reg dePause;
reg flag;
reg [7:0] countToStopSound;
reg newspeed;

initial begin
    wallOne <= 125;
    score <= 0;
    status = 1;
    wall_pos = 0;
    wallspeed = 0;
    pause = 0;
    dePause = 0;
	 flag <= 0;
	 countToStopSound <= 0;
	 newspeed = 0;
end

always @ (posedge wallspeed[17])
begin
 if(status == 1) // if on restart screen
  begin
		wall_pos <= 0;
		score <= 0;
		wallOne <= 125;
		flag <= 0;
  end
 if(wall_pos >= 400)// how far away the falls are -- arbitrary value past like 320ish... around 320ish, it started skipping frames
 begin
	  if(!pause && status == 2) 
		begin
			 flag <= 1;
			 wallTwo <= numRand;
			 score <= score +1;
			 wall_pos <= 0;
			 wallOne <= wallTwo;
		end
 end
 else if(!pause && status == 2)
 begin
	wall_pos <= wall_pos+1;
	countToStopSound = countToStopSound + 1;
	if( countToStopSound > 'd63)
	begin
		countToStopSound = 0;
		flag <= 0;
	end
 end
end

always @ (posedge segclk)
begin
	if(status == 2 && pause_btn && !dePause)
		pause <= !pause;
	else if (status != 2)
		pause <= 0;
	if(status == 2 && (y_pos == 0 || ((144+105 > (784-wall_pos-400) && 144+75 < (784-wall_pos+40-400)) && ((511-y_pos)-15 < wallOne+50 || (511-y_pos)+15 > wallOne+150))))//if hitting walls, or bird is is somehow dead
		status <= 0;
	else if(jump && status==1) // jump when game is on to start the game
		status <= 2;
	else if( status == 0 && rst_btn) // press reset button after you lose to go to starting position
		status <= 1;
	dePause <= pause_btn;
	jump <= jump_btn;
end

// generate 7-segment clock & display clock
clockdiv clockdiv_uut(
	.clk(clk),
	.clr(clr),
	.segclk(segclk),
	.dclk(dclk),
	.soundclock(soundclock)
	);
// 7-segment display controller
segdisplay segdisplay_uut(
	.score(score), // NEW
	.segclk(segclk),
	.clr(clr),
	.seg(seg),
	.an(an)
	);

// VGA controller
vga640x480 vga_uut(
	.y_pos(y_pos),// NEW
	.wall_pos(wall_pos), // NEW
	.wallOne(wallOne),// NEW
	.wallTwo(wallTwo), // NEW
	.dclk(dclk),
	.clr(clr),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
	);
// NEW
bird flappy_bird_uut(
	.clk(segclk),
	.pause(pause),
	.jump(jump),
	.status(status),
	.y_pos(y_pos)
);
// NEW
//reg reset;
RNG random_walls_uut(
	  .clk(clk),
     .random(numRand)
	);

endmodule
