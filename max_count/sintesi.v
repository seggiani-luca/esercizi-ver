module ABC (
	clock, reset_,
	rfd_x, dav_x, x, // produttore x
	rfd_y, dav_y, y, // produttore y
	out);

	input clock, reset_;

	output rfd_x, rfd_y;
	input dav_x, dav_y;
	
	input[7:0] x, y;
	
	output out;

	wire b1;
	wire b0;

	wire c0;
	wire c1;
	wire c2;

	p_operativa p_op (
		clock, reset_,
		rfd_x, dav_x, x, // produttore x
		rfd_y, dav_y, y, // produttore y
		out,
		b1, b0,
		c2, c1, c0
	);

	p_controllo p_co (
		clock, reset_,
		b1, b0,
		c2, c1, c0
	);
endmodule

module p_operativa (
	clock, reset_,
	rfd_x, dav_x, x, // produttore x
	rfd_y, dav_y, y, // produttore y
	out,
	b1, b0,
	c2, c1, c0);

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

	input b1;
 	input b0;

	// RFD
	always @(reset_ == 0) #1 begin
		RFD <= 1;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(b1)
			1'B0 : begin
				RFD <= ~b0;
			end
			1'B1 : begin
				RFD <= RFD;
			end
		endcase
	end
	
	// OUTR
	always @(reset_ == 0) #1 begin
		OUTR <= 0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		OUTR <= b1;
	end
	
	// COUNT
	always @(posedge clock) if(reset_ == 1) #3 begin
		casex({b1, b0})
			2'B00 : begin
				COUNT <= z7_z0;
			end
			2'B01 : begin
				COUNT <= COUNT;
			end
			2'B10 : begin
				COUNT <= COUNT - 1;
			end
		endcase
	end

	output c0;
	output c1;
	output c2;
	
	assign c0 = ~dav_x & ~dav_y ;
	assign c1 = dav_x & dav_y;
	assign c2 = COUNT == 8'B00000001;
endmodule

module p_controllo (
	clock, reset_,
	b1, b0,
	c2, c1, c0);

	input clock, reset_;

	reg[1:0] STAR;
	localparam
		s0 = 2'B00,
		s1 = 2'B01,
		s2 = 2'B10;

	output b1;
	output b0;

	assign b1 = STAR[1];
	assign b0 = STAR[0];

	input c0;
	input c1;
	input c2;
	
	always @(reset_ == 0) #1 begin
		STAR <= s0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(STAR)
			s0 : begin
				STAR <= c0 ? s1 : s0;
			end
			s1 : begin
				STAR <= c1 ? s2 : s1;
			end
			s2 : begin
				STAR <= c2 ? s0 : s2;
			end
		endcase
	end
endmodule

/* combinatorie */
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
