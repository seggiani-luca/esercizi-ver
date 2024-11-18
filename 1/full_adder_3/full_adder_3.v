module full_adder_3(x, y, c_in, s, c_out);
	input[2:0] x, y;
	input c_in;
	output[2:0] s;
	output c_out;

	wire c_in1;
	wire c_in2;

	// sfrutto il full adder già creato
	full_adder f0 (
		.x(x[0]), .y(y[0]), .c_in(c_in),
		.s(s[0]), .c_out(c_in1)
	);
	
	full_adder f1 (
		.x(x[1]), .y(y[0]), .c_in(c_in1),
		.s(s[1]), .c_out(c_in2) 
	);

	full_adder f2 (
		.x(x[2]), .y(y[2]), .c_in(c_in2),
		.s(s[2]), .c_out(c_out)
	);
	
endmodule
