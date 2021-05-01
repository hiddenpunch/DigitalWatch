`timescale 1ns / 1ps

module Clock(
	input [1:0] mstate,
	input clk,
	input mode0,
	input mode1,
	input set,
	input display,
	input dp,
	input aoff,
	input reset,
	output reg [5:0] hour, min, sec,
	output [2:0] ST
    );

integer cnt=0;
parameter S0 = 3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101, S6=3'b110, S7=3'b111;
reg [2:0] state=3'b000, next;
//reg dp=0;

assign ST=state;

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		state<=S0;
	end
	else state<=next;
end

always @(posedge clk)
begin
	if(state==S3||state==S4) sec<=0;
	if(state==S0 || reset==1)
	begin
		hour<=0;
		min<=0;
		sec<=0;
	end
	else if(display==1)//up
	begin
		case(state)
		S3:
			if(hour==6'd23) hour<=0;
			else hour<=hour+1;
		S4:
		begin
			hour<=hour+12;
			if(hour>6'd23) hour<=hour-24;
		end
		S5:
			if(min==6'd59) min<=0;
			else min<=min+1;
		S6:
			if(hour==6'd11) hour<=0;
			else if(hour==6'd23) hour<=12;
			else hour<=hour+1;
		S7:
			if(min==6'd59) min<=0;
			else min<=min+1;
		endcase
	end
	else if(aoff==1)//down
	begin
		case(state)
		S3:
			if(hour==6'd0) hour<=23;
			else hour<=hour-1;
		S4:
		begin
			if(hour>6'd11) hour<=hour-12;
			else hour<=hour+12;
		end
		S5:
			if(min==6'd0) min<=59;
			else min<=min-1;
		S6:
			if(hour==6'd00) hour<=11;
			else if(hour==6'd12) hour<=23;
			else hour<=hour-1;
		S7:
			if(min==6'd0) min<=59;
			else min<=min-1;
		endcase
	end
	else if(state==S1 || state==S2)
	begin
		cnt<=cnt+1;
		if(cnt==1250)
		begin
			if(sec==6'd59)
			begin
				sec<=0;
				if(min==6'd59)
				begin
					min<=0;
					if(hour==6'd23) hour<=0;
					else hour<=hour+1;
				end
				else min<=min+1;
			end
			else sec<=sec+1;
		end
		if(cnt==2500) cnt<=0;
	end
end

/*always @(posedge display)
begin
	if(mstate==2'b00 || mstate==2'b01)
	begin
		if(state==S1 ) dp=1;
		else if(state==S2 ) dp=0;
	end
end*/


always @(reset or state or set or dp)
begin
	if(mstate==2'b00)
	begin
		case(state)
		S0:
			next<=S1;
		S1:
			if(dp==1) next<=S2;
			//else if(dp==0) next=S1;
			else if(set) next<=S3;
			else next<=S1;
		S2:
			if(dp==0) next<=S1;
		//	else if(dp==1) next=S2;
			else if(set) next<=S4;
			else next<=S2;	
		S3:
			if(set==1) next<=S5;
			else next<=S3;
		S4:
			if(set==1) next<=S6;
			else next<=S4;
		S5:
			if(set==1) next<=S1;
			else next<=S5;
		S6:
			if(set==1) next<=S7;
			else next<=S6;
		S7:
			if(set==1) next<=S1;
			else next<=S7;
		endcase
	end
	else if(mstate==2'b01)
	begin
		case(state)
		S1:
			if(dp==1) next<=S2;
			else if(dp==0) next<=S1;
		S2:
			if(dp==0) next<=S1;
			else if(dp==1) next<=S2;
		default: next<=state;
		endcase
	end
	else next<=state;
end
endmodule