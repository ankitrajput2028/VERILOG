`timescale 1ns/1ps
module controller (ldA,ldP,clrP,ldB,decB,start,done,eqz,clk);
    input clk,eqz,start;
    output reg ldA,ldP,clrP,ldB,decB,done;

    reg [2:0] state;
    parameter S0 = 3'b001,S1 = 3'b010,S2 = 3'b011,S3 = 3'b100,S4 = 3'b101;
    always @(posedge clk) begin
        case (state)
            S0 : if(start) state <= S1;
            S1 : state <= S2;
            S2 : state <= S3;
            S3 : #2 if (eqz) state <= S4;
            S4 : state <= S4;
            default: state <= S0;
        endcase
    end

    always @(state) begin
        case (state)
            S0 : begin #1 ldA =1'b0; ldB =1'b0; decB =1'b0; ldP =1'b0; clrP=1'b0; done =1'b0; end
            S1 : begin #1 ldA =1'b1; end
            S2 : begin #1 ldA =1'b0; ldB =1'b1; clrP=1'b1; end
            S3 : begin #1 ldB =1'b0; clrP =1'b0; decB =1'b1; ldP =1'b1;ldA =1'b0; end
            S4 : begin #1 done =1'b1; ldP =1'b0; decB =1'b0; end
            default: begin #1 ldA =1'b0; ldB =1'b0; decB =1'b0; ldP =1'b0; clrP=1'b0; done =1'b0; end
        endcase
    end
endmodule