`timescale 1ns / 1ps

module Translate(
	input on,
	input [2:0] num,
	input light,
	input [3:0] d1,
	input flash,
	input clk,
	output reg [6:0] J1
    );

integer temp=0;
reg clkout=0;

always @(posedge clk)
begin
	temp<=temp+1;
	if(temp==1000)
	begin
		clkout<=1;
	end
	if(temp==2000)
	begin
	temp<=0;
	clkout<=0;
	end
end

always @(*)
begin
	if(on==0)
	begin
		case (num)
		3'b000: J1<=7'b0001110;
		3'b001: J1<=7'b1111110;
		3'b010: J1<=7'b1001110;
		3'b011: J1<=7'b0101111;
		3'b100: J1<=7'b1001111;
		3'b101: J1<=7'b0111101;
		default: J1<=7'b0000000;
		endcase
	end
	else
	begin
		case (d1)
			4'd0: J1 <= 7'b1111110;
			4'd1: J1 <= 7'b0110000;
			4'd2: J1 <= 7'b1101101;
			4'd3: J1 <= 7'b1111001;
			4'd4: J1 <= 7'b0110011;
			4'd5: J1 <= 7'b1011011;
			4'd6: J1 <= 7'b1011111;
			4'd7: J1 <= 7'b1110000;
			4'd8: J1 <= 7'b1111111;
			4'd9: J1 <= 7'b1111011;
			4'd10: J1 <= 7'b1110111;
			4'd11: J1 <= 7'b1100111;
			4'd12: J1 <= 7'b0000001;
			//4'd16: J1 = 7'b0000001;
			default: J1 <= 7'b0000000;	
		endcase
		if((clkout==1 && flash==1) || (temp%2==0 && light==1))
		begin
			J1<=7'b0000000;
		end
	end
end

endmodule