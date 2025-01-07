module testbench();
	reg t_reset_, t_clock;
	reg[1:0] t_x1_x0;
	wire[3:0] t_z3_z0;

	sequence_detector seq_detector (
		.reset_(t_reset_), .clock(t_clock),
		.x1_x0(t_x1_x0), .z3_z0(t_z3_z0)
	);

	initial forever #5 t_clock = ~t_clock;

	initial begin
		$dumpfile("waveform.vcd");
		$dumpvars;

		t_clock = 0;
		t_reset_ = 1;

		#1;

		t_x1_x0 = 00;

		#10;
		
		t_x1_x0 = 01;

		#10;
		
		t_x1_x0 = 10;

		#10;

		t_x1_x0 = 11;

		#10;
		
		t_x1_x0 = 01;

		#10;
		
		t_x1_x0 = 10;

		#10;
		
		$finish;
	end
endmodule
