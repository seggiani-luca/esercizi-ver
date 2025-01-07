module ABC (
	clock, reset_, 
	rfd1, dav1_, x, // produttore 1
	rfd2, dav2_, y, // produttore 2
	m, ok);

	input clock, reset_;

	output rfd1, rfd2;
	input dav1_, dav2_;
	input[7:0] x, y;
	
	output[15:0] m;
	output ok;
	
	wire b1, b0;

	wire c1, c0;

	p_operativa p_op (
		clock, reset_, 
		rfd1, dav1_, x, // produttore 1
		rfd2, dav2_, y, // produttore 2
		m, ok,
		b1, b0,
		c1, c0
	);

	p_controllo p_co (	
		clock, reset_, 
		b1, b0,
		c1, c0
	);
endmodule

module p_operativa (
	clock, reset_, 
	rfd1, dav1_, x, // produttore 1
	rfd2, dav2_, y, // produttore 2
	m, ok,
	b1, b0,
	c1, c0);

	input clock, reset_;

	output rfd1, rfd2;
	reg RFD;
	assign rfd1 = RFD;
	assign rfd2 = RFD;

	input dav1_, dav2_;
	
	input[7:0] x, y;
	
	output[15:0] m;

	reg[15:0] M;
	assign m = M;

	wire[15:0] p;

	MUL8 mul (
		x, y, p
	);
	
	output ok;
	
	reg OK;
	assign ok = OK;


	input b1, b0;

	// RFD
	always @(reset_ == 0) #1 begin
		RFD <= 1;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(b1)
			1'B0 : begin
				RFD <= ~b0;
			end
			1'B1: begin
				RFD <= RFD;
			end
		endcase
	end

	// M
	always @(posedge clock) if(reset_ == 1) #3 begin
		casex({b1, b0})
			2'B00 : begin
				M <= p;
			end
			2'B01 : begin
				M <= M;
			end
			2'B10 : begin
				M <= M;
			end
		endcase
	end

	// OK
	always @(reset_ == 0) #1 begin
		OK <= 0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		OK <= b1;
	end

	output c1, c0;
	
	assign c0 = ~dav1_ & ~dav2_;
	assign c1 = dav1_ & dav2_;
endmodule

module p_controllo (
	clock, reset_, 
	b1, b0,
	c1, c0);

	input clock, reset_;

	reg[1:0] STAR;
	localparam
		s0 = 2'B00,
		s1 = 2'B01,
		s2 = 2'B10;

	output b1, b0;
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
				STAR <= s0;
			end
		endcase
	end
endmodule

/* combinatorie */
module MUL8(x, y, p);
	input[7:0] x, y;
	output[15:0] p;

	wire[7:0] part_0;
	n8_mul_add mul_0 (
		x, y[0], 8'B0,
		{part_0, p[0]}
	);
	
	wire[7:0] part_1;
	n8_mul_add mul_1 (
		x, y[1], part_0,
		{part_1, p[1]}
	);
	
	wire[7:0] part_2;
	n8_mul_add mul_2 (
		x, y[2], part_1,
		{part_2, p[2]}
	);
	
	wire[7:0] part_3;
	n8_mul_add mul_3 (
		x, y[3], part_2,
		{part_3, p[3]}
	);
	
	wire[7:0] part_4;
	n8_mul_add mul_44 (
		x, y[4], part_3,
		{part_4, p[4]}
	);
	
	wire[7:0] part_5;
	n8_mul_add mul_5 (
		x, y[5], part_4,
		{part_5, p[5]}
	);
	
	wire[7:0] part_6;
	n8_mul_add mul_6 (
		x, y[6], part_5,
		{part_6, p[6]}
	);
	
	wire[7:0] part_7;
	n8_mul_add mul_7 (
		x, y[7], part_6,
		p[15:7]
	);

endmodule

module n8_mul_add(x, y_i, c, p);
	input[7:0] x, c;
	input y_i;
	output[8:0] p;

	wire[8:0] s;

	add #(.N(8)) a (
		.x(x), .y(c), .c_in(1'B0),
		.s(s[7:0]), .c_out(s[8]) 
	);

	assign p = y_i ? s : c;
endmodule

// Sommatore valido sia per naturali che per interi, in base 2.
// Sia input che output sono a N cifre.
// Il circuito ha in uscita sia il carry che l'overflow, sta all'utilizzatore collegare quello corretto.
module add( 
    x, y, c_in,
    s, c_out, ow    
);
    parameter N = 2;

    input [N-1:0] x, y;
    input c_in;

    output [N-1:0] s;
    output c_out, ow;

    assign #1 {c_out, s} = x + y + c_in;
    assign #1 ow = (x[N-1] == y[N-1]) && (x[N-1] != s[N-1]);

endmodule
