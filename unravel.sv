`timescale 1ns / 1ps

module unravel#(
       
)(
    input clk,
    input button_action,

    output logic [3 : 0] note

);
reg [3 : 0] idle =  4'b0000;
reg [3 : 0] note1 = 4'b0001;
reg [3 : 0] note2 = 4'b0010;
reg [3 : 0] note3 = 4'b0011;
reg [3 : 0] note4 = 4'b0100;
reg [3 : 0] note5 = 4'b0101;
reg [3 : 0] note6 = 4'b0110;
reg [3 : 0] note7 = 4'b0111;
reg [3 : 0] note8 = 4'b1000;
reg [3 : 0] note9 = 4'b1001;
reg [3 : 0] note10 = 4'b1010;
reg [3 : 0] note11 = 4'b1011;
reg [3 : 0] note12 = 4'b1100;
reg [3 : 0] note13 = 4'b1101;
reg [3 : 0] note14 = 4'b1110;
reg [3 : 0] note15 = 4'b1111;

reg [3 : 0] A1_note = 4'b0001;
reg [3 : 0] A2_note = 4'b0010;  
reg [3 : 0] B1_note = 4'b0011;
reg [3 : 0] C1_note = 4'b0100;
reg [3 : 0] D1_note = 4'b0101;
reg [3 : 0] E2_note = 4'b0110;
reg [3 : 0] G1_note = 4'b0111;
reg [3 : 0] G2_note = 4'b1000;
reg [3 : 0] F1_note = 4'b1001;
reg [3 : 0] F2h_note = 4'b1010;

reg [24 : 0] counter_sec = 0; 
reg [23 : 0] counter_time = 0;
reg time_driver = 0;
reg [3 : 0] state_note = 0;



always@ (posedge clk) begin
    if (counter_time != 21'b1_1001_0110_1110_0110_1010 & button_action == 1) begin
        time_driver = 0;
        counter_time = counter_time + 1;
    end
    else begin
        time_driver = 1;
        counter_time = 0;
end    
end

always@ (posedge time_driver) begin
    if (button_action == 1 & counter_sec != 10'b1101001001) begin
        counter_sec = counter_sec + 1;
        case (state_note)
            idle:   if (counter_sec == 5'b11110) begin
                        state_note = note1;       
                    end
                    else begin
                        note = 0;
                    end
            note1:  if (counter_sec == 6'b111_100) begin
                        state_note = note2;       
                    end
                    else begin
                        note = G2_note;
                    end
            note2:  if (counter_sec == 7'b1_111_000) begin
                        state_note = note3;       
                    end
                    else begin
                        note = A2_note;
                    end
            note3:  if (counter_sec == 8'b10_110_100) begin
                        state_note = note4;       
                    end
                    else begin
                        note = G2_note;
                    end
            note4:  if (counter_sec == 8'b11_110_000) begin
                        state_note = note5;       
                    end
                    else begin
                        note = F2h_note;
                    end
            note5:  if (counter_sec == 9'b100_101_100) begin
                        state_note = note6;       
                    end
                    else begin
                        note = E2_note;
                    end
            note6:  if (counter_sec == 9'b101_101_000) begin
                        state_note = note7;       
                    end
                    else begin
                        note = A2_note;
                    end
            note7:  if (counter_sec == 9'b110_100_100) begin
                        state_note = note8;       
                    end
                    else begin
                        note = G2_note;
                    end
            note8:  if (counter_sec == 9'b111_100_000) begin
                        state_note = note9;       
                    end
                    else begin
                        note = F2h_note;
                    end
            note9:  if (counter_sec == 10'b1_000_011_100) begin
                        state_note = note10;       
                    end
                    else begin
                        note = E2_note;
                    end
            note10:  if (counter_sec == 10'b1_000_111_010) begin
                        state_note = note11;       
                    end
                    else begin
                        note = E2_note;
                    end
            note11: if (counter_sec == 10'b1_001_110_110) begin
                        state_note = note12;       
                    end
                    else begin
                        note = D1_note;
                    end
            note12: if (counter_sec == 10'b1_010_010_100) begin
                        state_note = note13;       
                    end
                    else begin
                        note = D1_note;
                    end
            note13: if (counter_sec == 10'b1_011_010_000) begin
                        state_note = note14;       
                    end
                    else begin
                        note = C1_note;
                    end
            note14: if (counter_sec == 10'b1_100_001_100) begin
                        state_note = note15;       
                    end
                    else begin
                        note = D1_note;
                    end     
            note15: if (counter_sec == 10'b1_10_1001_000) begin
                        state_note = idle;       
                    end
                    else begin
                        note = B1_note;
                        counter_sec = 0;
                    end     
        endcase
    end
    else begin 
        counter_sec = 0;
    end
end
endmodule