module testbench();
	reg t_clock, t_reset_;
	
	reg[7:0] t_data_in_1;	// produttore 1
	reg t_dav_in_1_;
	wire t_rfd_in_1;
	
	reg[7:0] t_data_in_2;	// produttore 1
	reg t_dav_in_2_;
	wire t_rfd_in_2;

	wire[15:0] t_data_out; 	// consumatore
	wire t_dav_out_;
	reg t_rfd_out;

	perimeter perim (
		.clock(t_clock), .reset_(t_reset_),
		.data_in_1(t_data_in_1), .dav_in_1_(t_dav_in_1_), .rfd_in_1(t_rfd_in_1),	// produttore 1  
		.data_in_2(t_data_in_2), .dav_in_2_(t_dav_in_2_), .rfd_in_2(t_rfd_in_2),	// produttore 2  
		.data_out(t_data_out), .dav_out_(t_dav_out_), .rfd_out(t_rfd_out)				// consumatore
	);

	initial forever #5 t_clock = ~t_clock;

	initial begin	
		$dumpfile("waveform.vcd");
		$dumpvars;

		t_clock = 0;
		t_reset_ = 1;
		t_rfd_out = 0;
		
		t_dav_in_1_ = 1;
		t_dav_in_2_ = 1;
	
		t_data_in_1 = 5;
		t_data_in_2 = 6;

		#20;
		
		t_dav_in_1_ = 0;
		t_dav_in_2_ = 0;

		#150;

		t_dav_in_1_ = 1;
		t_dav_in_2_ = 1;

		#20;

		t_rfd_out = 1;

		#20;

		t_rfd_out = 0;
	
		#20;

		$finish;
	end
endmodule
