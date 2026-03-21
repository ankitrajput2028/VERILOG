`timescale 1ns/1ps
module PIPO (dout,din,ld,clk);
    input [4:0] din;
    input ld,clk;
    output reg [4:0] dout;

    always @(posedge clk) begin
        if (ld) begin
            dout <= din;
        end
    end
endmodule