module process
#(
	
	//length of the input data read from the ADC
	parameter datlen = 12,
	
	//vector length N of the FFT (# bins)
	parameter vlen = 16,
	
	//log base 2 of vlen used for counting
	parameter vlen_log2 = 4
	
)(

	input clk,
	
	input in,//input bit
	
	output[0:datlen-1] max730,
	
	output[0:datlen-1] max850
	
);

/* COLLECT BITS FROM ADC */
wire[0:datlen-1] ampl_t;
wire rdy;

read r0(

	clk, 
	in, 
	ampl_t, 
	rdy
	
);

/* STORE EACH VALUE AS REQUIRED BY DECIMATION IN TIME */
reg[0:vlen_log2] count_val;
initial count_val = 0;

wire[0:datlen-1] store_x;
wire filled;

dit_store cont0(

	rdy,
	(ampl_t >> 1),//TODO remove the shift, it breaks large numbers!!!
	clk,//update the output every time we input
	count_val,//the index of the value we want (sequential)
	store_x,//output of the store
	filled
	
);

/* PERFORM radix-2 DECIMATION-IN-TIME FFT */
reg[0:datlen*2-1] in_x;//24 bits!
reg in_nd;

wire[0:datlen*2-1] out_x;
wire out_nd;

reg filled_prev;
reg out_nd_prev;

initial filled_prev = 0;

initial in_x = 0;
initial in_nd = 0;

wire overflow;//TODO handle

dit fft0(

	rdy,
	1,//reset_n (active low)
	(in_x << datlen),
	in_nd,
	out_x,
	out_nd,//new data in fft_out
	overflow//handle, fft can't keep up
	
);

always @(posedge rdy) begin
	if (!filled_prev & filled) begin
		filled_prev <= 1;
		//count_val = 0;
		in_nd = 1;
	end
	
	if (out_nd & !out_nd_prev) begin//posedge out_nd
		//count_val = 0;//restart counter
	end
	
	if (!out_nd & out_nd_prev) begin//negegde out_nd
		in_nd = 1;
		//count_val = 0;//restart counter
	end
	
	out_nd_prev <= out_nd;
	
	if (count_val < vlen) begin
		in_x = store_x;
			
		if (in_nd) begin
			//$display("count: %2F - input: %3F", count_val, in_x);
		
			count_val = count_val + 1;
		end
	end else begin
		count_val = 0;
		in_nd = 0;
	end
	
end

//TODO filter, take maximums, send data to uController

//temp (to show incomplete diagram in tech map view)
assign max730 = out_x >> datlen;
assign max850 = out_x >> datlen;
//end temp

endmodule