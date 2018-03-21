// Copyright (c) 2012 Ben Reynwar
// Released under MIT License (see LICENSE.txt)

module twiddlefactors (
    input  wire                            clk,
    input  wire [2:0]          addr,
    input  wire                            addr_nd,
    output reg signed [23:0] tf_out
  );

  always @ (posedge clk)
    begin
      if (addr_nd)
        begin
          case (addr)
			
            3'd0: tf_out <= { 12'sd1024,  -12'sd0 };
			
            3'd1: tf_out <= { 12'sd946,  -12'sd392 };
			
            3'd2: tf_out <= { 12'sd724,  -12'sd724 };
			
            3'd3: tf_out <= { 12'sd392,  -12'sd946 };
			
            3'd4: tf_out <= { 12'sd0,  -12'sd1024 };
			
            3'd5: tf_out <= { -12'sd392,  -12'sd946 };
			
            3'd6: tf_out <= { -12'sd724,  -12'sd724 };
			
            3'd7: tf_out <= { -12'sd946,  -12'sd392 };
			
            default:
              begin
                tf_out <= 24'd0;
              end
         endcase
      end
  end
endmodule