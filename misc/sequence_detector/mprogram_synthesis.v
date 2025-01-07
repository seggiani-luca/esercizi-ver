// riconoscitore di sequenze alternate 00, 01, 10 e 11, 01, 10, con 
// contatore su 4 bit di sequenze riconosciute 
module sequence_detector(reset_, clock, x1_x0, z3_z0);
	input reset_, clock;
	input[1:0] x1_x0;
	output[3:0] z3_z0;

	wire b0; // comando 
	wire[1:0] c1_c0; // condizionamento
	
	wire[1:0] mjr;

	data_path dp(reset_, clock, x1_x0, z3_z0, b0, c1_c0, mjr);
	control_unit cu(reset_, clock, b0, c1_c0, mjr);
endmodule;

module data_path(reset_, clock, x1_x0, z3_z0, b0, c1_c0, mjr);
	input reset_, clock;
	input[1:0] x1_x0;
	output[3:0] z3_z0;
	input b0;
	output[1:0] c1_c0;
	output[1:0] mjr;

	reg[3:0] COUNT;
	assign z3_z0 = COUNT;

	always @(reset_ == 0) #1 begin
		COUNT <= 0;	
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		// sarebbe un multiplexer 2 a 1 pilotato da b0
		case(b0)
			0: COUNT <= COUNT;
									 // sarebbe un multiplexer 2 a 1 pilotato da x1 & ~x0
			1: COUNT <= (x1_x0 == 'B10) ? COUNT + 1 : COUNT;
		endcase
	end

	assign c1_c0[1] = ({COUNT[0], x1_x0} == 'B000) | ({COUNT[0], x1_x0} == 'B111);
	assign c1_c0[0] = x1_x0 == 'B01;

	// questo non funziona con allineamento ai clock (c'e' un ciclo extra di
	// sincronizzazione per il MJR, in verita' non sarebbe il modello giusto
	// a prescindere...)
	assign mjr = c1_c0[0] ? 'B11 : c1_c0[1] ? 'B01 : 'B00; 
endmodule

module control_unit(reset_, clock, b0, c1_c0, mjr);
	input reset_, clock;
	output b0;
	input[1:0] c1_c0;
	input[1:0] mjr;

	reg[1:0] STAR;
	localparam
		s0 = 'B00,
		s1 = 'B01,
		s2 = 'B10,
		s3 = 'B11;

	reg[1:0] MJR;

	always @(reset_ == 0) #1 begin
		STAR <= s0;
	end

	// --- ROM ---
	wire m_b0 [0:3];
	wire eff [0:3];
	wire[1:0] addr_T [0:3];
	wire[1:0] addr_F [0:3];
	wire m_type [0:3];
	
	assign m_b0[0] = 'B0;
	assign m_b0[1] = 'B0;
	assign m_b0[2] = 'B0;
	assign m_b0[3] = 'B1;

	assign eff[0] = 'B1;
	assign eff[1] = 'B0;
	assign eff[2] = 'BX;
	assign eff[3] = 'B1;

	assign addr_T[0] = 'B01;
	assign addr_T[1] = 'B10;
	assign addr_T[2] = 'BXX;
	assign addr_T[3] = 'B01;
	
	assign addr_F[0] = 'B00;
	assign addr_F[1] = 'B10;
	assign addr_F[2] = 'BXX;
	assign addr_F[3] = 'B00;

	assign m_type[0] = 'B0;
	assign m_type[1] = 'B0;
	assign m_type[2] = 'B1;
	assign m_type[3] = 'B0;
	// -----------
	
	assign b0 = m_b0[STAR];

	wire c_eff;
	assign c_eff = c1_c0[eff[STAR]];

	wire[1:0] addr_N;
	assign addr_N = c_eff ? addr_T[STAR] : addr_F[STAR];

	always @(posedge clock) if(reset_ == 1) #3 begin
		MJR <= mjr;
		STAR <= m_type[STAR] ? MJR : addr_N;
	end
endmodule
