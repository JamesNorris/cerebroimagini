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

reg[0:`ADC_DATLEN-1] buffer;

reg[0:`ADC_DATLEN_LOG2] count = 0;

always @(posedge clk) begin
	if (count == `ADC_DATLEN) begin 
		count = 0;//reset counter (12->0)
	end
	
	//shift in new bit
	buffer = ((buffer << 1) | in);
	
	//increment count
	count = count + 1;
end

assign out = buffer;
assign rdy = (count == `ADC_DATLEN);
	
endmodule