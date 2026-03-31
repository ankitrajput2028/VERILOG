`timescale 1ns/1ps
module adder (sum,cout,a,b,cin);
    input a,b,cin;
    output sum,cout;

    assign sum = s(a,b,cin);
    assign cout = c(a,b,cin);
    function s;
        input x, y, z;
        begin
            s = x ^ y ^ z;
        end
    endfunction

    function c;
        input x, y, z;
        begin
            c = ((x&y) | (y&z) | (x&z));
        end
    endfunction
endmodule



