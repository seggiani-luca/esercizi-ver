module full_adder(x, y, c_in, s, c_out);
	input x, y, c_in;
	output s, c_out;

	wire s1;

	assign #1 s1 = x ^ y;
	assign #1 s = s1 ^ c_in;
	assign #1 c_out = (s1 & c_in) | (x & y);
endmodule
