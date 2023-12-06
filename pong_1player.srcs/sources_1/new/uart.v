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
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, data_out);
    uart_tx transmitter(baud, data_out, en, sent, RsTx);
    
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