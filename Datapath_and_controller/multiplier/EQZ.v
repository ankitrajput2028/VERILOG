`timescale 1ns/1ps
module EQZ (eq,din);
    input [15:0] din;
    output eq;
    assign eq = (din == 1);
endmodule