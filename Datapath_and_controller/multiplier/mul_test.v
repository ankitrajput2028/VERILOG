`timescale 1ns/1ps
module mul_test;

reg [15:0] data_in;
reg clk, start;
wire [31:0] Mul;
wire ldA,ldP,clrP,ldB,decB;
wire done,eqz;

datapath DP (data_in,ldA,ldP,clrP,ldB,decB,eqz,Mul,clk);
controller CON (ldA,ldP,clrP,ldB,decB,start,done,eqz,clk);

initial 
begin
    clk = 1'b0;
    #3 start = 1'b1;
    #97 $finish;
end

always #5 clk = ~clk;

initial 
begin
    #24 data_in = 17;
    #10 data_in = 5;
end
initial 
begin
    $monitor("time=%0t X=%d Y=%d Mul=%d done=%b", $time, DP.X, DP.Y, Mul, done);
    $dumpfile ("mul.vcd"); $dumpvars (0, mul_test);
end

endmodule