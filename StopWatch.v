`timescale 1ns / 1ps

module StopWatch(
	input [1:0] mstate,
	input clk,
	input mode0,
	input mode1,
	input set,
	input clear,
	input aoff,
	input reset,
	output reg [5:0] min, sec,
	output reg [6:0] csec,
	output ST
    );
	
integer cnt=0;
parameter S0=1'b0, S1=1'b1;
reg state=1'b0, next;
assign ST=state;

always @(posedge clk or posedge reset )
begin
	if(reset)
	begin
		state<=S0;
		min<=0;
		sec<=0;
		csec<=0;
	end
	else if(clear)
	begin
		if(mstate==2'b10)
		begin
			state<=S0;
			min<=0;
			sec<=0;
			csec<=0;
		end
	end
	else if(state==S1)
	begin
		cnt<=cnt+1;
		if(cnt==12)
		begin
			if(csec==7'd99)
			begin
				csec<=0;
				if(sec==6'd59)
				begin
					sec<=0;
					if(min==6'd59);
					else min<=min+1;
				end
				else sec<=sec+1;
			end
			else csec<=csec+1;
		end
		if(cnt==25) cnt<=0;
		state<=next;
	end
	else state<=next;
end

always @(set or clear or state)
begin
	if(mstate==2'b10)
	begin
		case(state)
		S0:
			if(set) next<=S1;
			else if(clear) next<=S0;
			else next<=S0;
		S1:
			if(set) next<=S0;
			else if(clear) next<=S0;
			else next<=S1;
		endcase
	end
	else next<=state;
end

endmodule