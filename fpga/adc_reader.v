//IMPORTANT VARIABLES
`define ADC_DATLEN 12
`define ADC_DATLEN_LOG2 3
//

module read(//collect bits from the ADC into a 12-bit register
	input clk,
	input in,//input bit
	output[0:`ADC_DATLEN-1] out,
	output rdy
);

reg init = 1;//initial 0 bit

reg rdy_r = 0;

reg[0:`ADC_DATLEN-1] buffer;

reg[0:`ADC_DATLEN_LOG2] count = 0;

always @(negedge clk) begin
	if (count == `ADC_DATLEN) begin
		rdy_r = 1;
		count = 0;//reset counter (12->0)
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