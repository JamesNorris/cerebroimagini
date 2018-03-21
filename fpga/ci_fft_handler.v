module handle_ci_fft(
	input clk,
	//input reset_n,
	input nd,//new data at input
	input[0:11] data,
	output[0:11] real_out//only real required by our application
);

reg[0:23] in_x;//multiply data by twiddle coeffs and store here

wire[0:23] out_x;
wire out_nd;
wire overflow;

dit fft0(
	clk,
	1/*reset_n*/,
	in_x,
	nd,
	out_x,
	out_nd,//ready to read
	overflow//if the fft can't keep up with the new data
);

assign real_out = out_x & 24'h000FFF;

endmodule