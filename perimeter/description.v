// una rete che calcola il perimetro di un rettangolo, con dati ricavati
// dall'handshake /dav-rfd con due produttori e forniti attraverso un altro
// handshake /dav-rfd ad un consumatore 
module perimeter (
	clock, reset_,
	data_in_1, dav_in_1_, rfd_in_1,	// produttore 1  
	data_in_2, dav_in_2_, rfd_in_2, // produttore 2
	data_out, dav_out_, rfd_out);		// consumatore

	input clock, reset_;

	input[7:0] data_in_1;	// produttore 1
	input dav_in_1_;
	output rfd_in_1;
	
	reg RFD_IN_1;
	assign rfd_in_1 = RFD_IN_1;
	
	input[7:0] data_in_2;	// produttore 2
	input dav_in_2_;
	output rfd_in_2;

	reg RFD_IN_2;
	assign rfd_in_2 = RFD_IN_2;

	output[9:0] data_out;	// consumatore
	output dav_out_;
	input rfd_out;

	reg DAV_OUT_;
	assign dav_out_ = DAV_OUT_;

	wire[9:0] comb_out;

	perimeter_comb comb (
		.x7_x0(data_in_1), .y7_y0(data_in_2),
		.z9_z0(comb_out)
	);

	reg[9:0] OUTR;
	assign data_out = OUTR;

	reg STAR;
	localparam
		s0 = 1'B0,
		s1 = 1'B1;

	always @(reset_ == 0) #1 begin
		STAR <= s0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(STAR)	
			s0: begin
				RFD_IN_1 <= 1;
				RFD_IN_2 <= 1;
				DAV_OUT_ <= 1;
				OUTR <= comb_out;
				STAR <= (((dav_in_1_  == 0) & (dav_in_2_ == 0)) & (rfd_out == 1)) ? s1 : s0;
			end
			s1: begin
				RFD_IN_1 <= 0;
				RFD_IN_2 <= 0;
				DAV_OUT_ <= 0;
				OUTR <= OUTR;
				STAR <= (((dav_in_1_ == 1) & (dav_in_2_ == 1)) & (rfd_out == 0)) ? s0 : s1;
			end
		endcase
	end
endmodule

module perimeter_comb(x7_x0, y7_y0, z9_z0);
	input[7:0] x7_x0;
	input[7:0] y7_y0;
	output[9:0] z9_z0;

	wire[8:0] z9_z0_h;
	assign z9_z0 = {z9_z0_h, 1'B0};

	assign z9_z0_h = x7_x0 + y7_y0;
endmodule
