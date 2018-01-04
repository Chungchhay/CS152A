`timescale 1ns / 1ps

module unifier(in, out, sign);

input wire [11:0] in;
output wire sign;
output wire [11:0] out;

twoc_to_sm block1(
	.x(in),
	.y(out),
	.s(sign)
);
endmodule