module testbench();
	reg t_x, t_y;
	wire t_w, t_z;

	rc dut (
		.x(t_x), .y(t_y),
		.w(t_w), .z(t_z)
	);

	initial begin
		// per gtkwave
		$dumpfile("waveform.vcd");
		$dumpvars;
		
		// qui va la sequenza del testbench
		// x:0 e y:0 -> z:0 e w:0 
		$display("Test x:0 e y:0 -> z:0 e w:0");
		t_x = 0;
		t_y = 0;

		#10; //aspetta

		if(t_z == 0 && t_w == 0)
			$display("Ok!");
		else
			$display("Questo male...");

		// x:1 e y:0 -> z:1 e w:0 
		$display("Test x:1 e y:0 -> z:1 e w:0");
		t_x = 1;
		t_y = 0;

		#10; //aspetta

		if(t_z == 1 && t_w == 0)
			$display("Ok!");
		else
			$display("Questo male...");

		// x:0 e y:1 -> z:1 e w:0 
		$display("Test x:0 e y:1 -> z:1 e w:0");
		t_x = 0;
		t_y = 1;

		#10; //aspetta

		if(t_z == 1 && t_w == 0)
			$display("Ok!");
		else
			$display("Questo male...");

		// x:1 e y:1 -> z:1 e w:1 
		$display("Test x:1 e y:1 -> z:1 e w:1");
		t_x = 1;
		t_y = 1;

		#10; //aspetta

		if(t_z == 1 && t_w == 1)
			$display("Ok!");
		else
			$display("Questo male...");

		//chiudi
		$finish;

 	end

endmodule
