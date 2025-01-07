// un "generatore di impulsi" che legge da @numero attraverso un handshake soc-eoc, e genera un segnale
// alto per @numero cicli di clock
module impulse_generator(reset_, clock, numero, out, soc, eoc);
	input reset_, clock;
	input[7:0] numero;
	output out;
	output soc;
	input eoc;
	
	data_path dp(reset_, clock, numero, out, soc, eoc, b1, b0, c1, c0);
	control_unit cu(reset_, clock, b1, b0, c1, c0);
endmodule

module data_path(reset_, clock, numero, out, soc, eoc, b1, b0, c1, c0);
	input reset_, clock;
	input[7:0] numero;
	output out;
	output soc;
	input eoc;

	input b1, b0;
	output c1, c0;

	reg[7:0] COUNT;

	reg SOC;
	assign soc = SOC;
	
	reg OUT;
	assign out = OUT;

	always @(reset_ == 0) #1 begin
		SOC <= 0;
		OUT <= 0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex({b1, b0})
			'B?0: begin
				COUNT <= COUNT;
				SOC <= 1;
				OUT <= 0;
			end
			'B01: begin
				COUNT <= numero;
				SOC <= 0;
				OUT <= OUT;
			end
			'B11: begin
				COUNT <= COUNT - 1;
				SOC <= SOC;
				OUT <= 1;
			end
		endcase
	end

	assign c0 = eoc == 1;
	assign c1 = COUNT == 1;
endmodule

module control_unit(reset_, clock, b1, b0, c1, c0);
	input reset_, clock;

	output b1, b0;
	input c1, c0;

	reg[1:0] STAR;
	localparam
		s0 = 'B00,
		s1 = 'B01,
		s2 = 'B10;

	always @(reset_ == 0) #3 begin
		STAR <= s0;
	end
	
	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(STAR)
			s0: begin
				STAR <= c0 ? s0 : s1;
			end
			s1: begin
				STAR <= c0 ? s2 : s1;
			end
			s2: begin
				STAR <= c1 ? s0 : s2;
			end
		endcase
	end
	
	assign {b1, b0} = (STAR == s0) ? 'BX0: 
										(STAR == s1) ? 'B01 : 'B11;
endmodule

// module impulse_generator(reset_, clock, numero, out, soc, eoc);
// 	input reset_, clock;
// 	input[7:0] numero;
// 	
// 	reg OUT;
// 	output out;
// 	assign out = OUT;
// 
// 	// handshake
// 	input eoc;
// 	reg SOC;
// 	output soc;
// 	assign soc = SOC;
// 
// 	// registri
// 	reg[7:0] COUNT;
// 	reg[1:0] STAR;
// 	localparam
// 		s0 = 'B00,
// 		s1 = 'B01,
// 		s2 = 'B10;
// 	
// 	// COUNT
// 	wire b1, b0;
// 	assign {b1, b0} = (STAR == s0) ? 'BX0: 
// 										(STAR == s1) ? 'B01 : 'B11;
// 
// 	always @(posedge clock) if(reset_ == 1) #3 begin
// 		casex({b1, b0})
// 			'B?0: begin
// 				COUNT <= COUNT;
// 			end
// 			'B01: begin
// 				COUNT <= numero;
// 			end
// 			'B11: begin
// 				COUNT <= COUNT - 1;
// 			end
// 		endcase
// 	end
// 	
// 	// SOC
// 	always @(reset_ == 0) #1 begin
// 		SOC <= 0;
// 	end
// 
// 	always @(posedge clock) if(reset_ == 1) #3 begin
// 		casex({b1, b0})
// 			'B?0: begin
// 				SOC <= 1;
// 			end
// 			'B01: begin
// 				SOC <= 0;
// 			end
// 			'B11: begin
// 				SOC <= SOC;
// 			end
// 		endcase
// 	end
// 	
// 	// OUT
// 	always @(reset_ == 0) #1 begin
// 		OUT <= 0;
// 	end
// 
// 	always @(posedge clock) if(reset_ == 1) #3 begin
// 		casex({b1, b0})
// 			'B?0: begin
// 				OUT <= 0;
// 			end
// 			'B01: begin
// 				OUT <= OUT;
// 			end
// 			'B11: begin
// 				OUT <= 1;
// 			end
// 		endcase
// 	end
// 	
// 	// STAR
// 	wire c0 = eoc == 1;
// 	wire c1 = COUNT == 1;
// 
// 	always @(reset_ == 0) #1 begin
// 		STAR <= s0;
// 	end
// 
// 	always @(posedge clock) if(reset_ == 1) #3 begin
// 		casex(STAR)
// 			s0: begin
// 				STAR <= (~c0) ? s1 : s0;
// 			end
// 			s1: begin
// 				STAR <= (c0) ? s2 : s1;
// 			end
// 			s2: begin
// 				STAR <= (c1) ? s0 : s2;
// 			end
// 		endcase
// 	end
// endmodule
