`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 09:59:35 PM
// Design Name: 
// Module Name: uart
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

module uart(
    input clk,
    input RsRx,
    output p1up, p1down, p2up, p2down,
    output RsTx
    );
    
    reg en, last_rec;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire sent, received, baud;
    
    reg p1up, p1down, p2up, p2down;
    
    reg [3:0] p1up_sr, p1down_sr, p2up_sr, p2down_sr;
    reg [3:0] p1up_debounced, p1down_debounced, p2up_debounced, p2down_debounced;
    
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, data_out);
    uart_tx transmitter(baud, data_out, en, sent, RsTx);
    
//    always @(posedge clk) begin
//        // Shift in button values to shift registers
//        p1up_sr <= {p1up_sr[2:0], p1up};
//        p1down_sr <= {p1down_sr[2:0], p1down};
//        p2up_sr <= {p2up_sr[2:0], p2up};
//        p2down_sr <= {p2down_sr[2:0], p2down};
        
//        // Perform debouncing
//        p1up_debounced <= (p1up_sr == 4'b0000) ? 0 :
//                          (p1up_sr == 4'b1111) ? 1 :
//                          p1up_debounced;

//        p1down_debounced <= (p1down_sr == 4'b0000) ? 0 :
//                            (p1down_sr == 4'b1111) ? 1 :
//                            p1down_debounced;

//        p2up_debounced <= (p2up_sr == 4'b0000) ? 0 :
//                          (p2up_sr == 4'b1111) ? 1 :
//                          p2up_debounced;

//        p2down_debounced <= (p2down_sr == 4'b0000) ? 0 :
//                            (p2down_sr == 4'b1111) ? 1 :
//                            p2down_debounced;
//    end
    
    always @(posedge clk) begin //baud
        p1up = 0;
        p1down = 0;
        p2up = 0;
        p2down = 0;
        if (en) en = 0;
        if (~last_rec & received) begin
//            if (data_in <= 8'h7A && data_in >= 8'h41) en = 1;
            en = 1;
            if(data_out == 8'h77) p1up = 1; //w
            else if (data_out == 8'h73) p1down = 1; //s
//            else if (data_out == 8'h38) p2up = 1;  //up arrow
//            else if (data_out == 8'h40) p2down = 1; // down arrow
            else if (data_out == 8'h69) p2up = 1;  //i
            else if (data_out == 8'h6B) p2down = 1; // k
        end
        last_rec = received;
    end
    
    
endmodule