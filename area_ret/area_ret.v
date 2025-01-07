// Sintetizzare una rete combinatoria che prende in ingresso tre numeri naturali 𝐴, 𝐵 e 𝐶, ciascuno su 𝑛 
// bit in base 2, li interpreta come le lunghezze di tre lati, e produce due uscite ret e area. L’uscita ret, 
// su 1 bit, vale 1 se 𝐴, 𝐵 e 𝐶 sono i lati di un triangolo rettangolo e zero altrimenti. L’uscita area, su ? 
// bit, contiene l’area del triangolo (a meno di approssimazioni) se ret vale 1, ed un valore non signifi-
// cativo altrimenti. 
parameter N = 16;

module area_ret(a, b, c, area, ret);
	input[N-1:0] a, b, c;
	output[2*N-2:0] area;
	output ret;

	wire[N-1:0] max;
	wire[1:0] b1_b0;

	max_3 maxr (
		.a(a), .b(b), .c(c),
		.max(max), .b1_b0(b1_b0)
	);

	wire[1:0] c1_c0;
	assign c1_c0[1] = |b1_b0;
	assign c1_c0[0] = b1_b0[1];

	wire[N-1:0] plex_1;
	assign plex_1 = c1_c0[1] ? a : b;

	wire[N-1:0] plex_2;
	assign plex_2 = c1_c0[0] ? b : c;

	// su 2*N + 1 per non perdere precisione
	wire[2*N:0] max_sqr;
	assign max_sqr = max * max;

	wire[2*N:0] plex_1_sqr;
	assign plex_1_sqr = plex_1 * plex_1;

	wire[2*N:0] plex_2_sqr;
	assign plex_2_sqr = plex_2 * plex_2;

	wire[2*N:0] plex_sqr_sum;
	assign plex_sqr_sum = plex_1_sqr + plex_2_sqr;
	
	assign ret = max_sqr == plex_sqr_sum;

	wire[2*N-1:0] area_2;
	assign area_2 = plex_1 * plex_2;
	assign area = area_2[N-1:1];
endmodule

// implementazione alternativa, serve un uscita per il multiplexer
module max_3(a, b, c, max, b1_b0);	
	input[N-1:0] a, b, c;
	output[N-1:0] max;

	wire ab_less;
	wire bc_less;
	wire ac_less;

	nat_cmp ab_cmp (
		.x(a), .y(b),
		.less(ab_less)
	);

	nat_cmp bc_cmp (
		.x(b), .y(c),
		.less(bc_less)
	);

	nat_cmp ac_cmp (
		.x(a), .y(c),
		.less(ac_less)
	);

	output[1:0] b1_b0;

	assign b1_b0[1] = ac_less & bc_less;
	assign b1_b0[0] = ab_less;

	// sarebbe un multiplexer a 4 vie
	assign max = (b1_b0 == 'B00) ? a:
							 (b1_b0 == 'B01) ? b:
							 (b1_b0 == 'B10) ? c:
						 /*(b1_b0 == 'B11)?*/c;
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
