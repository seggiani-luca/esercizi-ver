module ABC(a, b, p,
					 dav_, rfd,
					 clock, reset_);
	input[3:0] a, b;
	output[5:0] p;

	input dav_;
	output rfd;
	input clock, reset_;

	reg[6:0] P;
	assign p = P;

	reg RFD;
	assign rfd = RFD;

	reg[3:0] A, B;
	reg[2:0] STAR;
	localparam
		S0 = 0,
		S1 = 1,
		S2 = 2,
		S3 = 3;

	wire[5:0] out_rc;
	RC_PERIMETRO rc (
		.a(A), .b(B),
		.p(out_rc)
	);

	// handshake dav_/rfd
	// a riposo: dav_ = 1, rfd = 1
	// 1) dav_ = 0: dati pronti dal produttore
	// 2) rfd = 0: dati letti dal consumatore
	// 3) dav_ = 1: produttore riprende il dav_
	// 4) rfd = 1: consumatore riprende l'rfd

	always @(reset_ == 0) begin 
		P = 0;
		RFD = 1;
		STAR = S0;
	end

	always @(posedge clock) if(reset_ == 1) #2 begin 
		case (STAR)
			S0 : begin
				STAR <= (dav_ == 0) ? S1 : S0;
			end
			S1 : begin
				A <= a; B <= b;
				RFD <= 0;
				STAR <= S2;
			end
			S2 : begin
				P <= out_rc;
				STAR <= (dav_ == 1) ? S3 : S2;	
			end
			S3 : begin
				RFD <= 1;
				STAR <= S0;
			end
		endcase
	end
endmodule

module RC_PERIMETRO(a, b, p);
	input[3:0] a, b;
	output[5:0] p;

	assign p = (a + b) * 2;
endmodule
