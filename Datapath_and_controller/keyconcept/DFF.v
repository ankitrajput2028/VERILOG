`timescale 1ns/1ps
module DFF (dout,din,clr,clk);
    input din,clr,clk;
    output reg dout;

    always @(posedge clk) begin
        if (clr) begin
            dout <= 1'b0;
        end else begin
            dout <= din;
        end
    end
endmodule