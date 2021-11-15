`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Thomas Kappenman
// 
// Create Date: 03/03/2015 09:06:31 PM
// Design Name: 
// Module Name: top
// Project Name: Nexys4DDR Keyboard Demo
// Target Devices: Nexys4DDR
// Tool Versions: 
// Description: This project takes keyboard input from the PS2 port,
//  and outputs the keyboard scan code to the 7 segment display on the board.
//  The scan code is shifted left 2 characters each time a new code is
//  read.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input CLK100MHZ,
    input rst_n, // TODO: Setar nas constraints
    output tx,
    input PS2_CLK,
    input PS2_DATA,
   // output reg [7:0] tx_data,
    output [6:0]SEG,
    output [7:0]AN,
    output DP
    );
    
wire s_req;
wire [7:0]s_data; // dado para ser transmitido
wire s_ack;
wire [7:0]k_data; // dado do teclado
wire k_flag;

//reg rst_n = 0;

reg CLK50MHZ=0;    
wire [31:0]keycode;

always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end

PS2Receiver keyboard (
.clk(CLK50MHZ),
.kclk(PS2_CLK),
.kdata(PS2_DATA),
.keycodeout(keycode[31:0]),
.datacur(k_data[7:0]),
.flag(k_flag)
);

seg7decimal sevenSeg (
.x(keycode[31:0]),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(DP) 
);

control control_i(
.clk(CLK50MHZ),
.rst_n(rst_n),
.k_data(k_data[7:0]),
.k_flag(k_flag),
.s_req(s_req),
.s_data(s_data[7:0]),
.s_ack(s_ack)
);

serial_transmitter serial_transmitter_i (
.clk(CLK50MHZ),
.rst_n(rst_n),
.tx(tx),
.req(s_req),
.data(s_data[7:0]),
.ack(s_ack)
);
 
endmodule
