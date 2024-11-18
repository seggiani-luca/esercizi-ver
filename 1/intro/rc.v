module rc(x, y, z, w);
	input x, y;
	output w, z;

	assign #1 w = x & y;
	assign #2 z = x | y;
endmodule
