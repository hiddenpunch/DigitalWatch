`timescale 1ns / 1ps

module Debouncer (
input clk,
 input data_in,
 output reg data_out);
 
 reg [3:0] counter = 4'b0;
 
 always @ (posedge clk)
 begin
	if (!data_in) counter <= 0;
	else
	begin
		if (counter < 15) // N = 15
		begin
			counter <= counter + 1;
		end
	end
	if (counter >= 15) data_out <= 1;
	else data_out <= 0;
end

endmodule