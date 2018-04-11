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
	(in_x << 12),//real is 12 MSB's
	in_nd,
	out_x,//bring real back to 12 LSB's
	out_nd,//ready to read
	overflow//if the fft can't keep up with the new data
);

reg[0:5] count;//counts up

initial begin
	clk = 0;
	in_nd = 0;
	in_x = 0;
	count = 0;
end

always @(posedge clk) begin
	if (out_nd) begin
		$display("bin = %2h, out = %6h", count, out_x);
	end
	
	case(count)
		0: in_x = 50;
		1: in_x = 115;
		2: in_x = 43;
		3: in_x = 20;
		4: in_x = 2;
		5: in_x = 13;
		6: in_x = 115;
		7: in_x = 20;
		8: in_x = 200;
		9: in_x = 46;
		10: in_x = 80;
		11: in_x = 92;
		12: in_x = 73;
		13: in_x = 62;
		14: in_x = 900;
		15: in_x = 1;
		default:
			begin
				in_x = 0;
			end
	endcase
	
	if (count < 15) begin//16-1
		count = count + 1;
	end else begin
		in_nd = 0;
	end
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

/* VALUES IN ORDER
50
115
43
20
2
13
115
20
200
46
80
92
73
62
900
1
*/

/* VALUES IN EVEN/ODD DIT ORDER
50
200
2
73
43
80
115
900
115
46
13
62
20
92
20
1
*/