`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 18:49:34
// Design Name: 
// Module Name: counter
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


module counter(
input clk,
input buttonRestart,
output reg led = 1'b0
);

reg [32: 0]counter = 'b0;

always@(posedge clk)
begin
    counter <= counter + 1'b1;
    if (buttonRestart == 0)
        begin
            counter <= 'b0;
        end
    else if (counter == 32'b00000_00000_00000_00000_00000_00000_01)
        begin
            led <= 1'b1;
        end
    else led <= 1'b0;
end
endmodule
