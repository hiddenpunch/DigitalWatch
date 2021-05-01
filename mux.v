`timescale 1ns / 1ps

module mux(
	input on,
	input data,
	output reg data_out
    );

always @(*)
begin
	if(on==0) data_out=0;
	else data_out=data;
end

endmodule
