`timescale 1ns / 1ps

module spi_master#(
    parameter bit_data = 1024,
    parameter frequency_25MGz = 25000000,
    parameter frequency_A = 440*55,
    parameter frequency_G = 392,
    parameter frequency_F = 349,
    parameter frequency_C = 262    
    )(
input clk,
input [3 : 0]sw,
input button_action,
input [bit_data - 1 : 0] data,

output logic sync,
output logic mosi,
output logic sclk
    );

reg [bit_data - 1 : 0] random_data = data;

reg [4 : 0] counter_shift_resolution = 5'b10000;
reg shift_resolution = 0;
reg time_one_bit = 0;
reg [20:0] counter_time_one_bit = 0;
reg [20:0] frequency_note = 0;
reg [3 : 0] state_sw;
reg sync_driver = 1'b0;
reg [20 : 0] counter_note = 0;
reg [20 : 0] note = 0;
reg [1 : 0] frequency_divider_25MGz = 2'b00;
reg driver_for_divider_25MGz = 0;




assign sclk = driver_for_divider_25MGz;

always_ff @(posedge clk) begin
    if (frequency_divider_25MGz != 2'b11) begin
        driver_for_divider_25MGz = ~driver_for_divider_25MGz ;
        frequency_divider_25MGz = 0;
    end
    else frequency_divider_25MGz = frequency_divider_25MGz + 1;
end






always_comb begin 
    state_sw = {sw[3], sw[2], sw[1], sw[0]};
    case (sw)
        4'b0001: frequency_note = frequency_25MGz / (64*16 * frequency_A);
        4'b0010: frequency_note = frequency_25MGz / (64*16 * frequency_C);
        4'b0100: frequency_note = frequency_25MGz / (64*16 * frequency_G);
        4'b1000: frequency_note = frequency_25MGz / (64*16 * frequency_F);
    default : frequency_note = frequency_25MGz;  
    endcase  
end






//assign sync = sync_driver;
 
//always @(posedge sclk) begin
//    if (counter_note != frequency_note) begin
//        counter_note <= counter_note + 1;  
//        if (counter_note > (frequency_note - 16)) shift_resolution <= 1;
//        else shift_resolution <= 0;
//    end    
////    else if begin
////        counter_note <= 0;
////        shift_resolution <= 1'b1;
////    end   
//end

always @(posedge sclk) begin
    if (counter_note < 16 & button_action == 1) begin
        shift_resolution <= 1;
        counter_note <=  counter_note + 1;
     end
    else if (counter_note != frequency_note & button_action == 1) begin
        shift_resolution <= 0;
        counter_note <=  counter_note + 1;
    end
    else counter_note <= 0;
end
always@ (posedge sclk) begin
    if (counter_note == 0 & button_action == 1) begin
        sync = 1;
    end
    
    else sync = 0;
end
//always@(posedge sclk) begin
//    if ((counter_note != frequency_note) & (button_action == 1)) begin 
//        counter_note =  counter_note + 1;
//    end
//    else if (counter_note <= 5'b10001) begin 
//        shift_resolution = 1;
//    end
//    else begin
//        shift_resolution = 0;
//    end
//end



//always@(posedge sclk or posedge shift_resolution) begin
//    if((shift_resolution == 1)) begin
//        counter_shift_resolution = counter_shift_resolution + 1;
//    end    
//    else begin 
//        shift_resolution = 0;
//        counter_shift_resolution = 0;
//    end
//end  







always@(posedge sclk)
    if (button_action != 1) begin
        random_data = 0;
        mosi = 0;
    end
    else if (random_data == 0) begin
            random_data = data;
    end
    else if (shift_resolution == 1) begin
            mosi = random_data[bit_data - 1];
            random_data = random_data << 1;
    end 
    else begin 
        mosi = 0;    
    end
    
endmodule
