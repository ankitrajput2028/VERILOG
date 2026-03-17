`timescale 1ns/1ps
module MUX2 (out,in1,in2,sel2);
    input sel2;
    input [15:0] in1,in2;
    output [15:0] out;

    assign out = sel2 ? in1 : in2;
    
endmodule