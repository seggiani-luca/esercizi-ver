parameter N = 16;

module N_integer_divider_posr(x, y, q, r, no_idiv);
	input signed [N-1:0] x;
	input signed [N/2-1:0] y;
	output signed [N/2-1:0] q;
	output signed [N/2-1:0] r;
	output no_idiv;

	wire[N-1:0] x_abs;
	wire x_sgn;
	
	c2_ms_converter #(.M(N)) x_con (
		.x(x), 
		.x_abs(x_abs), .x_sgn(x_sgn)
	);

	wire[N/2-1:0] y_abs;
	wire y_sgn;
	
	c2_ms_converter #(.M(N/2)) y_con (
		.x(y), 
		.x_abs(y_abs), .x_sgn(y_sgn)
	);

	wire[N/2-1:0] q_abs;
	wire q_sgn;
	
	wire[N/2-1:0] r_abs;
	wire r_sgn;

	wire no_div;

	N_divider div (
		.x(x_abs), .y(y_abs), 
		.q(q_abs), .r(r_abs),
		.no_div(no_div)
	);

	assign q_sgn = x_sgn ^ y_sgn;
	assign r_sgn = x_sgn;

	wire ow;

	wire[N/2-1:0] q_can;
	wire[N/2-1:0] r_can;

	ms_c2_converter #(.M(N/2)) q_con (
		.x_abs(q_abs), .x_sgn(q_sgn),
		.x(q_can), .ow(ow)
	);
		
	ms_c2_converter #(.M(N/2)) r_con (
		.x_abs(r_abs), .x_sgn(r_sgn),
		.x(r_can)
	);

	assign q = x_sgn ? q_can - 1 : q_can;
	assign r = x_sgn ? y_abs - r_abs : r_can;

	assign no_idiv = no_div | ow;
endmodule

module N_divider(x, y, q, r, no_div);
	input[N-1:0] x;
	input[N/2-1:0] y;
	output[N/2-1:0] q;
	output[N/2-1:0] r;
	output no_div;

	feasibility_checker fes (
		.x(x), .y(y),
		.no_div(no_div)
	);

	wire[N/2-1:0] res [N/2-2:0];

	genvar i;
	generate
		for(i = N / 2 - 1; i >= 0; i = i - 1) begin : subdividers
			if(i == N / 2 - 1) begin
				N_subdivider subdiv (
					.x(x[N-1:N/2-1]), .y(y),
					.q(q[i]), .r(res[i-1])
				);
			end else if(i == 0) begin
				N_subdivider subdiv (
					.x({res[i], x[i]}), .y(y),
					.q(q[i]), .r(r)
				);
			end else begin
				N_subdivider subdiv (
					.x({res[i], x[i]}), .y(y),
					.q(q[i]), .r(res[i-1])
				);
			end
		end
	endgenerate
endmodule

module N_subdivider(x, y, q, r);
	input[N/2:0] x;
	input[N/2-1:0] y;
	output q;
	output[N/2-1:0] r;

	wire[N/2-1:0] sub;
	assign sub = x - y;

	wire cmp;
	assign cmp = x >= y;
	
	assign q = cmp;
	assign r = cmp ? sub : x;
endmodule

module feasibility_checker(x, y, no_div);
	input[N-1:0] x;
	input[N/2-1:0] y;
	output no_div;
	
	wire flag_lr;
	assign flag_lr = x < y * 2 ** (N/2);

	assign no_div = ~(flag_lr & |y);
endmodule

module c2_ms_converter #(parameter M = 8) (x, x_abs, x_sgn);
	input signed [M-1:0] x;
	output[M-1:0] x_abs;
	output x_sgn;

	assign x_abs = (x < 0) ? -x : x;
	assign x_sgn = x < 0;
endmodule

module ms_c2_converter #(parameter M = 8) (x_abs, x_sgn, x, ow);
	input[M-1:0] x_abs;
	input x_sgn;
	output signed [M-1:0] x;
	output ow;

	assign x = x_sgn ? -x_abs : x_abs;
	assign ow = ~((x_abs == 2 ** (M-1)) & x_sgn | x_abs < 2 ** (M-1));
endmodule
