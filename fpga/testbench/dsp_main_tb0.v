module dsp_main_tb;

reg clk;
reg in;

wire[0:11] max730;
wire[0:11] max850;

process proc0(
	clk,
	in,
	max730,
	max850
);

initial begin
	clk = 0;
	in = 0;
end

always @(negedge clk) begin
	in = !in;
end

always begin
	#10 clk = !clk;
end

endmodule