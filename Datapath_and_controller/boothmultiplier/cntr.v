`timescale 1ns/1ps
module CNTR (dout,ld,dec,clk);
    input ld,dec,clk;
    output reg [4:0] dout;

    always @(posedge clk) begin
        if (ld) begin
            dout <= 5'b00101;
        end else if(dec) begin
            dout <= dout - 1;
        end
    end
endmodule