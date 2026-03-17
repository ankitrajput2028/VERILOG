`timescale 1ns/1ps
module controller (ldA,ldB,sel_in,sel1,sel2,start,done,lt,gt,eq,clk);
    input start,lt,gt,eq,clk;
    output reg done,ldA,ldB,sel_in,sel1,sel2;
    reg [2:0] state;
    parameter S0 = 3'b001, S1 = 3'b010, S2 = 3'b011, S3 = 3'b100, S4 = 3'b101;

    always @(posedge clk) begin
        #1  case (state)
            S0 : if (start) state <= S1;
            S1 : state <= S2;
            S2 : if (lt) state <= S2;
            else if(gt) state <= S3;
            else if(eq) state <= S4;
            S3 : if (lt) state <= S2;
            else if(gt) state <= S3;
            else if(eq) state <= S4;
            S4 : state <= S4;
            default: state <= S0;
        endcase
    end

    always @(state) begin
        case (state)
            S0 : begin #1 sel_in =1;ldA =1 ;end
            S1 : begin #1 ldA =0; ldB =1;end
            S2 : begin #1 sel_in =0; ldA =0; sel1 =0; sel2 =1;end
            S3 : begin #1 sel1 =1; sel2 =0; ldA =1; ldB =0;end
            S4 : begin #1 sel_in =0; done =1; ldA =0; ldB =0;end
            default: begin state <= S0;end
        endcase
    end

endmodule