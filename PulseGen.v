`timescale 1ns / 1ps

module PulseGen(
	input clk,
	input isign,
	input reset,
	output osign
    );
parameter s0=2'd0, s11=2'd1, s01=2'd2;

reg [1:0] state, next;

assign osign=(state==s01)?1'b1:1'b0;

always @(*)
begin
	case (state)
		s0:
			next=(isign==1'b1)?s01:s0;
		s11:
			next=(isign==1'b1)?s11:s0;
		s01:
			next=(isign==1'b1)?s11:s0;
		default:
			next=s0;
	endcase
end

always @(posedge clk)
begin
	state<=(reset==1'b1)?s0:next;
end

endmodule