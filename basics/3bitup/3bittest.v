`timescale 1ns/1ps
module DUT;
    reg start,clk,rst;
    wire [2:0] cnt;

    cntr C1(start,clk,rst,cnt);

    initial 
    begin
    rst = 1'b0;
    clk = 1'b0;
    #200 $finish;
    end

    always #5 clk = ~clk;

    initial begin
       #10 rst = 1'b1; start = 1'b1;
    end

    initial 
    begin
        $monitor("time=0%t cnt = %d", $time, cnt);
        $dumpvars(0,DUT); $dumpfile("3bit.vcd");
    end
endmodule