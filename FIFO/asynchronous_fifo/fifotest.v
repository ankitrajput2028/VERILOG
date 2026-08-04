`timescale 1ns/1ps
module DUT();

    reg rclk,wclk,rinc,wr_en,wrst,rrst;
    reg [31:0] wr_data;
    wire [31:0] rd_data;

    FIFO F1 (rclk,wclk,rinc,wr_en,wrst,rrst,wr_data,rd_data);

    always #5 wclk = ~wclk;
    always #5000 rclk = ~rclk;

    initial begin
        //test for scenario 1
        #97000
        $display(" empty port is %d" , F1.read_block.empty);// checking empty port
        $display("value of fifo 1st location is %d" , F1.memry.mem[0]);
        $display("value of fifo 8th location is %d" , F1.memry.mem[7]);

        //test for scenario 2
        /*
        #200
        $display(" full port is %d" , F1.write_block.full);// checking full port
        $display("value of fifo 1st location is %d" , F1.memry.mem[0]);// checking data of 1st location
        */


    end

    initial begin
        wclk = 0;
        rclk = 0;
        wrst = 1;
        rrst = 1;

        #10 wrst = 0;
        rrst = 0;
        #1 wrst = 1;
        rrst = 1;
        wr_en = 1;
        // scenario 1
        // checking the functionality of write ptr and read ptr ----1
        rinc = 1;
        wr_data = 4; //loaded data
        #10 wr_data = 8;
        #10 wr_data = 12;
        #10 wr_data = 16;
        #10 wr_data = 20;
        #10 wr_data = 24;
        #10 wr_data = 28;
        #10 wr_data = 32;
        #10 wr_en = 0;
        
        #100000 $finish;

        //scenario 2
        // checking full port functionality and simultaneously writing data after full stack
        /*
        wr_data = 4;
        #10 wr_data = 8;
        #10 wr_data = 12;
        #10 wr_data = 16;
        #10 wr_data = 20;
        #10 wr_data = 24;
        #10 wr_data = 28;
        #10 wr_data = 32;
        #10 wr_data = 36;// write 9th data trying to write after full

        #500 $finish;
        */


        // scenario 3
        // try to write upto some stack and then trying to read it after it gets empty
        /*
        wr_data = 4;
        #10 wr_data = 8;
        #10 wr_data = 12;
        #10 wr_data = 16;
        #10 wr_en = 0;
        rinc = 1;
        
        #70000
        $display("value of fifo 4th location is %d" , F1.memry.mem[3]);// checking data of 4th location
        $display("value of fifo 5th location is %d" , F1.memry.mem[4]);// checking data of 5th location
        $display("the data received at read terminal is %d" , rd_data); // it should be 16
        $display(" empty port is %d" , F1.read_block.empty);// checking empty port
        #100
        $finish;
        */

    end

    initial begin
        //checking values for scenario 1
        $monitor("the data received at read terminal is %d and time is %d" , rd_data , $time);
        $dumpfile("fifoo.vcd");
        $dumpvars(0,DUT);
    end
endmodule