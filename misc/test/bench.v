module bench();
	reg t_clock, t_reset_;

	seq s (
		.clock(t_clock), .reset_(t_reset_)
	);

	initial forever #5 t_clock = ~t_clock;

	initial begin
		$dumpfile("waveform.vcd");
		$dumpvars;

		t_reset_ = 1;
		t_clock = 0;

		#300;

		$finish;
	end
endmodule
