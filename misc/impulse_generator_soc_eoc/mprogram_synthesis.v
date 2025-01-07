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

	// --- ROM ---
	wire m_b1 [0:3];
	wire m_b0 [0:3];
	wire eff [0:3];
	wire[1:0] addr_T [0:3];
	wire[1:0] addr_F [0:3];

	
	assign m_b1[0] = 'BX;
	assign m_b1[1] = 'B0;
	assign m_b1[2] = 'B1;
	
	assign m_b0[0] = 'B0;
	assign m_b0[1] = 'B1;
	assign m_b0[2] = 'B1;

	assign eff[0] = 'B0;
	assign eff[1] = 'B0;
	assign eff[2] = 'B1;

	assign addr_T[0] = 'B00;
	assign addr_T[1] = 'B10;
	assign addr_T[2] = 'B00;
	
	assign addr_F[0] = 'B01;
	assign addr_F[1] = 'B01;
	assign addr_F[2] = 'B10;
	// -----------
		
	assign b1 = m_b1[STAR];
	assign b0 = m_b0[STAR];

	wire c_eff;
	assign c_eff = eff[STAR] ? c1 : c0;

	wire[1:0] addr_N;
	assign addr_N = c_eff ? addr_T[STAR] : addr_F[STAR];

	always @(posedge clock) if(reset_ == 1) #3 begin
		STAR <= addr_N;
	end
endmodule
