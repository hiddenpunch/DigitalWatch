`timescale 1ns / 1ps

module OutputLogic(
	input clk,
	input reset,
	input aoff,
	input [5:0] hour, min, sec, ahour, amin, asec ,shour, smin,
	input [6:0] ssec,
	input [1:0] mstate,
	input [2:0] cstate,
	input [2:0] astate,
	input sstate,
	output reg[3:0] d1, d2, d3, d4, d5, d6,
	output reg [2:0] flash
    );

reg ring=0;

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
	flash=3'b000;
	d1<=4'd0;
	d2<=4'd0;
	d3<=4'd0;
	d4<=4'd0;
	d5<=4'd0;
	d6<=4'd0;
	end
	else
	begin
	flash=3'b000;
	if(hour==ahour && min==amin && sec==6'd0 && (astate==3'b001 || astate==3'b010) && (cstate==3'b000||cstate==3'b001 || cstate==3'b010)) ring=1;
	if(mstate==2'b00)
	begin
		if(cstate==3'b011 || cstate==3'b100) flash=3'b100;
		else if(cstate==3'b101 || cstate==3'b110) flash=3'b010;
		else if(cstate==3'b111) flash=3'b001;
		else if(cstate==3'b001 || cstate==3'b010)
		begin
			if(aoff) ring=0;
			if(ring) flash=3'b111;
			else flash=3'b000;
		end
		if(cstate==3'b001 || cstate==3'b011 || cstate==3'b101)
		begin
			if(hour>6'd19)
			begin
				d1<=4'd2;
				d2<=hour-20;
			end
			else if(hour>6'd9)
			begin
				d1<=4'd1;
				d2<=hour-10;
			end
			else
			begin
				d1<=4'd0;
				d2<=hour;
			end
			if(min>6'd49)
			begin
				d3<=4'd5;
				d4<=min-50;
			end
			else if(min>6'd39)
			begin
				d3<=4'd4;
				d4<=min-40;
			end
			else if(min>6'd29)
			begin
				d3<=4'd3;
				d4<=min-30;
			end
			else if(min>6'd19)
			begin
				d3<=4'd2;
				d4<=min-20;
			end
			else if(min>6'd9)
			begin
				d3<=4'd1;
				d4<=min-10;
			end
			else
			begin
				d3<=4'd0;
				d4<=min;
			end
			if(sec>6'd49)
			begin
				d5<=4'd5;
				d6<=sec-50;
			end
			else if(sec>6'd39)
			begin
				d5<=4'd4;
				d6<=sec-40;
			end
			else if(sec>6'd29)
			begin
				d5<=4'd3;
				d6<=sec-30;
			end
			else if(sec>6'd19)
			begin
				d5<=4'd2;
				d6<=sec-20;
			end
			else if(sec>6'd9)
			begin
				d5<=4'd1;
				d6<=sec-10;
			end
			else
			begin
				d5<=4'd0;
				d6<=sec;
			end
		end
		else if(cstate==3'b010 || cstate==3'b100 || cstate==3'b110 || cstate==3'b111)
		begin
			d2<=4'd15;
			if(hour>6'd11)//PM
			begin
				d1<=4'd11;
				if(hour==6'd12)
				begin
					d3<=4'd1;
					d4<=4'd2;
				end
				else if(hour>6'd21)
				begin
					d3<=4'd1;
					d4<=hour-22;
				end
				else
				begin
					d3<=4'd0;
					d4<=hour-12;
				end
			end
			else //AM
			begin
				d1<=4'd10;
				if(hour==6'd0)
				begin
					d3<=4'd1;
					d4<=4'd2;
				end
				else if(hour>6'd9)
				begin
					d3<=4'd1;
					d4<=hour-10;
				end
				else
				begin
					d3<=4'd0;
					d4<=hour;
				end
			end
			if(min>6'd49)
			begin
				d5<=4'd5;
				d6<=min-50;
			end
			else if(min>6'd39)
			begin
				d5<=4'd4;
				d6<=min-40;
			end
			else if(min>6'd29)
			begin
				d5<=4'd3;
				d6<=min-30;
			end
			else if(min>6'd19)
			begin
				d5<=4'd2;
				d6<=min-20;
			end
			else if(min>6'd9)
			begin
				d5<=4'd1;
				d6<=min-10;
			end
			else
			begin
				d5<=4'd0;
				d6<=min;
			end
		end
	end
	
	else if(mstate==2'b01)
	begin
		if(astate==3'b011 || astate==3'b100) flash=3'b100;
		else if(astate==3'b101 || astate==3'b110) flash=3'b010;
		else if(astate==3'b111) flash=3'b001;
		if(astate==3'b001 || astate==3'b011 || astate==3'b101)
		begin
			if(ahour>6'd19)
			begin
				d1<=4'd2;
				d2<=ahour-20;
			end
			else if(ahour>6'd9)
			begin
				d1<=4'd1;
				d2<=ahour-10;
			end
			else
			begin
				d1<=4'd0;
				d2<=ahour;
			end
			if(amin>6'd49)
			begin
				d3<=4'd5;
				d4<=amin-50;
			end
			else if(amin>6'd39)
			begin
				d3<=4'd4;
				d4<=amin-40;
			end
			else if(amin>6'd29)
			begin
				d3<=4'd3;
				d4<=amin-30;
			end
			else if(amin>6'd19)
			begin
				d3<=4'd2;
				d4<=amin-20;
			end
			else if(amin>6'd9)
			begin
				d3<=4'd1;
				d4<=amin-10;
			end
			else
			begin
				d3<=4'd0;
				d4<=amin;
			end
			if(asec>6'd49)
			begin
				d5<=4'd5;
				d6<=asec-50;
			end
			else if(asec>6'd39)
			begin
				d5<=4'd4;
				d6<=asec-40;
			end
			else if(asec>6'd29)
			begin
				d5<=4'd3;
				d6<=asec-30;
			end
			else if(asec>6'd19)
			begin
				d5<=4'd2;
				d6<=asec-20;
			end
			else if(asec>6'd9)
			begin
				d5<=4'd1;
				d6<=asec-10;
			end
			else
			begin
				d5<=4'd0;
				d6<=asec;
			end
		end
		else if(astate==3'b010 || astate==3'b100 || astate==3'b110 || astate==3'b111)
		begin
			d2<=4'd15;
			if(ahour>6'd11)
			begin
				d1<=4'd11;
				if(ahour==6'd12)
				begin
					d3<=4'd1;
					d4<=4'd2;
				end
				else if(ahour>6'd21)
				begin
					d3<=4'd1;
					d4<=ahour-22;
				end
				else
				begin
					d3<=4'd0;
					d4<=ahour-12;
				end
			end
			else 
			begin
				d1<=4'd10;
				if(ahour==6'd0)
				begin
					d3<=4'd1;
					d4<=4'd2;
				end
				else if(ahour>6'd9)
				begin
					d3<=4'd1;
					d4<=ahour-10;
				end
				else
				begin
					d3<=4'd0;
					d4<=ahour;
				end
			end
			if(amin>6'd49)
			begin
				d5<=4'd5;
				d6<=amin-50;
			end
			else if(amin>6'd39)
			begin
				d5<=4'd4;
				d6<=amin-40;
			end
			else if(amin>6'd29)
			begin
				d5<=4'd3;
				d6<=amin-30;
			end
			else if(amin>6'd19)
			begin
				d5<=4'd2;
				d6<=amin-20;
			end
			else if(amin>6'd9)
			begin
				d5<=4'd1;
				d6<=amin-10;
			end
			else
			begin
				d5<=4'd0;
				d6<=amin;
			end
		end
		else
		begin
			d1<=4'd12;
			d2<=4'd12;
			d3<=4'd12;
			d4<=4'd12;
			d5<=4'd12;
			d6<=4'd12;
		end
	end

	else if(mstate==2'b10)
	begin
		if(shour>6'd49)
		begin
			d1<=4'd5;
			d2<=shour-50;
		end
		else if(shour>6'd39)
		begin
			d1<=4'd4;
			d2<=shour-40;
		end
		else if(shour>6'd29)
		begin
			d1<=4'd3;
			d2<=shour-30;
		end
		else if(shour>6'd19)
		begin
			d1<=4'd2;
			d2<=shour-20;
		end
		else if(shour>6'd9)
		begin
			d1<=4'd1;
			d2<=shour-10;
		end
		else
		begin
			d1<=4'd15;
			d2<=shour;
		end
		if(smin>6'd49)
		begin
			d3<=4'd5;
			d4<=smin-50;
		end
		else if(smin>6'd39)
		begin
			d3<=4'd4;
			d4<=smin-40;
		end
		else if(smin>6'd29)
		begin
			d3<=4'd3;
			d4<=smin-30;
		end
		else if(smin>6'd19)
		begin
			d3<=4'd2;
			d4<=smin-20;
		end
		else if(smin>6'd9)
		begin
			d3<=4'd1;
			d4<=smin-10;
		end
		else
		begin
			d3<=4'd15;
			d4<=smin;
		end
		if(ssec>7'd89)
		begin
			d5<=4'd9;
			d6<=ssec-90;
		end
		else if(ssec>7'd79)
		begin
			d5<=4'd8;
			d6<=ssec-80;
		end
		else if(ssec>7'd69)
		begin
			d5<=4'd7;
			d6<=ssec-70;
		end
		else if(ssec>7'd59)
		begin
			d5<=4'd6;
			d6<=ssec-60;
		end
		else if(ssec>7'd49)
		begin
			d5<=4'd5;
			d6<=ssec-50;
		end
		else if(ssec>7'd39)
		begin
			d5<=4'd4;
			d6<=ssec-40;
		end
		else if(ssec>7'd29)
		begin
			d5<=4'd5;
			d6<=ssec-30;
		end
		else if(ssec>7'd19)
		begin
			d5<=4'd2;
			d6<=ssec-20;
		end
		else if(ssec>7'd9)
		begin
			d5<=4'd1;
			d6<=ssec-10;
		end
		else
		begin
			d5<=4'd0;
			d6<=ssec;
		end
	end
	end
end

endmodule