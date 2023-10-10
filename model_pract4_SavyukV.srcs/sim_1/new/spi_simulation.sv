`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2023 01:18:58 PM
// Design Name: 
// Module Name: spi_simulation
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


module spi_simulation#(parameter num_bit = 8)();
wire mosi;
reg clk = 0;
reg chip_select = 0;
reg miso = 0;
    spi_master test(
        .chip_select(chip_select),
        .clk(clk),
        .mosi(mosi),
        .miso(miso)
    );
    always#5 clk <= !clk;
    always#5 miso <= !miso;
endmodule

