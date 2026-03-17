`timescale 1ns/1ps
module HCF (Sub_out,d_in,ldA,ldB,sel_in,sel1,sel2,lt,gt,eq,clk);
    input clk,ldA,ldB,sel_in,sel1,sel2;
    input [15:0] d_in;
    output [15:0] Sub_out;
    output lt,gt,eq;
    wire [15:0] Aout,Bout,Bus_in,X,Y;

    PIPO1 A(Aout,Bus_in,ldA,clk);
    PIPO2 B(Bout,Bus_in,ldB,clk);
    MUX_in Min(Bus_in,Sub_out,d_in,sel_in);
    MUX1 M1(X,Aout,Bout,sel1);
    MUX2 M2(Y,Aout,Bout,sel2);
    COMP CMP(lt,gt,eq,Aout,Bout);
    SUBT SBT(Sub_out,X,Y);

endmodule