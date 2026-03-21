`timescale 1ns/1ps
module ALU (out,in1,in2,as);
    input [4:0] in1,in2;
    input as;
    output reg [4:0] out;
    
    always @(*) begin
        if (as == 1) begin
            out = in1 + in2;
        end else if (as == 0) begin
            out = in1 - in2;
        end
    end
endmodule