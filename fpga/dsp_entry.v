//IMPORTANT VARIABLES
`define ADC_DATLEN 12
`define ADC_DATLEN_LOG2 3
//

module dsp
#(

	//the delay between a sensor reading and the ADC converter reading
	parameter delay = 100,

	//period t between each pulse in clock cycles
	parameter t = 64,
	
	//log base 2 of t used for counting
	parameter t_log2 = 3,
	
	//the signal duration in clock cycles
	parameter d = 64,
	
	//log base 2 of d used for counting
	parameter d_log2 = 3,
	
	//the data size coming from the ADC
	parameter datlen = 12,
	
	//log base 2 of datlen used for counting
	parameter datlen_log2 = 3,
	
	//the number of values to average
	parameter avg_n = 64,
	
	//log base 2 of avg_n used for indexing
	parameter avg_n_log2 = 6

)(
	
	//this FPGA's clock
	input clk,
	
	//the sensor trigger line
	input trigger,
	
	//single input bit from ADC
	input in,
	
	//*average* voltage of pulses during avg_n data entries
	output[0:datlen-1] avg

);

//TODO account for delay by masking clk until after (trigger + delay)

/* READ ADC */
wire[0:datlen-1] adc_out;
wire adc_rdy;

read #(
	
	1,
	datlen,
	datlen_log2
	
)
r0(

	.clk(clk),
	.in(in),
	.out(adc_out),
	.rdy(adc_rdy)
	
);

/* SIGNAL AVERAGING */
sig_avg #(

	datlen,
	avg_n,
	avg_n_log2
	
)
a0(
	
	.clk(adc_rdy),
	.val(adc_out),
	.avg(avg)//output
	
);

//OUTPUT METHOD? UART?

endmodule