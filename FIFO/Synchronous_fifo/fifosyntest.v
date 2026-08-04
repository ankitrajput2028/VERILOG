`timescale 1ns/1ps
module DUT;

parameter FIFO_DEPTH = 8;
parameter DATA_WIDTH = 32;
parameter FIFOHALF = 4;
reg clk,rd_en,wr_en,rst,cs;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire empty,full;
integer k;

FIFOSYNC F1(cs,wr_en,rd_en,clk,rst,data_in,full,empty,data_out);

always #5 clk = ~clk;
initial begin
        clk =0;
        rst =0;
        cs=0;

        rd_en=0;
        wr_en=0;
        //scenario1--------------------------------------------------------------------------
        $display("time : %d, Empty : %d", $time , empty); //checking empty port

        #10 rst =1;
        //scenario2--------------------------------------------------------------------------------
        wr_en = 1;
        cs =1;
        for (k = 0; k<FIFO_DEPTH; k = k+1) begin
        @(posedge clk)
            data_in <= k*2;
        end
        @(posedge clk)
        wr_en =0;
        $display("time : %d, Full : %d, Empty : %d", $time , full , empty); // checking full port

        //scenario3-------------------------------------------------------------------------

        @(posedge clk)
        wr_en =1;
        repeat(2)
        begin
        @(posedge clk)
            data_in <= k*3;// writing after full
            $display("Time : %d , FIFOvalue : %d", $time , F1.fifo[1]);
        end
        wr_en =0;
        #1 
        rst =0;
        #1
        rst =1;
        //scenario4-------------------------------------------------------------------------
        k=0;
        wr_en=1;
        data_in <= k*4;// first loading data
        @(posedge clk)
        for (k = 1; k<FIFOHALF-1; k = k+1) 
        begin
            @(posedge clk)
            data_in <=  k*4;
        end
        $display("Time : %d , FIFOvalue : %d", $time , F1.fifo[2]);
        @(posedge clk)
        rd_en =1;// after 3rd clk edge empty should be high and automatically read should
        wr_en =0;// stop and last data out will be 8
        
        #60 rd_en =0;
        $display("Time : %d , FIFOvalue : %d", $time , F1.fifo[1]);
        #20 $finish;
end

initial begin
    $monitor("Time : %d, D_in : %d, D_out : %d",$time , data_in ,data_out);
    $dumpvars(0,DUT); $dumpfile("dump.vcd");
end

endmodule