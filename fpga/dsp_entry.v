module dsp 
#(

	//length of the input data read from the ADC
	parameter datlen = 12,
	
	//vector length N of the FFT (# bins)
	parameter vlen = 32,
	
	//log base 2 of vlen used for counting
	parameter vlen_log2 = 5,
	
	//the low cutoff frequency for modulation A's band-pass filter
	parameter freq_a_low = 100,
	
	//the high cutoff frequency for modulation A's band-pass filter
	parameter freq_a_high = 200,
	
	//the low cutoff frequency for modulation B's band-pass filter
	parameter freq_b_low = 500,
	
	//the high cutoff frequency for modulation B's band-pass filter
	parameter freq_b_high = 600
	
)(

	//clock
	input clk,
	
	//input bit from the ADC
	input in,
	
	//peak of modulation A
	output[0:datlen-1] freq_a,
	
	//peak of modulation B
	output[0:datlen-1] freq_b
	
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

/* DECIMATION IN TIME FFT */
reg[0:datlen*2-1] ampl_t_in_x = 0;
reg in_nd = 0;

wire[0:datlen*2-1] ampl_f;
wire out_nd;
wire overflow;

dit d0(

	rdy,
	1,
	ampl_t_in_x,
	in_nd,
	ampl_f,
	out_nd,
	overflow
	
);

/* DRIVER FOR FFT */
reg[0:vlen_log2-1] vcount = -1;

reg[0:datlen-1] zeros = 0;

always @(posedge rdy) begin
	ampl_t_in_x = {zeros, ampl_t};
	
	if (!out_nd && vcount <= vlen-1) begin
		in_nd = 1;
		
		vcount = vcount + 1;
	end else begin
		in_nd = 0;
		
		vcount = 0;
	end
end

assign freq_a = ampl_f;//TEMP

endmodule