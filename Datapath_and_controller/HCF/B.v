`timescale 1ns/1ps
module PIPO2 (dout,din,ld,clk);
    input ld,clk;
    input [15:0] din;
    output reg [15:0] dout;
    
    always @(posedge clk) begin
        if (ld) begin
            dout <= din;
        end
    end
endmodule