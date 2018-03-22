module adcread_tb;

reg[0:11] in_pre;
reg[0:3] count;

reg clk;
reg in;

wire[0:11] out;
wire rdy;

read r0(
	.clk (clk),
	.in (in),
	.out (out),
	.rdy (rdy)
);

initial begin
	clk = 0;
	in = 0;
	//out = 0;
	//rdy = 0;
	
	in_pre = 12'b101011101111;
	count = 0;
end

always begin
	#5 clk = !clk;
	
	if (clk == 1) begin
		in = in_pre[count];
		count = count + 1;
	end
	
end

always @(posedge rdy) begin
	$monitor("total in = %12b, total out = %12b", in_pre, out);
end

endmodule