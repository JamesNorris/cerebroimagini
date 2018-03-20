module collect(//collect bits from the ADC into a 4-bit register
	input clk,
	input in,//input bit
	output[0:3] out,
	output rdy
);

reg [0:3] buffer;
reg [0:2] count;

always @(posedge clk) begin
	if (count == 4) count <= 0;//reset counter
	
	//shift in new bit
	buffer[3] <= buffer[2];
	buffer[2] <= buffer[1];
	buffer[1] <= buffer[0];
	buffer[0] <= in;
	
	//increment count
	count <= count + 1;
end

assign out = buffer;
assign rdy = count == 4;
	
endmodule