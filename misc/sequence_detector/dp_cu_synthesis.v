// riconoscitore di sequenze alternate 00, 01, 10 e 11, 01, 10, con 
// contatore su 4 bit di sequenze riconosciute 
module sequence_detector(reset_, clock, x1_x0, z3_z0);
	input reset_, clock;
	input[1:0] x1_x0;
	output[3:0] z3_z0;

	wire b0; // comando 
	wire[1:0] c1_c0; // condizionamento
	
	data_path dp(reset_, clock, x1_x0, z3_z0, b0, c1_c0);
	control_unit cu(reset_, clock, b0, c1_c0);
endmodule;

module data_path(reset_, clock, x1_x0, z3_z0, b0, c1_c0);
	input reset_, clock;
	input[1:0] x1_x0;
	output[3:0] z3_z0;
	input b0;
	output[1:0] c1_c0;

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
endmodule

module control_unit(reset_, clock, b0, c1_c0);
	input reset_, clock;
	output b0;
	input[1:0] c1_c0;

	reg[1:0] STAR;
	localparam
		s0 = 'B00,
		s1 = 'B01,
		s2 = 'B10;

	assign b0 = STAR == s2;

	always @(reset_ == 0) #1 begin
		STAR <= s0;
	end
	
	always @(posedge clock) if(reset_ == 1) #3 begin
		case(STAR)
			s0: begin
				STAR <= c1_c0[1] ? s1 : s0;
			end 
			s1: begin
				STAR <= c1_c0[0] ? s2:
								c1_c0[1] ? s1 : s0; 
			end 
			s2: begin
				STAR <= c1_c0[1] ? s1 : s0; 
			end 
		endcase
	end
endmodule
