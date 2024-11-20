module b2_counter(eu, q, ei, clock, reset_);
  input clock, reset_;
  input ei;
  output eu, q;
  reg OUTR;
  assign q = OUTR;	
  wire a;
  assign {a, eu} = ({q, ei} == 'B00) ? 'B00:
                   ({q, ei} == 'B10) ? 'B10:
                   ({q, ei} == 'B01) ? 'B10:
                 /*({q, ei} == 'B11)*/ 'B01;
  always @(reset_ == 0) #1 OUTR <= 0;
  always @(posedge clock) if (reset_==1) #2 OUTR <= a;
endmodule
