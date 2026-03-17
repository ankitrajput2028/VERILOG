`timescale 1ns/1ps
module DUT;

reg [15:0] d_in;
reg clk,start;
wire [15:0] Sub_out;
wire ldA,ldB,sel_in,sel1,sel2,lt,gt,eq,done;


HCF H1(Sub_out,d_in,ldA,ldB,sel_in,sel1,sel2,lt,gt,eq,clk);
controller C1(ldA,ldB,sel_in,sel1,sel2,start,done,lt,gt,eq,clk);
    
   initial begin
    clk = 1'b0;
    #3 start = 1'b1;
    #500 $finish;
   end 

   always #5 clk = ~clk;

   initial begin
    #4 d_in = 2;
    #12 d_in = 5;
   end

   initial 
begin
    $monitor("time=%0t done=%b", $time, done);
    $dumpfile ("hcf.vcd"); $dumpvars (0, DUT);
end

endmodule