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
	
	input[7:0] data_in_2;	// produttore 2
	input dav_in_2_;
	output rfd_in_2;

	output[9:0] data_out;	// consumatore
	output dav_out_;
	input rfd_out;

	wire b0;
	
	wire c1, c0;

	data_path dp (
		clock, reset_,
		data_in_1, dav_in_1_, rfd_in_1,	// produttore 1	
		data_in_2, dav_in_2_, rfd_in_2, // produttore 2
		data_out, dav_out_, rfd_out,		// consumatore
		b0, c1, c0
	);

	control_unit cu (
		clock, reset_,
		b0, c1, c0
	);
endmodule

module data_path (
	clock, reset_,
	data_in_1, dav_in_1_, rfd_in_1,	// produttore 1	
	data_in_2, dav_in_2_, rfd_in_2, // produttore 2
	data_out, dav_out_, rfd_out,		// consumatore
	b0, c1, c0);	
	
	input clock, reset_;

	reg HS; // unifica RFD_IN_1, RFD_IN_2 e DAV_OUT_

	input[7:0] data_in_1;	// produttore 1
	input dav_in_1_;
	output rfd_in_1;
	
	assign rfd_in_1 = HS;
	
	input[7:0] data_in_2;	// produttore 2
	input dav_in_2_;
	output rfd_in_2;

	assign rfd_in_2 = HS;

	output[9:0] data_out;	// consumatore
	output dav_out_;
	input rfd_out;

	assign dav_out_ = HS;
	
	wire[9:0] comb_out;

	perimeter_comb comb (
		.x7_x0(data_in_1), .y7_y0(data_in_2),
		.z9_z0(comb_out)
	);

	reg[9:0] OUTR;
	assign data_out = OUTR;

	input b0;

	output c1;
	assign c1 = (((dav_in_1_ == 1) & (dav_in_2_ == 1)) & (rfd_out == 0));
	
	output c0;
	assign c0 = (((dav_in_1_  == 0) & (dav_in_2_ == 0)) & (rfd_out == 1));

	always @(reset_ == 0) #1 begin
		HS <= 1;
	end

	always @(posedge clock) if(reset_ == 1) #3 begin
		HS <= b0;
		OUTR <= b0 ? comb_out : OUTR;
	end
endmodule

module control_unit (
	clock, reset_,
	b0, c1, c0);
	
	input clock, reset_;

	output b0;
	
	input c1, c0;
	
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
				STAR <= c0 ? s1 : s0;
			end
			s1: begin
				STAR <= c1 ? s0 : s1;
			end
		endcase
	end

	assign b0 = (STAR == s0);
endmodule

module perimeter_comb(x7_x0, y7_y0, z9_z0);
	input[7:0] x7_x0;
	input[7:0] y7_y0;
	output[9:0] z9_z0;

	wire[8:0] z9_z0_h;
	assign z9_z0 = {z9_z0_h, 1'B0};

	assign z9_z0_h = x7_x0 + y7_y0;
endmodule
