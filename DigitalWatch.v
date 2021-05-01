`timescale 1ns / 1ps

module DigitalWatch(
	input light,
	input on_sign,
	input num,
	input osc,
	input mode0,
	input mode1,
	input set,
	input display,
	input aoff,
	input reset,
	output [6:0] J1,
	output [6:0] J2,
	output [6:0] J3,
	output [6:0] J4,
	output [6:0] J5,
	output [6:0] J6,
	output [1:0] ST,
	output st
	);

wire on;
wire clk;
wire mode01, mode02, mode03, mode11, mode12, mode13, set1, set2, set3, display1, display2, display3, aoff1, aoff2, aoff3, reset1;
wire [1:0] mstate;
wire [2:0] cstate, astate;
wire sstate;
wire [2:0] flash;
wire [3:0] d1, d2, d3, d4, d5, d6;
wire [5:0] hour, min, sec, ahour, amin, asec, smin, ssec;
wire [6:0] scsec;
wire dp;

assign ST = mstate;
//assign st1=astate;
assign st=on;

ClockModulator cm(osc, clk);
Debouncer db1(clk, mode0, mode01);
Debouncer db2(clk, mode1, mode11);
Debouncer db3(clk, set, set1);
Debouncer db4(clk, display, display1);
Debouncer db5(clk, aoff, aoff1);

PulseGen p1(clk, mode01, reset, mode02);
PulseGen p2(clk, mode11, reset, mode12);
PulseGen p3(clk, set1, reset, set2);
PulseGen p4(clk, display1, reset, display2);
PulseGen p5(clk, aoff1, reset, aoff2);

PassWord pw(on_sign, num, on);
mux m1(on, mode02, mode03);
mux m2(on, mode12, mode13);
mux m3(on, set2, set3);
mux m4(on, display2, display3);
mux m5(on, aoff2, aoff3);
mux m6(on, reset, reset1);

StateMac sm(clk, mode03, mode13, set3, display3, aoff3, reset1, dp, cstate, astate, mstate);
Clock cl(mstate, clk, mode03, mode13, set3, display3, dp, aoff3, reset1, hour, min, sec, cstate);
Alarm alm(mstate, clk, mode03, mode13, set3, display3, dp, aoff3, reset1, ahour, amin, asec, astate);
StopWatch sw( mstate, clk, mode03, mode13, set3, display3, aoff3, reset1, smin, ssec, scsec, sstate);
OutputLogic ol(clk, reset1, aoff3,hour, min, sec, ahour, amin, asec, smin, ssec, scsec, mstate, cstate, astate, sstate, d1, d2, d3, d4, d5, d6, flash);

Translate d11(on, 3'b000, light, d1, flash[2], clk, J1);
Translate d12(on, 3'b001, light, d2, flash[2], clk, J2);
Translate d13(on, 3'b010, light, d3, flash[1], clk, J3);
Translate d14(on, 3'b011, light, d4, flash[1], clk, J4);
Translate d15(on, 3'b100, light, d5, flash[0], clk, J5);
Translate d16(on, 3'b101, light, d6, flash[0], clk, J6);


endmodule