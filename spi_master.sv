`timescale 1ns / 1ps

module spi_master#(
    parameter bit_data = 1024,
    parameter frequency_25MGz = 25000000,
    parameter frequency_A1 = 440,
    parameter frequency_A2 = 880,
    parameter frequency_B1 = 494,
    parameter frequency_C1 = 523,
    parameter frequency_D1 = 294,
    parameter frequency_E2 = 659,
    parameter frequency_G1 = 392,
    parameter frequency_G2 = 784,
    parameter frequency_F1 = 349,
    parameter frequency_F2h = 740
    
    )(
input clk,
input [3 : 0]note_state,
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
reg [31:0] frequency_note = 0;
reg [3 : 0] state_sw;
reg sync_driver = 1'b0;
reg [20 : 0] counter_note = 0;
reg [20 : 0] note = 0;
reg [1 : 0] frequency_divider_25MGz = 2'b00;
reg driver_for_divider_25MGz = 0;

assign sclk = driver_for_divider_25MGz;

always_ff @(posedge clk) begin
    if (frequency_divider_25MGz != 2'b11) begin
        frequency_divider_25MGz = frequency_divider_25MGz + 1;
        driver_for_divider_25MGz = 0;
    end
    else begin 
     driver_for_divider_25MGz = 1;
    frequency_divider_25MGz = 0;
    end
end



always_comb begin 
    case (note_state)
        4'b0001: frequency_note = 888; // frequency_A1
        4'b0010: frequency_note = 444; // frequency_A2
        4'b0011: frequency_note = 791; // frequency_B1 
        4'b0100: frequency_note = 747; // frequency_C1
        4'b0101: frequency_note = 1327;// frequency_D1
        4'b0110: frequency_note = 593; // frequency_E2
        4'b0111: frequency_note = 996; // frequency_G1
        4'b1000: frequency_note = 498; // frequency_G2
        4'b1001: frequency_note = 1119;// frequency_F1
        4'b1010: frequency_note = 528; // frequency_F2h
    default : frequency_note = frequency_25MGz;  
    endcase  
end


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
//assign sclk = driver_for_divider_25MGz;

//always_ff @(posedge clk) begin
//    if (frequency_divider_25MGz != 2'b11) begin
//        frequency_divider_25MGz = frequency_divider_25MGz + 1;
//        driver_for_divider_25MGz = 0;
//    end
//    else begin
//        driver_for_divider_25MGz = 1;
//        frequency_divider_25MGz = 0;
//    end
//end


//always_comb begin 
//    case (note_state)
//        4'b0001: note = frequency_A;
//        4'b0010: note = frequency_C;
//        4'b0100: note = frequency_G;
//        4'b1000: note = frequency_F;
//    default : note = 1;  
//    endcase  
//end

//assign sync = sync_driver; 
//always @(posedge sclk) begin
//    frequency_note = frequency_25MGz / (64*16 * note);
//    if (counter_note != frequency_note) begin
//        counter_note = counter_note + 1;
//        sync_driver = 1'b0;
//    end    
//    else begin
//        sync_driver = 1'b1;
//        counter_note = 0;
//    end
//end
//always@(posedge sync) begin
//        shift_resolution = sync_driver; 
//end
//always@(posedge sclk) begin
//    if(counter_shift_resolution != 5'b10000 & shift_resolution == 1) begin
//        counter_shift_resolution = counter_shift_resolution + 1;
//    end    
//    else begin 
//        shift_resolution = 0;
//        counter_shift_resolution = 0;
//    end
//end  

//always@(posedge sclk)
//    if (button_action != 1) begin
//        random_data = 0;
//        mosi = 0;
//    end
//    else if (random_data == 0) begin
//            random_data = data;
//    end
//    else if (shift_resolution == 1) begin
//            mosi <= random_data[bit_data - 1];
//            random_data = random_data << 1;
//    end 
//    else begin 
//        mosi = 0;    
//    end
    
//endmodule
