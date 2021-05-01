`timescale 1ns / 1ps

module StateMac(
	input clk,
	input mode0,
	input mode1,
	input set,
	input display,
	input aoff,
	input reset,
	output dout,
	input [2:0] cstate,
	input [2:0] astate,
	output [1:0] ST
    );


parameter S0=2'b00, S1=2'b01, S2=2'b10;
reg [1:0] state=2'b00, next;
assign ST = state;
reg dp=0;
assign dout=dp;

always @(posedge display or posedge reset)
begin
	if(reset) dp<=0;
	else
	begin
		if((state==2'b00 && (cstate==3'b000||cstate==3'b001 || 3'b010))|| (state==2'b01 &&(astate==3'b000||astate==3'b001 || astate==3'b010)))
		begin
			dp<=1-dp;
		end
	end
end

always @(posedge clk or posedge reset)
begin
	if(reset) state<=S0;
	else state<=next;
end

always @(mode0 or mode1 or state)
begin
	case(state)
	S0:
		/*if(cstate==3'b000||cstate==3'b001 || cstate==3'b010)
		begin*/
			if(mode0) next<=S1;
			else if(mode1) next<=S2;
			else next<=S0;
		//end
	S1:
		/*if(astate==3'b000||astate==3'b001|| astate==3'b010)
		begin*/
			if(mode0) next<=S2;
			else if(mode1) next<=S0;
			else next<=S1;
		//end
	S2:
		if(mode0) next<=S0;
		else if(mode1) next<=S1;
		else next<=S2;
	endcase
end



//assign ST=2'b00;

endmodule