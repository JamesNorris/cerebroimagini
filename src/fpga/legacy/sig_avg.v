module sig_avg
#(

	//the length of each data value
	parameter datlen = 12,
	
	//the number of data values to average
	parameter avg_n = 64,
	
	//log base 2 of avg_n used for indexing
	parameter avg_n_log2 = 6
	
)(

	input clk,
	
	input[0:datlen-1] val,
	
	output[0:datlen-1] avg

);

reg[0:avg_n*2-1] cur_avg = 0;

reg[0:avg_n*2-1] sum = 0;

reg[0:avg_n_log2] count = 0;

always @(posedge clk) begin
	if (count < avg_n) begin
		count = count + 1;
		
		sum = sum + val;
	end else begin
		cur_avg = sum / avg_n;
		
		sum = 0;
	end
end

assign avg = cur_avg;

endmodule