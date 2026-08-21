`timescale 1ns/1ps
module if_else ();
    input[3:0] a,b;
    output reg gt,lt,eq;


    always @(*) begin
    if (a > b) //comparator
    begin
        gt = 1'b1;
        lt =1'b0;
    end

    else if (a<b)// comparator
    begin
        gt = 1'b0;
        lt =1'b1;
    end
    
    else
    begin
        gt = 1'b0;
        lt =1'b0;
    end

    end
endmodule