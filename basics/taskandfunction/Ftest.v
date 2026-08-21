`timescale 1ns/1ps
module DUT;
    reg a, b, cin;
    wire sum,cout;

    adder A1(sum,cout,a,b,cin);

    initial begin
        #50 $finish;
    end

    initial begin
        #0 a = 1'b0; b = 1'b0; cin = 1'b0;
        #5 a = 1'b0; b = 1'b0; cin = 1'b1;
        #5 a = 1'b0; b = 1'b1; cin = 1'b0;
        #5 a = 1'b0; b = 1'b1; cin = 1'b1;
        #5 a = 1'b1; b = 1'b0; cin = 1'b0;
        #5 a = 1'b1; b = 1'b0; cin = 1'b1;
        #5 a = 1'b1; b = 1'b1; cin = 1'b0;
        #5 a = 1'b1; b = 1'b1; cin = 1'b1;
    end

    initial begin
        $monitor ("time=0%t sum=%b cout=%b",$time , sum, cout);
        $dumpvars(0,DUT); $dumpfile("dump.vcd");
    end
endmodule