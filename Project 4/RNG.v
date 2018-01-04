`timescale 1ns / 1ps

//count is for the shift. Shift by the bits, in this one is 3 bits for the random 
module RNG (
    input clk,
    output reg [12:0] random 
    );
 reg [12:0] rand;
 reg [12:0] rand_next;
 wire feedback;
 
 initial rand = 12'b111111111111;
 assign feedback = rand[12] ^ rand[5];
 
 always @ (posedge clk)
 begin
    rand <= rand_next;
    random = rand[6:0];
 end
 
 always @ (*) rand_next = {rand[11:0], feedback};
endmodule