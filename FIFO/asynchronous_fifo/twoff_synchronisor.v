module synchronisor (clk,rst,din,q2);
    input clk,rst;
    input [3:0] din;
    output reg [3:0] q2;

    reg [3:0] q1;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            q2 <= 0;
            q1 <=0 ;
        end

        else begin
            {q2,q1} <= {q1,din};
        end
    end
endmodule