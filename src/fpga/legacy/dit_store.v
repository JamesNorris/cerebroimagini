//IMPORTANT VARIABLES
`define ADC_DATLEN 12
`define ADC_DATLEN_LOG2 3
`define FFT_VLEN 16
`define FFT_VLEN_LOG2 4
//

module dit_store(
	input rdy,
	input[0:`ADC_DATLEN-1] in,
	input get,
	input[0:`FFT_VLEN_LOG2] choose,
	output[0:`ADC_DATLEN-1] out_w,
	output full_w
);

reg[0:`ADC_DATLEN-1] out;
reg full;
initial full = 0;

reg[0:`FFT_VLEN_LOG2] count_in_x;
initial count_in_x = 0;

reg[0:`ADC_DATLEN-1] x_0;
reg[0:`ADC_DATLEN-1] x_1;
reg[0:`ADC_DATLEN-1] x_2;
reg[0:`ADC_DATLEN-1] x_3;
reg[0:`ADC_DATLEN-1] x_4;
reg[0:`ADC_DATLEN-1] x_5;
reg[0:`ADC_DATLEN-1] x_6;
reg[0:`ADC_DATLEN-1] x_7;
reg[0:`ADC_DATLEN-1] x_8;
reg[0:`ADC_DATLEN-1] x_9;
reg[0:`ADC_DATLEN-1] x_10;
reg[0:`ADC_DATLEN-1] x_11;
reg[0:`ADC_DATLEN-1] x_12;
reg[0:`ADC_DATLEN-1] x_13;
reg[0:`ADC_DATLEN-1] x_14;
reg[0:`ADC_DATLEN-1] x_15;

always @(posedge rdy) begin
	if (count_in_x < `FFT_VLEN) begin
		
		case(count_in_x)
			
			0: x_0 = in;
			1: x_8 = in;
			2: x_4 = in;
			3: x_12 = in;
			4: x_2 = in;
			5: x_10 = in;
			6: x_6 = in;
			7: x_14 = in;
			8: x_1 = in;
			9: x_9 = in;
			10: x_5 = in;
			11: x_13 = in;
			12: x_3 = in;
			13: x_11 = in;
			14: x_7 = in;
			15: begin x_15 = in; full = 1; end
			
			default: x_0 = in;

		endcase
		
		count_in_x = count_in_x + 1;
		
	end else begin
		
		/*
		Registers will be replaced over time.
		We can only take the values we are prepared for. As a result,
		we are going to miss some data while we wait for results from
		the FFT.
		*/
		
		count_in_x = 0;
	end
end

always @(posedge get) begin
	case(choose)
	
			0: out = x_0;
			1: out = x_1;
			2: out = x_2;
			3: out = x_3;
			4: out = x_4;
			5: out = x_5;
			6: out = x_6;
			7: out = x_7;
			8: out = x_8;
			9: out = x_9;
			10: out = x_10;
			11: out = x_11;
			12: out = x_12;
			13: out = x_13;
			14: out = x_14;
			15: out = x_15;
			
			default: out = x_0;
			
	endcase
end

assign out_w = out;
assign full_w = full;

endmodule