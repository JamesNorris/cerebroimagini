//IMPORTANT VARIABLES
`define ADC_DATLEN 12
`define FFT_VLEN 16
`define FFT_VLEN_LOG2 4
//

module process
#(
	/*
	These are the discrete times mapped to indices required by a *DIT* FFT of size FFT_VLEN
	*/
	parameter [0:`FFT_VLEN*4-1] shifts = {4'd0, 4'd8, 4'd6, 4'd10, 4'd4, 4'd12, 4'd2, 4'd14, 
		4'd1, 4'd13, 4'd3, 4'd11, 4'd5, 4'd9, 4'd7, 4'd15}//MUST BE CHANGED MANUALLY
)
(
	input clk,
	input in,//input bit
	output[0:`ADC_DATLEN-1] max730,
	output[0:`ADC_DATLEN-1] max850
);

/* COLLECT BITS FROM ADC */
wire[0:`ADC_DATLEN-1] ampl_t;
wire rdy;

read r0(clk, in, ampl_t, rdy);

/* STORE EACH VALUE INTO ARRAY */
reg[0:`FFT_VLEN*`ADC_DATLEN-1] array;
reg[0:`FFT_VLEN_LOG2] count_in_x;

initial count_in_x = 0;

always @(posedge rdy) begin
	if (count_in_x < `FFT_VLEN) begin
	
		array = array | (ampl_t << (shifts[count_in_x] * `ADC_DATLEN)); 
		count_in_x = count_in_x + 1;
		
	end else begin
		//array = 0;//clear array
		
		/*
		Locations within the array will be replaced over time.
		We can only take the values we are prepared for. As a result,
		we are going to miss some data while we wait for results from
		the FFT.
		*/
		
		count_in_x = 0;
	end
end

/* PERFORM radix-2 DECIMATION-IN-TIME FFT */
reg[0:`FFT_VLEN_LOG2] count_val;
reg[0:`FFT_VLEN_LOG2] count_read;

reg[0:(`ADC_DATLEN*2)-1] in_x;

reg in_nd;
initial in_nd = 1;

wire[0:`ADC_DATLEN-1] empty;
assign empty = /*ADC_DATLEN*/12'b000000000000;//SET MANUALLY

//get our next value
reg[0:`FFT_VLEN*`ADC_DATLEN-1] array_copy;

always @(negedge rdy) begin
	if ((count_val < `FFT_VLEN) & in_nd) begin
		array_copy = array >> (count_val*`ADC_DATLEN);
		in_x = {empty, array_copy[0:`ADC_DATLEN-1]};
		count_val = count_val + 1;
	end else begin
		count_val = 0;
		if (count_read < `FFT_VLEN) begin
			if (out_nd) begin
				count_read = count_read + 1;
			end
			in_nd = 0;
		end else begin
			in_nd = 1;
			count_read = 0;
		end
		//in_nd = 0;
	end
	//in_nd = 1;
end

wire[0:(`ADC_DATLEN*2)-1] out_x;
wire out_nd;
wire overflow;

//perform fft
dit fft0(
	clk,
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