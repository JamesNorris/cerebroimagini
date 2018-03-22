//IMPORTANT VARIABLES
`define ADC_DATLEN 12
`define FFT_VLEN 16
`define FFT_VLEN_LOG2 4
//`define FFT_RVAL_BMASK 24'h000FFF
//

module handle_ci_fft(
	input clk,
	//input reset_n,
	input in_nd,////new data can only be input at most every two cycles
	input[0:(`ADC_DATLEN*2)-1] in_x,
	
	output[0:(`ADC_DATLEN*2)-1] out_x,
	
	//check bits
	output out_nd,
	output overflow
);

dit fft0(
	clk,
	1,/*reset_n,*/
	in_x,
	in_nd,/*nd*/
	out_x,
	out_nd,//ready to read
	overflow//if the fft can't keep up with the new data
);

endmodule