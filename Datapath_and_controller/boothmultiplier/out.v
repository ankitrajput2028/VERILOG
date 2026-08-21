`timescale 1ns/1ps
module out (out,in1,in2);
    input [4:0] in1 , in2;
    output [9:0] out;

    assign out = {in1,in2};
endmodule