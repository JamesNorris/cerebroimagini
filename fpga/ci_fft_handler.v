//IMPORTANT VARIABLES
`define ADC_DATLEN 12
`define FFT_RVAL_BMASK 24'h000FFF
//

module handle_ci_fft(
	input clk,
	//input reset_n,
	input nd,//new data at input
	input[0:`ADC_DATLEN-1] data,
	
	output[0:`ADC_DATLEN-1] real_out,//only real required by our application
	
	output out_nd,
	output overflow
);

reg[0:(`ADC_DATLEN*2)-1] in_x;//multiply data by twiddle coeffs and store here

wire[0:(`ADC_DATLEN*2)-1] out_x;

dit fft0(
	clk,
	1/*reset_n*/,
	in_x,
	nd,
	out_x,
	out_nd,//ready to read
	overflow//if the fft can't keep up with the new data
);

//TODO output out_nd and overflow and handle appropriately

assign real_out = out_x & `FFT_RVAL_BMASK;

endmodule