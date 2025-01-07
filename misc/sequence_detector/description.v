// riconoscitore di sequenze alternate 00, 01, 10 e 11, 01, 10, con 
// contatore su 4 bit di sequenze riconosciute 
module sequence_detector(reset_, clock, x1_x0, z3_z0);
	input reset_, clock;
	input[1:0] x1_x0;
	output[3:0] z3_z0;
	
	reg[1:0] STAR;
	localparam
		s0 = 'B00,
		s1 = 'B01,
		s2 = 'B10;

	reg[3:0] COUNT;
	assign z3_z0 = COUNT;
	
	always @(reset_ == 0) #1 begin
		STAR <= s0;
		COUNT <= 0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		case(STAR)
			s0: begin
				COUNT <= COUNT;
				STAR <= match(COUNT[0], x1_x0) ? s1 : s0;
			end 
			s1: begin
				COUNT <= COUNT;
				STAR <= (x1_x0 == 'B01) ? s2:
								 match(COUNT[0], x1_x0) ? s1 : s0; 
			end 
			s2: begin
				COUNT <= (x1_x0 == 'B10) ? COUNT + 1 : COUNT;
				STAR <= match(COUNT[0], x1_x0) ? s1 : s0; 
			end 
		endcase
	end

	function match;
		input type;
		input[1:0] x1_x0;
		case({type, x1_x0})
			'B000: match = 1;
			'B111: match = 1;
			default: match = 0;
		endcase
	endfunction
endmodule
