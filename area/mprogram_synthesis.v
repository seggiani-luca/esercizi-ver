// una rete che calcola l'area di un rettangolo, con dati ricavati
// dall'handshake /dav-rfd con due produttori e forniti attraverso un altro
// handshake /dav-rfd ad un consumatore 
module perimeter (
	clock, reset_,
	data_in_1, dav_in_1_, rfd_in_1,	// produttore 1  
	data_in_2, dav_in_2_, rfd_in_2,	// produttore 2
	data_out, dav_out_, rfd_out);		// consumatore

	input clock, reset_;

	input[7:0] data_in_1;	// produttore 1
	input dav_in_1_;
	output rfd_in_1;

	input[7:0] data_in_2;	// produttore 2
	input dav_in_2_;
	output rfd_in_2;

	output[15:0] data_out;	// consumatore
	output dav_out_;
	input rfd_out;

	wire b1, b0;
	wire c3, c2, c1, c0;

	data_path dp (	
		clock, reset_,
		data_in_1, dav_in_1_, rfd_in_1,	// produttore 1  
		data_in_2, dav_in_2_, rfd_in_2,	// produttore 2
		data_out, dav_out_, rfd_out,		// consumatore
		b1, b0, c3, c2, c1, c0	
	);

	control_unit cu (
		clock, reset_,
		b1, b0, {c3, c2, c1, c0} 
	);
endmodule

module data_path (
	clock, reset_,
	data_in_1, dav_in_1_, rfd_in_1,	// produttore 1  
	data_in_2, dav_in_2_, rfd_in_2,	// produttore 2
	data_out, dav_out_, rfd_out,		// consumatore
	b1, b0, c3, c2, c1, c0);	

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

	input b1, b0;

	output c3, c2, c1, c0;
	assign c0 = (dav_in_1_  == 0) & (dav_in_2_ == 0);
	assign c1 = COUNT == 1;
	assign c2 = rfd_out == 1;
	assign c3 = ((dav_in_1_ == 1) & (dav_in_2_ == 1)) & (rfd_out == 0);

	// HS_L
	always @(reset_ == 0) #1 begin
		HS_L <= 1;
	end
	
	always @(posedge clock) if(reset_ == 1) #3 begin	
		HS_L <= ~b1 & ~b0;
	end
	
	// HS_R
	always @(reset_ == 0) #1 begin
		HS_R <= 1;
	end
	
	always @(posedge clock) if(reset_ == 1) #3 begin	
		HS_R <= ~(b1 & b0);
	end
	
	// DATA_1
	always @(posedge clock) if(reset_ == 1) #3 begin	
		casex({b1, b0})
			'B00: begin
				DATA_1 <= data_in_1;
			end
			'B01: begin
				DATA_1 <= DATA_1;
			end
			'B1?: begin	
				DATA_1 <= DATA_1;
			end
		endcase
	end

	// DATA_2
	always @(posedge clock) if(reset_ == 1) #3 begin	
		casex({b1, b0})
			'B00: begin
				DATA_2 <= data_in_2;
			end
			'B01: begin
				DATA_2 <= DATA_2 >> 1;
			end
			'B1?: begin	
				DATA_2 <= DATA_2;
			end
		endcase
	end
	
	// PR
	always @(posedge clock) if(reset_ == 1) #3 begin	
		casex({b1, b0})
			'B00: begin
				PR <= 0;
			end
			'B01: begin
				PR <= comb_out;
			end
			'B1?: begin	
				PR <= PR;
			end
		endcase
	end
	
	// COUNT
	always @(posedge clock) if(reset_ == 1) #3 begin	
		casex({b1, b0})
			'B00: begin
				COUNT <= 0;
			end
			'B01: begin
				COUNT <= COUNT - 1;
			end
			'B1?: begin	
				COUNT <= COUNT;
			end
		endcase
	end
endmodule

module control_unit (
	clock, reset_,
	b1, b0,
	c3_c0);
	
	input clock, reset_;

	output b1, b0;

	input[3:0] c3_c0;
	
	reg[1:0] STAR;
	localparam
		s0 = 2'B00,
		s1 = 2'B01,
		s2 = 2'B10,
		s3 = 2'B11;

	always @(reset_ == 0) #1 begin
		STAR <= s0;
	end
	
	// --- ROM ---
	wire[1:0] m_b1_b0 [0:3];
	wire[1:0] eff [0:3];
	wire[1:0] addr_T [0:3];
	wire[1:0] addr_F [0:3];
	
	assign m_b1_b0[0] = 'B00;
	assign m_b1_b0[1] = 'B01;
	assign m_b1_b0[2] = 'B10;
	assign m_b1_b0[3] = 'B11;

	assign eff[0] = 'B00;
	assign eff[1] = 'B01;
	assign eff[2] = 'B10;
	assign eff[3] = 'B11;

	assign addr_T[0] = 'B01;
	assign addr_T[1] = 'B10;
	assign addr_T[2] = 'B11;
	assign addr_T[3] = 'B00;
	
	assign addr_F[0] = 'B00;
	assign addr_F[1] = 'B01;
	assign addr_F[2] = 'B10;
	assign addr_F[3] = 'B11;
	// -----------
	
	assign b1 = m_b1_b0[STAR][1];
	assign b0 = m_b1_b0[STAR][0];

	wire c_eff;
	assign c_eff = c3_c0[eff[STAR]];

	wire[1:0] addr_N;
	assign addr_N = c_eff ? addr_T[STAR] : addr_F[STAR];

	always @(posedge clock) if(reset_ == 1) #3 begin
		STAR <= addr_N;
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
