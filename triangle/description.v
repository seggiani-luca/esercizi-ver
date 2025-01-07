// un generatore di onde triangolari
module triangle(clock, reset_, dav_, rfd, amp, v);
	input clock, reset_;
	
	input dav_;
	output rfd;
	
	reg RFD;
	assign rfd = RFD;

	input[6:0] amp;
	
	reg signed[6:0] AMP;

	output signed [6:0] v;

	reg signed [6:0] OUTR;
	assign v = OUTR;

	reg[1:0] STAR;
	localparam
		s0 = 2'B00,
		s1 = 2'B01,
		s2 = 2'B10,
		s3 = 2'B11;

	always @(reset_) if(reset_ == 0) #1 begin
		RFD <= 1;
		OUTR <= 0;
		STAR <= s0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(STAR)
			s0 : begin
				AMP <= amp;
				STAR <= (dav_ == 0) ? s1 : s0;
			end
			s1 : begin
				RFD <= 0;
				STAR <= (dav_ == 1) ? s2 : s1;
			end
			s2 : begin
				RFD <= 1;
				OUTR <= (OUTR >= AMP) ? OUTR - 1 : OUTR + 1;
				STAR <= (OUTR >= AMP) ? s3 : s2;
			end
			s3 : begin
				OUTR <= (OUTR <= -AMP) ? OUTR + 1 : OUTR - 1;
				STAR <= (OUTR <= -AMP) ? s2 : s3;
			end
		endcase
	end
endmodule
