// una rete che calcola l'area di un rettangolo, con dati ricavati
// dall'handshake /dav-rfd con due produttori e forniti attraverso un altro
// handshake /dav-rfd ad un consumatore 
module perimeter (
	clock, reset_,
	data_in_1, dav_in_1_, rfd_in_1,	// produttore 1  
	data_in_2, dav_in_2_, rfd_in_2, // produttore 2
	data_out, dav_out_, rfd_out);		// consumatore

	input clock, reset_;

	reg HS_L; // unifica RFD_IN_1, RFD_IN_2 
	reg HS_R; // DAV_OUT_

	input[7:0] data_in_1;	// produttore 1
	input dav_in_1_;
	output rfd_in_1;

	assign rfd_in_1 = HS_L;
	
	reg[7:0] DATA_1;

	input[7:0] data_in_2;	// produttore 2
	input dav_in_2_;
	output rfd_in_2;

	assign rfd_in_2 = HS_L;
	
	reg[7:0] DATA_2;

	output[15:0] data_out;	// consumatore
	output dav_out_;
	input rfd_out;

	assign dav_out_ = HS_R;

	reg[15:0] PR;
	assign data_out = PR;
	
	wire[15:0] comb_out;
	
	pr_comb comb (
		.x7_x0(DATA_1), .y0_i(DATA_2[0]), .p15_p0_i(PR),
		.z15_z0(comb_out)
	);

	reg[2:0] COUNT;

	reg[1:0] STAR;
	localparam
		s0 = 2'B00,
		s1 = 2'B01,
		s2 = 2'B10,
		s3 = 2'B11;

	always @(reset_ == 0) #1 begin
		HS_L <= 1;
		HS_R <= 1;
		STAR <= s0;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		casex(STAR)	
			s0: begin
				HS_L <= 1;
				HS_R <= 1;
				DATA_1 <= data_in_1;
				DATA_2 <= data_in_2;
				PR <= 0;
				COUNT <= 0;
				STAR <= ((dav_in_1_  == 0) & (dav_in_2_ == 0)) ? s1 : s0;
			end
			s1: begin
				HS_L <= 0;
				HS_R <= HS_R;
				DATA_1 <= DATA_1;
				DATA_2 <= DATA_2 >> 1;
				PR <= comb_out;
				COUNT <= COUNT - 1;
				STAR <= (COUNT == 1) ? s2 : s1;
			end
			s2: begin
				HS_L <= HS_L;
				HS_R <= HS_R; 
				DATA_1 <= DATA_1;
				DATA_2 <= DATA_2;
				PR <= PR;
				COUNT <= COUNT;
				STAR <= (rfd_out == 1) ? s3 : s2;
			end
			s3: begin
				HS_L <= HS_L;
				HS_R <= 0;
				DATA_1 <= DATA_1;
				DATA_2 <= DATA_2;
				PR <= PR;
				COUNT <= COUNT;
				STAR <= (((dav_in_1_ == 1) & (dav_in_2_ == 1)) & (rfd_out == 0)) ? s0 : s3;
			end
		endcase
	end
endmodule

module pr_comb(x7_x0, y0_i, p15_p0_i, z15_z0);
	input[7:0] x7_x0;
	input y0_i;
	input[15:0] p15_p0_i;
	output[15:0] z15_z0;

	wire[15:0] partial_0;
	assign partial_0 = (y0_i ? x7_x0 : 0) << 8;
	
	wire[16:0] partial_1;	
	assign partial_1 = partial_0 + p15_p0_i;

	assign z15_z0 = partial_1 >> 1; 
endmodule
