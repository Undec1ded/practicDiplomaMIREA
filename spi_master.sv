`timescale 1ns / 1ps
    //  frequency_A1 = 440, 
    //  frequency_A2 = 880,
    //  frequency_Ah2 = 932,

    //  frequency_B1 = 494,
    //  frequency_C1 = 523,
    //  frequency_D1 = 294,
    //  frequency_E2 = 659,
    //  frequency_G1 = 392,
    //  frequency_G2 = 784,
    //  frequency_F1 = 349,
    //  frequency_F2h = 740,
    // 
        
    //  frequency_A3 = 1720,
    //  frequency_B3 = 1975,
    //  frequency_C4 = 2093,
    //  frequency_D3 = 1174,
    //  frequency_E4 = 2637,
    //  frequency_G3 = 1568,
    //  frequency_G4 = 3136,
    //  frequency_F3 = 1396,
    //  frequency_F4h = 2960

    // A1 = 440
    // Ah1 = 466
    // A2 = 880
    // Ah2 = 932
    // C2 = 523
    // C3 = 1047
    // D2 = 587
    // Dh2 = 622
    // D3 = 1174
    // F2 = 698
    // F3 = 1396
    // G1 = 392
    // G2 = 784
    // G3 = 1568
module spi_master#(
    parameter bit_data = 1024,
    parameter frequency_25MGz = 25000000
     
    )(
input clk,
input logic [3 : 0] note_state,
input button_action,
input logic [bit_data - 1 : 0] data,

output logic sync,
output logic mosi,
output logic sclk
    );

// frequency notes



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
reg [5 : 0] note_state_chek = 0;


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

//the parameters for the frequencies are calculated by the formula frequency_note = frequency_25MGz / (64 * frequency_A1),
//where frequency_A1 is the frequency of the note, 64 is the number of points of the reproduced sine wave

always@(posedge sclk) begin 
    case (note_state)
        4'b0001: frequency_note = 888; // frequency_A1
        4'b0010: frequency_note = 838; // frequency_Ah1
        4'b0011: frequency_note = 444; // frequency_A2 
        4'b0100: frequency_note = 419; // frequency_Ah2
        4'b0101: frequency_note = 747; // frequency_C2
        4'b0110: frequency_note = 373; // frequency_C3
        4'b0111: frequency_note = 665; // frequency_D2
        4'b1000: frequency_note = 628; // frequency_Dh2
        4'b1001: frequency_note = 333; // frequency_D3
        4'b1010: frequency_note = 560; // frequency_F2
        4'b1011: frequency_note = 279; // frequency_F3
        4'b1100: frequency_note = 996; // frequency_G1
        4'b1101: frequency_note = 498; // frequency_G2
        4'b1110: frequency_note = 249; // frequency_G3
    default : frequency_note = frequency_25MGz;  
    endcase  
    

end

//logic signal out

always @(posedge sclk) begin
    if (counter_note < 16 & button_action == 1) begin
        shift_resolution <= 1;
        counter_note <=  counter_note + 1;
     end
    else if (note_state_chek != note_state & counter_note >= 16) begin
        counter_note = 0;
    end
    else if (counter_note != frequency_note & button_action == 1) begin
        shift_resolution <= 0;
        counter_note <=  counter_note + 1;
    end
    else counter_note <= 0;
    note_state_chek = note_state;

end
always@ (posedge sclk) begin

    if (counter_note == 0 & button_action == 1) begin
        sync = 1;
    end
    
    else sync = 0;
    
end

//spi

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
