module dsp_main_tb;

reg clk;
reg in;

wire[0:11] max730;
wire[0:11] max850;

dsp proc0(
	clk,
	in,
	max730,
	max850
);

reg[0:11] cur_val = 0;
reg[0:6] count_val = 0;
reg[0:4] count_bit = 0;

initial begin
	clk <= 0;
	//in <= 0;
end

always @(posedge clk) begin
	case(count_val)
	
		0: cur_val = 50;
		1: cur_val = 115;
		2: cur_val = 43;
		3: cur_val = 20;
		4: cur_val = 2;
		5: cur_val = 13;
		6: cur_val = 115;
		7: cur_val = 20;
		8: cur_val = 200;
		9: cur_val = 46;
		10: cur_val = 80;
		11: cur_val = 92;
		12: cur_val = 73;
		13: cur_val = 62;
		14: cur_val = 900;
		15: cur_val = 1;
		default: begin cur_val = 0; end
	
	endcase
	
	in = cur_val[count_bit];//don't block here
	
	count_bit = count_bit + 1;
	
	if (count_bit == 12) begin
		count_bit = 0;
		
		count_val = count_val + 1;
		
		if (count_val == 32) begin
			count_val = 0;
		end
	end
end

always begin
	#10 clk <= !clk;
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