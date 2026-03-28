`timescale 1ns/1ps
module DUT;
    reg clk,rst,start;
    reg [3:0] X,Y;

    wire [7:0] Z;
    wire valid;

booth B1(clk,rst,start,X,Y,Z,valid);

    initial 
    begin
        clk = 1'b0;
        rst = 1'b0;
        start = 1'b0;
        X= 5;
        Y= 7;
        #200 $finish;
    end

    always #5 clk = ~clk;

    initial
    begin
        #10 start = 1'b1; rst = 1'b1;
        #10 start = 1'b0;
    end
    initial begin
        $monitor ("time=%0t valid =%b" ,$time , valid);
        $dumpvars (0,DUT); $dumpfile("booth.vcd");
    end

endmodule