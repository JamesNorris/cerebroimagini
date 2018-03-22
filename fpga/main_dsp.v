//IMPORTANT VARIABLES
`define ADC_DATLEN 12
//`define ADC_DATLEN_LOG2 3
`define FFT_VLEN 16
`define FFT_VLEN_LOG2 4
//`define FFT_RVAL_BMASK 24'h000FFF
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

/*
//initial buffer
reg[0:`FFT_VLEN_LOG2] count;//counts values

always @(posedge rdy) begin
	if (count == `FFT_VLEN) begin
		//we have FFT_VLEN values
	end else begin
		count <= count + 1;
	end
end
*/

//radix-2 DIT FFT
wire[0:`ADC_DATLEN-1] fft_out;
wire out_nd;
wire overflow;

handle_ci_fft fft0(
clk,
rdy,
ampl,//<- here's our data
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