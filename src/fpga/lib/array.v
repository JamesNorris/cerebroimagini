module array
#(
	
	//the size of each value in bits
	parameter datlen = 12,
	
	//the size of the array
	parameter size = 64,
	
	//log base 2 of size used for indexing
	parameter size_log2 = 3
)(

	input put,
	input[0:size_log2-1] put_index,
	input[0:datlen-1] put_val,
	
	input get,
	input[0:size_log2-1] get_index,
	output[0:datlen-1] get_val
	
);

reg[0:datlen-1] get_val_r = 0;

reg[0:datlen*size-1] container = 0;
reg[0:datlen*size-1] mask = 0;

always @(posedge put) begin
	mask = 0;
	
	//place the current data in the mask
	mask = mask | container;
	
	//shift left to clear MSB's until MSB of data currently in this position
	mask = mask << ((size - 1 - put_index) * datlen);
	
	//shift right to clear LSB's until LSB of data currently in this position
	mask = mask >> (size - 1) * datlen;
	
	//XOR to get 0 at this position in the container
	container = container ^ mask;
	
	mask = 0;
	
	//place the value at this location in the container
	mask = (mask | put_val) << (put_index * datlen);
	container = container | mask;
end

always @(posedge get) begin

	get_val_r = container >> (get_index * datlen);
	
end

assign get_val = get_val_r;

endmodule