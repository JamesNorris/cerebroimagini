//IMPORTANT VARIABLES
`define ADC_DATLEN 12
//

module process(
	input clk,
	input in,//input bit
	output[0:`ADC_DATLEN-1] max730,
	output[0:`ADC_DATLEN-1] max850
);

//collect bits from ADC
wire[0:`ADC_DATLEN-1] ampl;
wire rdy;

read r0(clk, in, ampl, rdy);

//radix-2 DIT FFT
wire[0:`ADC_DATLEN-1] fft_out;
wire out_nd;
wire overflow;

dit fft0(
clk,
1,//reset_n (active low)
ampl,
fft_out,
out_nd,//new data in fft_out
overflow//handle, fft can't keep up
);

//TODO filter, take maximums, send data to uController

//temp (to show incomplete diagram in tech map view)
assign max730 = fft_out;
assign max850 = fft_out;
//end temp

endmodule