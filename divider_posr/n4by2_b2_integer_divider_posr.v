// un divisore per interi a 4 / 2 cifre che calcola  @x3_x0 / @y1_y0,
// mette il quoziente in @q1_q0 e il resto in @r1_r0. no_idiv 
// rappresenta la non fattibilita'. inoltre si impone @r1_r0 > 0
module n4by4_b2_integer_multiplier(x3_x0, y1_y0, q1_q0, r1_r0,
																														no_idiv);
	input[3:0] x3_x0;
	input [1:0] y1_y0;
	output[1:0] q1_q0;
	output[1:0] r1_r0;
	output no_idiv;

	wire[3:0] x3_x0_abs;
	wire[1:0] y1_y0_abs;
	wire x_sgn, y_sgn;

	n4_c2_ms_converter x_conv (
		.x3_x0(x3_x0), 
		.z3_z0(x3_x0_abs), .sgn(x_sgn)
	);
	
	n2_c2_ms_converter y_conv (
		.x1_x0(y1_y0), 
		.z1_z0(y1_y0_abs), .sgn(y_sgn)
	);
	
	wire[1:0] q1_q0_abs;	
	wire q_sgn;

	wire[1:0] r1_r0_abs;	
	wire r_sgn;
	
	wire no_div;

	n4by2_b2_divider div (
		.x3_x0(x3_x0_abs), .y1_y0(y1_y0_abs), 
		.q1_q0(q1_q0_abs), .r1_r0(r1_r0_abs),
		.no_div(no_div)
	);

	assign q_sgn = x_sgn ^ y_sgn;
	assign r_sgn = 'B0;

	wire ow;

	wire[1:0] q1_q0_pre;
	wire[1:0] r1_r0_pre;

	n2_ms_c2_converter q_conv (
		.x1_x0_abs(q1_q0_abs), .sgn(q_sgn),
		.z1_z0(q1_q0_pre), .ow(ow)
	);
	
	n2_ms_c2_converter r_conv (
		.x1_x0_abs(r1_r0_abs), .sgn(r_sgn),
      	.z1_z0(r1_r0_pre)
	);

	assign q1_q0 = (x_sgn & r1_r0_pre != 2'B0) ? q1_q0_pre - 1 : q1_q0_pre;
	assign r1_r0 = (x_sgn & r1_r0_pre != 2'B0) ? y1_y0_abs - r1_r0_pre : r1_r0_pre; 

	assign no_idiv = ow | no_div;
endmodule
