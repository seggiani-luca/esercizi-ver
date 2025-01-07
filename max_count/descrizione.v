module ABC (
	clock, reset_,
	rfd_x, dav_x, x, // produttore x
	rfd_y, dav_y, y, // produttore y
	out);

	input clock, reset_;

	output rfd_x, rfd_y;
	reg RFD;
	assign rfd_x = RFD;
	assign rfd_y = RFD;

	input dav_x, dav_y;
	
	input[7:0] x, y;
	
	output out;
	reg OUTR;
	assign out = OUTR;

	reg[7:0] COUNT;
	
	wire[7:0] z7_z0;

	max m (
		x, y,
		z7_z0
	);

	reg[1:0] STAR;
	localparam
		s0 = 2'B00,
		s1 = 2'B01,
		s2 = 2'B10;

	always @(reset_ == 0) #1 begin
		RFD <= 1;
		OUTR <= 0;
		STAR <= s0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(STAR)
			s0 : begin
				RFD <= 1;
				OUTR <= 0;
				COUNT <= z7_z0;
				STAR <= (dav_x == 0 && dav_y == 0) ? s1 : s0;
			end
			s1 : begin
				RFD <= 0;
				STAR <= (dav_x == 1 && dav_y == 1) ? s2 : s1;
			end
			s2 : begin
				OUTR <= 1;
				COUNT <= COUNT - 1;
				STAR <= (COUNT == 1) ? s0 : s2;
			end
		endcase
	end
endmodule

module max(x, y, z7_z0);
	input[7:0] x, y;
	output[7:0] z7_z0;
	
	wire less;

	cmp c (
		.x(x), .y(y),
		.less(less)
	);

	assign z7_z0 = less ? y : x;
		
endmodule

module cmp ( 
    x, y,
    eq, less);
	input[7:0] x, y;
	
	output eq, less;

	wire[7:0] d;
	wire b_out;

	sub s (
		x, y, 1'B0,
		d, b_out
	);

	assign eq = ~b_out & (d == 8'B0);
	assign less = b_out;
endmodule

module sub ( 
    x, y, b_in,
    d, b_out);

    input[7:0] x, y;
    input b_in;

    output[7:0] d;
    output b_out;

		wire c_out;
		assign b_out = ~c_out;

		add a (
			x, ~y, ~b_in,
			d, c_out
		);

endmodule

module add ( 
    x, y, c_in,
    s, c_out);

    input[7:0] x, y;
    input c_in;

    output[7:0] s;
    output c_out;

    assign #1 {c_out, s} = x + y + c_in;
endmodule
