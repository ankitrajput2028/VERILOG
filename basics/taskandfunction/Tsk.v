`timescale 1ns/1ps
module adder (sum,cout,a,b,cin);
    input a,b,cin;
    output reg sum,cout;

    always @(cin or a or b) begin
        FA (sum,cout,a,b,cin);
    end

    task FA;
        output sum,carry;
        input A, B, C;
        begin
            #2 sum = A ^ B ^ C;
            carry = ((A&B) | (B&C) | (A&C));
        end
    endtask
endmodule