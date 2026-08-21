`timescale 1ns/1ps
module DUT();
    reg clock; 
    wire [0:2] light;
    RGY R1 (clock, light);

    always #5 clock = ~clock;

    initial begin
        clock = 0;
        #100 $finish;
    end

    initial begin
        $monitor(" time is %d and the light colour is %d" , $time , light);
        $dumpfile("RYGlight.vcd");
        $dumpvars(0,DUT);

    end
endmodule