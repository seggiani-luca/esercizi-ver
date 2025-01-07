module testbench();
	reg t_reset_, t_clock;
	reg[7:0] t_numero;
	reg t_eoc;

	wire t_out;
	wire t_soc;

	impulse_generator impulse_gen (
		.reset_(t_reset_), .clock(t_clock),
		.numero(t_numero), .out(t_out),
		.eoc(t_eoc), .soc(t_soc)
	);

	initial forever #5 t_clock = ~t_clock;

	initial begin
		$dumpfile("waveform.vcd");
		$dumpvars;

		t_clock = 0;
		t_reset_ = 1;
		t_eoc = 1;

		t_numero = 10;
	
		#10;
	
		t_eoc = 0;
	
		#20;
		
		t_eoc = 1;
		
		#200;

		t_numero = 5;
		
		#10;

		t_eoc = 0;

		#20;

		t_eoc = 1;

		#100;

		$finish;
	end
endmodule
