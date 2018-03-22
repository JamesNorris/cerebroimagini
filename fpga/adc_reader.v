//IMPORTANT VARIABLES
`define ADC_DATLEN 12
`define ADC_DATLEN_LOG2 3
//`define FFT_VLEN 16
//`define FFT_VLEN_LOG2 4
//`define FFT_RVAL_BMASK 24'h000FFF
//

module read(//collect bits from the ADC into a 12-bit register
	input wire clk,
	input wire in,//input bit
	output wire[0:`ADC_DATLEN-1] out,
	output wire rdy
);

reg[0:`ADC_DATLEN-1] buffer;

reg[0:`ADC_DATLEN_LOG2] count = 0;

always @(posedge clk) begin
	if (count == `ADC_DATLEN) begin 
		count <= 0;//reset counter (12->0)
	end
	
	//shift in new bit
	buffer <= ((buffer << 1) | in);
	
	//increment count
	count <= count + 1;
end

assign out = buffer;
assign rdy = (count == `ADC_DATLEN);
	
endmodule