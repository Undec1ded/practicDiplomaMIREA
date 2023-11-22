`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2023 01:49:40 PM
// Design Name: 
// Module Name: music_top
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


module music_top#(
    bits_data_out = 1024
)(
    input clk,
    input button_action,
    
    output signal,
    output sync,
    output sclk
);
    
logic [bits_data_out  - 1 : 0] data;
logic [3 : 0] note_state;
ram_sinusoid ram_sinusoid(.clk(clk), .data(data));
unravel unravel(.clk(clk), .button_action(button_action), .note(note_state));
spi_master spi_master(.clk(clk), .button_action(button_action), .data(data), .note_state(note_state), .mosi(signal), .sync(sync), .sclk(sclk));    
    
endmodule
