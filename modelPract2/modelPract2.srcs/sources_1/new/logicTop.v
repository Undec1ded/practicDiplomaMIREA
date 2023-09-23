`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 18:49:34
// Design Name: 
// Module Name: logicTop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module logicTop(
input clk,
input buttonRestart,
output ledOut
    );

wire signClk;

frequencyDivider component1 (.clk(clk), .buttonRestart(buttonRestart), .clkOut(signClk));
counter component2 (.clk(signClk), .buttonRestart(buttonRestart), .led(ledOut));


endmodule
