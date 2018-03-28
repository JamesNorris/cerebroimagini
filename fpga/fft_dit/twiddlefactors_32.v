// Copyright (c) 2012 Ben Reynwar
// Released under MIT License (see LICENSE.txt)

module twiddlefactors (
    input  wire                            clk,
    input  wire [3:0]          addr,
    input  wire                            addr_nd,
    output reg signed [23:0] tf_out
  );

  always @ (posedge clk)
    begin
      if (addr_nd)
        begin
          case (addr)
			
            4'd0: tf_out <= { 12'sd1024,  -12'sd0 };
			
            4'd1: tf_out <= { 12'sd1004,  -12'sd200 };
			
            4'd2: tf_out <= { 12'sd946,  -12'sd392 };
			
            4'd3: tf_out <= { 12'sd851,  -12'sd569 };
			
            4'd4: tf_out <= { 12'sd724,  -12'sd724 };
			
            4'd5: tf_out <= { 12'sd569,  -12'sd851 };
			
            4'd6: tf_out <= { 12'sd392,  -12'sd946 };
			
            4'd7: tf_out <= { 12'sd200,  -12'sd1004 };
			
            4'd8: tf_out <= { 12'sd0,  -12'sd1024 };
			
            4'd9: tf_out <= { -12'sd200,  -12'sd1004 };
			
            4'd10: tf_out <= { -12'sd392,  -12'sd946 };
			
            4'd11: tf_out <= { -12'sd569,  -12'sd851 };
			
            4'd12: tf_out <= { -12'sd724,  -12'sd724 };
			
            4'd13: tf_out <= { -12'sd851,  -12'sd569 };
			
            4'd14: tf_out <= { -12'sd946,  -12'sd392 };
			
            4'd15: tf_out <= { -12'sd1004,  -12'sd200 };
			
            default:
              begin
                tf_out <= 24'd0;
              end
         endcase
      end
  end
endmodule