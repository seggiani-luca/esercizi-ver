module testbench();
	reg t_clock, t_reset_;
	reg t_ei;
	wire [3:0] t_eu;
	wire [3:0] t_q;

	b2_counter count_0 (
		.clock(t_clock), .reset_(t_reset_),
		.ei(t_ei),
		.eu(t_eu[0]), .q(t_q[0])
	);
	
	b2_counter count_1 (
		.clock(t_clock), .reset_(t_reset_),
		.ei(t_eu[0]),
		.eu(t_eu[1]), .q(t_q[1])
	);

	b2_counter count_2 (
		.clock(t_clock), .reset_(t_reset_),
		.ei(t_eu[1]),
		.eu(t_eu[2]), .q(t_q[2])
	);

	b2_counter count_3 (
		.clock(t_clock), .reset_(t_reset_),
		.ei(t_eu[2]),
		.eu(t_eu[3]), .q(t_q[3])
	);

	initial begin
    forever #5 t_clock = ~t_clock; 
	end

	initial begin
		$dumpfile("waveform.vcd");
		$dumpvars;	

		t_clock = 0;
		t_reset_ = 0;
		t_ei = 0;

		#10 

		t_reset_ = 1;
		t_ei = 1;

		#200;

		$finish;
	end
endmodule
