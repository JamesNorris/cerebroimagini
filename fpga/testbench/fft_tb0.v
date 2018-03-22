module fft_tb;

reg clk;
reg nd;
reg[0:11] data;

wire[0:11] real_out;
wire out_nd;
wire overflow;

handle_ci_fft fft0(
	.clk (clk),
	.nd (nd),
	.data (data),
	.real_out (real_out),
	.out_nd (out_nd),
	.overflow (overflow)
);

initial begin
	clk = 0;
	nd = 0;
	data = 0;
end

//TODO

endmodule