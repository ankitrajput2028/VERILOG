`timescale 1ns / 1ps
module CNTR (dout,din,ld,dec,clk);
    input ld,dec,clk;
    input [15:0] din;
    output reg [15:0] dout;
    always @(posedge clk) 
    begin
        if (ld) dout <= din;
        else if(dec) dout <= dout - 1;
    end
endmodule