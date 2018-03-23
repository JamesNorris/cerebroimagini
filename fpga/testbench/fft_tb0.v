module fft_tb;

reg clk;
reg[0:23] in_x;
reg in_nd;

wire[0:23] out_x;
wire out_nd;
wire overflow;

dit fft0(
	clk,
	1,/*reset_n*/
	in_x,
	in_nd,
	out_x,
	out_nd,//ready to read
	overflow//if the fft can't keep up with the new data
);

reg[0:5] count;//counts up to 16

initial begin
	clk = 0;
	in_nd = 1;
	in_x = 0;
	count = 0;//skip first 0, we already provided one
end

always @(negedge clk) begin
	if (out_nd) begin
		$display("bin = %2h, out = %6h", count, out_x);
	end
	
	if (count < 16) begin
		count = count + 1;
	end else begin
		in_nd = 0;
	end
	
	case(count)
		0: in_x = 0;
		1: in_x = 7;
		2: in_x = 70;
		3: in_x = 1;
		4: in_x = 100;
		5: in_x = 32;
		6: in_x = 70;
		7: in_x = 43;
		8: in_x = 0;
		9: in_x = 4;
		10: in_x = -70;
		11: in_x = -92;
		12: in_x = 87;
		13: in_x = -92;
		14: in_x = 64;
		15: in_x = -38;
		default:
			begin
				in_x = 0;
			end
	endcase
end

always @(posedge out_nd) begin
	count = 0;
end

always @(negedge out_nd) begin
	in_nd = 1;
	count = 0;
end

always begin
	#10 clk = !clk;
	
	//$monitor("out = %6h", out_x);
end

endmodule