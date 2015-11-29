`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:			Adrian Reyes
// Module Name:		I2C_Slave_TM
// Project Name:		I2C_Slave-LCD_Buttons_Switches
// Target Devices:	SPARTAN 3E
// Description:		I2C Slave Top Module
// Dependencies:		I2C_Slave
//							I2C_Slave_Controller
//							RAM32x8
//							LCDI
//////////////////////////////////////////////////////////////////////////////////
module I2C_Slave_TM(
	output [3:0]dataout,			// Data out to LCD
	output [2:0]control,			// Control to LCD
	input btn_west,				//
	input btn_east,
	input btn_north,
	input rotary_center,			// Push Button to signal which nibble being written
	input rotary_a,				// Push Button Address Increment
	input rotary_b,				// Push Button Address Decrement
	inout scl,
	inout sda,
	input clk,
	input reset
	);

	wire charColumnLeftBtn;
	wire charColumnRightBtn;
	wire menuBtn;
	wire rotaryBtn;
	wire rotary_event;
	wire rotary_left;
	wire enableCursor;
	wire cursorLeft;
	wire cursorRight;

	wire [4:0]LCD_WADD;
	wire [7:0]LCD_DIN;
	wire LCD_W;
	wire [7:0]LocalRAM_DOUT;
	wire [7:0]editAddress;
	wire [7:0]RemoteRAM_WADD;
	wire [7:0]RemoteRAM_DIN;
	wire RemoteRAM_W;
	wire RemoteRWControl;

	Debouncer debouncerPbWest(
		.E(charColumnLeftBtn),
		.pb(btn_west),
		.clk(clk)
		);
	Debouncer debouncerPbEast(
		.E(charColumnRightBtn),
		.pb(btn_east),
		.clk(clk)
		);
	Debouncer debouncerPbNorth(
		.E(menuBtn),
		.pb(btn_north),
		.clk(clk)
		);
	Debouncer debouncerRotaryCenter(
		.E(rotaryBtn),
		.pb(rotary_center),
		.clk(clk)
		);

	RotaryEncoder rotaryEncoder(
		.rotary_event(rotary_event),
		.rotary_left(rotary_left),
		.rotary_a(rotary_a),
		.rotary_b(rotary_b),
		.clk(clk)
		);

	I2C_Slave slave(
		.RAM_Addr(RAM_Addr),
		.RemoteRAM_DIN(RemoteRAM_DIN),
		.RemoteRAM_W(RemoteRAM_W),
		.LocalRAM_DOUT(LocalRAM_DOUT),
		.scl(scl),
		.sda(sda),
		.clk(clk),
		.reset(reset)
		);

	I2C_MenuController menuController(
		.LCD_WADD(LCD_WADD),
		.LCD_DIN(LCD_DIN),
		.LCD_W(LCD_W),
		.RemoteRWControl(RemoteRWControl),
		.enableCursor(enableCursor),
		.cursorLeft(cursorLeft),
		.cursorRight(cursorRight),
		.editAddress(editAddress),
		.enableControllers(enableControllers),
		.MenuRAM_Select(MenuRAM_Select),
		.MultiRAM_SEL(MultiRAM_SEL),
		.MultiRAM_ADD(MultiRAM_ADD),
		.MultiRAM_DIN(MultiRAM_DIN),
		.MultiRAM_W(MultiRAM_W),
		.MultiRAM_Clear(MultiRAM_Clear),
		.MultiRAM_DOUT(MultiRAM_DOUT),
		.rotary_event(rotary_event),
		.rotary_left(rotary_left),
		.rotaryBtn(rotaryBtn),
		.charColumnLeftBtn(charColumnLeftBtn),
		.charColumnRightBtn(charColumnRightBtn),
		.menuBtn(menuBtn),
		.clk(clk),
		.reset(reset)
		);

	I2C_RAMController ramController(
		.MultiRAM_DOUT(MultiRAM_DOUT),
		.LocalRAM_DOUT(LocalRAM_DOUT),
		.MenuRAM_Select(MenuRAM_Select),
		.MultiRAM_SEL(MultiRAM_SEL),
		.MultiRAM_ADD(MultiRAM_ADD),
		.MultiRAM_DIN(MultiRAM_DIN),
		.MultiRAM_W(MultiRAM_W),
		.MultiRAM_Clear(MultiRAM_Clear),
		.RemoteRAM_WADD(RAM_Addr),
		.RemoteRAM_DIN(RemoteRAM_DIN),
		.RemoteRAM_W(RemoteRAM_W),
		.LocalRAM_RADD(RAM_Addr),
		.clk(clk)
		);

	LCDI_Menu lcdi(
		.dataout(dataout),
		.control(control),
		.WADD(LCD_WADD),
		.DIN(LCD_DIN),
		.W(LCD_W),
		.enableCursor(enableCursor),
		.cursorLeft(cursorLeft),
		.cursorRight(cursorRight),
		.clk(clk)
		);

//	always@(posedge rotary_event) begin
//		if (rotary_left) begin
//			if (LEDs == 8'b10000000)
//				LEDs <= 8'b0000001;
//			else
//				LEDs <= LEDs << 1;
//		end
//		// Otherwise rotary rotate right
//		else begin
//			if (LEDs == 8'b00000001)
//				LEDs <= 8'b10000000;
//			else
//				LEDs <= LEDs >> 1;
//		end
//	end



endmodule
