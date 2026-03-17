`timescale 1ns/1ps
module MUX1 (out,in1,in2,sel1);
    input sel1;
    input [15:0] in1,in2;
    output [15:0] out;

    assign out = sel1 ? in1 : in2;
    
endmodule