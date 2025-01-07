// sintetizzare una rete che prende 3 numeri naturali e restituisce il massimo
// fra di essi

parameter N = 8;

module max_3(a, b, c, max);	
	input[N-1:0] a, b, c;
	output[N-1:0] max;

	wire ab_less;
	
	nat_cmp ab_cmp (
		.x(a), .y(b),
		.less(ab_less)
	);

	wire[N-1:0] ab_plex;
	assign ab_plex = ab_less ? b : a;

	wire wc_less;

	nat_cmp wb_cmp (
		.x(ab_plex), .y(c),
		.less(wc_less)
	);

	wire[N-1:0] wc_plex;
	assign wc_plex = wc_less ? c : ab_plex;
	
	assign max = wc_plex;
endmodule

module nat_cmp(x, y, less);
	input[N-1:0] x;
	input[N-1:0] y;
	output less;

	wire[N-1:0] y_neg;
	assign y_neg = ~y + 1;
	
	wire cout;
	
	N_b2_adder add (
		.x(x), .y(y_neg),
		.cin('B0),
		.cout(cout)
	);

	assign less = ~cout;
endmodule

module N_b2_adder(x, y, cin, s, cout);
	input[N-1:0] x, y;
	input cin;	
	output[N-1:0] s;
	output cout;
  wire [N-2:0] carry; 

	genvar i; 
	generate
		for(i = 0; i < N; i = i + 1) begin : b2_adders
			if(i == 0) begin
				b2_adder add (
					.x(x[i]), .y(y[i]),
					.cin(cin),
					.s(s[i]),
					.cout(carry[i])
				);
			end else if(i == N-1) begin
				b2_adder add (
					.x(x[i]), .y(y[i]),
					.cin(carry[i-1]),
					.s(s[i]),
					.cout(cout)
				);
			end else begin
				b2_adder add (
					.x(x[i]), .y(y[i]),
					.cin(carry[i-1]),
					.s(s[i]),
					.cout(carry[i])
				);
			end
		end
	endgenerate
endmodule

module b2_adder(x, y, cin, s, cout);
	input x, y, cin;
	output s, cout;

	wire x_xor_y;
	assign x_xor_y = x ^ y;

	assign s = (x_xor_y) ^ cin;
	assign cout = x & y | x_xor_y & cin;
endmodule
