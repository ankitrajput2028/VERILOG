`timescale 1ns/1ps
module cntr (start,clk,rst,cnt);
    input start,clk,rst;
    output reg [2:0] cnt;
    wire [2:0] next_cnt;

    assign next_cnt = cnt + 1'b1;

    always @(posedge clk or negedge rst)
    begin
        if (!rst) 
        begin
            cnt <= 3'd0;
        end
        else if(start)
        begin
            cnt <= next_cnt;
        end
    end
endmodule