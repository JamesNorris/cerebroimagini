module process(
	input clk,
	input in,
	output[0:3] max730,
	output[0:3] max850
);

reg[0:7] word;

wire[0:3] ampl;
wire rdy;

collect c0(clk, in, ampl, rdy);

always @(posedge rdy) begin
	word = 8'b0;//clear word
	
	word[3] <= ampl[3];//assign 4 LSBs of the word to our amplitude
	word[2] <= ampl[2];
	word[1] <= ampl[1];
	word[0] <= ampl[0];
	
	//TODO fft, filter, take maximums, send data to uController
end

//temp (to show incomplete diagram in tech map view)
assign max730 = ampl;
assign max850 = max730;
//end temp

endmodule