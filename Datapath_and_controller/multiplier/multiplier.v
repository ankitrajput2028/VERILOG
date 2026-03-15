`timescale 1ns / 1ps
module datapath(data_in,ldA,ldP,clrP,ldB,decB,eqz,Mul,clk);
    input ldA,ldB,decB,ldP,clrP,clk;
    input [15:0] data_in;
    output eqz;
    output [31:0] Mul;
    wire [15:0] X,Bus_in,Bout;
    wire [31:0] Y,Z;
    assign Bus_in = data_in;
    assign Z = Mul;

    PIPO1 A(X,Bus_in,ldA,clk);
    PIPO2 P(Y,Mul,ldP,clrP,clk);
    CNTR B(Bout,Bus_in,ldB,decB,clk);
    ADD AD(Mul,X,Y);
    EQZ COMP(eqz,Bout);
endmodule