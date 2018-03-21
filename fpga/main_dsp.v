module process(
	input clk,
	input in,
	output[0:11] max730,
	output[0:11] max850
);

wire[0:11] ampl;
wire rdy;

reg[0:6] count;//counts to 64 values

read r0(clk, in, ampl, rdy);

always @(posedge rdy) begin
	if (count == 7'b1000000) count <= 7'b0111111;//maintain count at 64
	
	count <= count + 7'b0000001;
end

wire[0:11] fft_out;

handle_ci_fft fft0(
clk,
rdy,
ampl,//<- here's our data
fft_out
);

//TODO filter, take maximums, send data to uController

//temp (to show incomplete diagram in tech map view)
assign max730 = fft_out;
assign max850 = fft_out;
//end temp

endmodule