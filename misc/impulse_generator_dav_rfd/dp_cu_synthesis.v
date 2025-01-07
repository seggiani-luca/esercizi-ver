// un "generatore di impulsi" che legge da @numero attraverso un handshake /dav-rfd, e genera un segnale
// alto per @numero cicli di clock
module impulse_generator(reset_, clock, numero, out, dav_, rfd);
	input reset_, clock;
	input[7:0] numero;
	output out;
	input dav_;
	output rfd;

	wire[1:0] b1_b0; 

	wire[1:0] c1_c0; 

	data_path dp(reset_, clock, numero, out, dav_, rfd, b1_b0, c1_c0);
	control_unit cu(reset_, clock, b1_b0, c1_c0);
endmodule

module data_path(reset_, clock, numero, out, dav_, rfd, b1_b0, c1_c0);
	input reset_, clock;
	input[7:0] numero;
	output out;
	input dav_;
	output rfd;

	input[1:0] b1_b0;
	output[1:0] c1_c0;

	reg[7:0] COUNT;
	reg RFD;
	assign rfd = RFD;
	reg OUT;
	assign out = OUT;

	always @(reset_ == 0) #1 begin
		RFD <= 1;
		OUT <= 0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		RFD <= b1_b0[0];
		
		case(b1_b0[1])
			0: begin
				COUNT <= numero;
			end
			1: begin
				COUNT <= COUNT - 1;
			end
		endcase
		
		OUT <= b1_b0[1];
	end

	assign c1_c0[1] = COUNT == 1;
	assign c1_c0[0] = dav_ == 1;
endmodule

module control_unit(reset_, clock, b1_b0, c1_c0);
	input reset_, clock;
	output[1:0] b1_b0;
	input[1:0] c1_c0;

	reg[1:0] STAR;
	localparam
		s0 = 'B00,
		s1 = 'B01,
		s2 = 'B10;

	always @(reset_ == 0) #1 begin
		STAR <= s0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		case(STAR)
			s0: begin
				STAR <= (c1_c0[0]) ? s0 : s1;
			end
			s1: begin
				STAR <= (c1_c0[1]) ? s2 : s1;
			end
			s2: begin
				STAR <= (c1_c0[0]) ? s0 : s2;
			end
		endcase
	end
	
 	assign b1_b0[1] = STAR == s1;
 	assign b1_b0[0] = STAR == s0;
endmodule
