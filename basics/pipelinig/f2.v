`timescale 1ns/1ps
module pipe_ex (F,A,B,C,D,clk);
    parameter N = 10;
    input [N-1:0] A,B,C,D;
    input clk;
    output [N-1:0] F;
    reg[N-1:0] L12x1,L12x2,L12D,L23x1,L23D,L34x1;

    assign F = L34x1;

    always @(posedge clk) 
    begin
        L12x1 <=#4 A + B;
        L12x2 <=#4 C - D;
        L12D <= D;
    end

    always @(posedge clk) begin
        L23x1 <=#4 L12x1 + L12x2;
        L23D <= L12D;
    end

    always @(posedge clk) begin
        L34x1<=#6 L23x1*L23D;
    end
        
endmodule