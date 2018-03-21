module read(//collect bits from the ADC into a 12-bit register
	input clk,
	input in,//input bit
	output[0:11] out,
	output rdy
);

reg[0:11] buffer;

reg[0:3] count = 4'b0000;

always @(posedge clk) begin
	if (count == 4'b1100) begin 
		count <= 4'b0000;//reset counter (12->0)
	end
	
	//shift in new bit
	buffer <= (buffer << 1) | in;
	
	//increment count
	count <= count + 4'b0001;
end

assign out = buffer;
assign rdy = (count == 4'b1100);
	
endmodule