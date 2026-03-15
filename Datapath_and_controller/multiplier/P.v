`timescale 1ns/1ps
module PIPO2 (dout,din,ld,clr,clk);
    input ld,clr,clk;
    input [31:0] din;
    output reg [31:0] dout;
    always @(posedge clk or posedge clr)
    begin
        if (clr) begin
            dout <= 32'b0;
        end else if (ld) begin
            dout <= din;
        end
    end
endmodule