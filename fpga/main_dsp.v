//IMPORTANT VARIABLES
`define ADC_DATLEN 12
`define FFT_VLEN 16
`define FFT_VLEN_LOG2 4
//

module process
(
	input clk,
	input in,//input bit
	output[0:`ADC_DATLEN-1] max730,
	output[0:`ADC_DATLEN-1] max850
);

/* COLLECT BITS FROM ADC */
wire[0:`ADC_DATLEN-1] ampl_t;
wire rdy;

read r0(
	clk, 
	in, 
	ampl_t, 
	rdy
);

//RDY IS NOW OUR INPUT CLOCK!!!

/* STORE EACH VALUE AS REQUIRED BY DECIMATION IN TIME */
reg[0:`FFT_VLEN_LOG2] count_val;
initial count_val = 0;

wire[0:`ADC_DATLEN-1] store_x;

dit_store cont0(
	rdy,
	ampl_t,
	rdy,//update the output every time we input
	count_val,//the index of the value we want (sequential)
	store_x//output of the store
);

/* PERFORM radix-2 DECIMATION-IN-TIME FFT */
reg[0:`ADC_DATLEN*2-1] in_x;//24 bits!
reg in_nd;

wire[0:`ADC_DATLEN*2-1] out_x;
wire out_nd;

reg out_nd_prev;

initial in_x = 0;
initial in_nd = 1;

always @(negedge rdy) begin
	if (out_nd & !out_nd_prev) begin//posedge out_nd
		count_val = 0;//restart counter
	end
	
	if (!out_nd & out_nd_prev) begin//negegde out_nd
		in_nd = 1;
		count_val = 0;//restart counter
	end
	
	out_nd_prev = out_nd;
	
	if (count_val < `FFT_VLEN) begin
		if (in_nd) begin
			in_x = store_x;
		end
		
		count_val = count_val + 1;
	end else begin
		count_val = 0;
		in_nd = 0;
	end
end

wire overflow;//TODO handle

dit fft0(
	rdy,
	1,//reset_n (active low)
	in_x,
	in_nd,
	out_x,
	out_nd,//new data in fft_out
	overflow//handle, fft can't keep up
);

//TODO filter, take maximums, send data to uController

//temp (to show incomplete diagram in tech map view)
assign max730 = out_x;
assign max850 = out_x;
//end temp

endmodule