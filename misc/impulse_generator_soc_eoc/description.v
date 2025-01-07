// un "generatore di impulsi" che legge da @numero attraverso un handshake soc-eoc, e genera un segnale
// alto per @numero cicli di clock
module impulse_generator(reset_, clock, numero, out, soc, eoc);
	input reset_, clock;
	input[7:0] numero;
	
	reg OUT;
	output out;
	assign out = OUT;

	// handshake
	input eoc;
	reg SOC;
	output soc;
	assign soc = SOC;

	// registri
	reg[7:0] COUNT;
	reg[1:0] STAR;
	localparam
		s0 = 'B00,
		s1 = 'B01,
		s2 = 'B10;

	always @(reset_ == 0) #1 begin
		SOC <= 0;
		OUT <= 0;
		STAR <= s0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		case(STAR)
			s0: begin
				SOC <= 1;
				OUT <= 0;
				STAR <= (eoc == 0) ? s1 : s0;
			end
			s1: begin
				SOC <= 0;
				COUNT <= numero;
				//OUT <= 0; // c'e' gia'
				STAR <= (eoc == 1) ? s2 : s1;
			end
			s2: begin
				// SOC <= don't care
				COUNT <= COUNT - 1;
				OUT <= 1;
				STAR <= (COUNT == 1) ? s0 : s2;
			end
		endcase
	end
endmodule
