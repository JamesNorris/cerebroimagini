module array_tb;

reg clk = 0;

reg put = 0;
reg get = 0;

reg[0:2] p_index;
reg[0:2] g_index;

reg[0:11] p_val;
wire[0:11] g_val;

array #(

	12,
	64,
	3

)
a0 (
	put,
	p_index,
	p_val,
	
	get,
	g_index,
	g_val
);

always @(posedge clk) begin
	if (p_index < 63) begin
		p_index = p_index + 1;
	end else begin
		p_index = 0;
	end
	
	if (g_index < 63) begin
		g_index = g_index + 1;
	end else begin
		g_index = 0;
	end
	
	case(p_index % 4)
		0: p_val = 55;
		1: p_val = 30;
		2: p_val = 4095;
		3: p_val = 0;
		default: p_val = 111;
	endcase	
end

always begin
	#10 clk = !clk;
	
	#20 put = !put;
	#20 get = !get;
end

endmodule