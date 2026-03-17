`timescale 1ns/1ps
module MUX_in (out,in1,in2,sel);
    input sel;
    input [15:0] in1,in2;
    output [15:0] out;

    assign out = sel ? in2 : in1;
    
endmodule