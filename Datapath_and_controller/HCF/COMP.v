`timescale 1ns/1ps
module COMP (l,g,e,in1,in2);
    input [15:0] in1,in2;
    output l,g,e;

    assign l = in1 < in2;
    assign g = in1 > in2;
    assign e = in1 == in2;
endmodule