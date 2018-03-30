module sig_avg_tb;

reg clk = 0;


always begin
	#10 clk = !clk;
end

endmodule