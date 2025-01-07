// un "generatore di impulsi" che legge da @numero attraverso un handshake /dav-rfd, e genera un segnale
// alto per @numero cicli di clock
module impulse_generator(reset_, clock, numero, out, dav_, rfd);
	input reset_, clock;
	input[7:0] numero;
	
	reg OUT;
	output out;
	assign out = OUT;

	// handshake
	input dav_;
	reg RFD;
	output rfd;
	assign rfd = RFD;

	// registri
	reg[7:0] COUNT;
	reg[1:0] STAR;
	localparam
		s0 = 'B00,
		s1 = 'B01,
		s2 = 'B10;

	always @(reset_ == 0) #1 begin
		RFD <= 1;
		OUT <= 0;
		STAR <= s0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		case(STAR)
			s0: begin
				RFD <= 1;
				COUNT <= numero;
				OUT <= 0;
				STAR <= (dav_ == 0) ? s1 : s0;
			end
			s1: begin
				RFD <= 0;
				COUNT <= COUNT - 1;
				OUT <= 1;
				STAR <= (COUNT == 1) ? s2 : s1;
			end
			s2: begin
				RFD <= 0;
				// COUNT <= don't care
				OUT <= 0;
				STAR <= (dav_ == 1) ? s0 : s2;
			end
		endcase
	end
endmodule
