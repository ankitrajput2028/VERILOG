`timescale 1ns/1ps
module shiftreg (dout,din,in1,ld,clr,sft,clk);
    input [4:0] din;
    input in1,ld,clr,sft,clk;
    output reg [4:0] dout;

    always @(posedge clk) begin
        if (clr) begin
            dout <= 5'b0;
        end
        else if (ld) begin
            dout <= din;
        end
        else if (sft) begin
            dout <= {in1,dout[4:1]};
        end
    end
endmodule