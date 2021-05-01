`timescale 1ns / 1ps

module ClockModulator(
	input clk,
	output reg clkout
    );

integer temp=0;
always @(posedge clk)
begin
	temp<=temp+1;
	if(temp==10000) clkout<=1;
	if(temp==20000)
	begin
		clkout<=0;
		temp<=0;
	end
end

endmodule