module read
#(

	//we may need to skip the initial bit
	parameter skipbit = 1,
	
	//the data size coming from the ADC
	parameter datlen = 12,
	
	//self-explanitory, we need this for counting
	parameter datlen_log2 = 3
	
)(

	input clk,
	
	//the input bit
	input in,
	
	//output after datlen bits, may be an x value beforehand
	output[0:datlen-1] out,
	
	//set high only when we hit datlen bits, then back low
	output rdy
	
);

reg init = skipbit;

reg rdy_r = 0;

reg[0:datlen-1] buffer;

reg[0:datlen_log2] count = 0;

always @(negedge clk) begin
	if (count == datlen) begin
		rdy_r = 1;
		count = 0;//reset counter
	end else begin
		rdy_r = 0;
	end
	
	//shift in new bit
	buffer = ((buffer << 1) | in);
	
	//increment count
	count = count + 1;
	
	if (init) begin
		count = 0;//skip initial 0 bit
		init = 0;
	end
end

assign out = buffer;
assign rdy = rdy_r;
	
endmodule