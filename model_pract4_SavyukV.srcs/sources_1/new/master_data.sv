`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2023 11:06:44 AM
// Design Name: 
// Module Name: master_data
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


module spi_master#(
parameter num_bit = 8
)
(
input clk,
input logic miso,
input logic chip_select,
output logic mosi
);

reg [num_bit - 1:0] data = 8'b10101010;
reg [num_bit - 1:0] data_second;

always@(posedge clk)
if (chip_select == 0)
   begin
        mosi = data[num_bit-1];
        data_second = data << 1;
        data =  data_second | mosi;
   end
   
endmodule
