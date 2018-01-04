`timescale 1ns / 1ps 

module twoc_to_sm (x, y, s);
input wire [11:0] x;

output reg [11:0] y;
output reg s;

always @*
begin
s = x[11];
if(s == 0)
	y = x;
else
	y = (~x) + 1;
end
endmodule 