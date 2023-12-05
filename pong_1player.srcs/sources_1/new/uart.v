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
    output p1up, p1down, p2up, p2down
    );
    
    reg en, last_rec;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire sent, received, baud;
    
    reg p1up, p1down, p2up, p2down;
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, data_out);
    
    initial begin
        p1up = 0;
        p1down = 0;
        p2up = 0;
        p2down = 0;
    end
    
    always @(posedge baud) begin
        p1up = 0;
        p1down = 0;
        p2up = 0;
        p2down = 0;
        if (en) en = 0;
        if (~last_rec & received) begin
            if(data_out == 8'h77) p1up = 1; //w
            else if (data_out == 8'h73) p1down = 1; //s
            else if (data_out == 8'h38) p2up = 1;  //up arrow
            else if (data_out == 8'h40) p2down = 1; // down arrow
            else begin
                p1up = 0;
                p1down = 0;
                p2up = 0;
                p2down = 0;
            end
        end
        last_rec = received;
    end
    
    
endmodule