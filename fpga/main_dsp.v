module process(
	input clk,
	input in,
	output[0:11] max730,
	output[0:11] max850
);

wire[0:11] ampl;
wire rdy;

read r0(clk, in, ampl, rdy);

always @(posedge rdy) begin
	//TODO fft, filter, take maximums, send data to uController
end

//temp (to show incomplete diagram in tech map view)
assign max730 = ampl;
assign max850 = ampl;
//end temp

endmodule