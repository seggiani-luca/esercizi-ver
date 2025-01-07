module seq(clock, reset_);
	input clock, reset_;

	reg[1:0] STAR;
	localparam
		s0 = 'B00,
		s1 = 'B01,
		s2 = 'B10;

	always @(reset_ == 0) #1 begin
		STAR <= s0;
	end

	reg[7:0] WAIT;

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(STAR)
			s0: begin
				WAIT <= 'D23;
				STAR <= s1;
			end
			s1: begin
				WAIT = WAIT - 1;
				STAR <= s2;
			end
			s2: begin
				WAIT <= WAIT - 1;
				STAR <= (WAIT == 0) ? s0 : s2;
			end
		endcase
	end
endmodule
