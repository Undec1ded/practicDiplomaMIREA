`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 18:49:34
// Design Name: 
// Module Name: frequencyDivider
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


module frequencyDivider(
input clk,
input buttonRestart,
output reg clkOut = 1'b0
);
parameter N = 20;
reg [N - 1: 0] counter = 0;

always @(posedge clk)
begin
    counter <= counter + 1'b1;
    if (buttonRestart == 0)
        begin
            counter <= 'b0;
            clkOut <= 'b0;
        end    
        counter <= counter + 1;
    if (counter == 'b0)
        begin
            clkOut <= 1'b1;
        end
    else clkOut <= 1'b0;
end
endmodule
