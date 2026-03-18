`timescale 1ns/1ps
module shiftreg (dout,din,in1,ld,clr,sft,clk);
    input [15:0] din;
    input in1,ld,clr,sft,clk;
    output dout;

    always @(posedge clk) begin
        if (clr) begin
            dout <= 1'b0;
        end
        else if (ld) begin
            dout <= din;
        end
        else if (sft) begin
            dout <= {in1,din};
        end
    end
endmodule