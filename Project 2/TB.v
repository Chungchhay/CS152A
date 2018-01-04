`timescale 1ns / 1ps

module TB;

reg [11:0] in;
wire [11:0] out;
wire sign;

unifier uut (
	.in(in),
    .out(out),
	.sign(sign)
);

initial begin
	in = -40;
end
	
endmodule