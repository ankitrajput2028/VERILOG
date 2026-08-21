`timescale 1ns/1ps
module controller (start,count,ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,clk,clrff,Q0,ldM,qm1,addsub,done);
    input clk, Q0;
    input [4:0] count;
    input start,qm1;
    output reg ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,clrff,ldM,addsub,done;
    reg [2:0] state;
    parameter S0 = 3'b000, S1 =3'b001, S2 =3'b010, S3 =3'b011, S4 =3'b100, S5 =3'b101, S6 =3'b110, S7 =3'b111;
    
    always @(posedge clk) begin
        case (state)
            S0 : if (start) state <= S1;
            S1 : state <= S2;
            S2 : state <= S3;
            S3 : if (count == 0) state <= S7; 
                else if ({Q0,qm1} == 2'b10) state <= S4; 
                else if ({Q0,qm1} == 2'b01) state <= S5; 
                else if (Q0 == qm1) state <= S6; 
            S4 : state <= S6;
            S5 : state <= S6;
            S6 : state <= S3;
            S7 : state <= S7;
            default: state <= S0;
        endcase
    end

//count,ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,clk,clrff,Q[0],ldM,addsub,done
    always @(state) begin
        case (state)
            S0 : begin
               #1 clrA =1; clrff =1; ldM =1; clrQ =1; ldcnt =1;
            end
            S1 : begin
                #1 clrQ =0; clrA =0; clrff =0; ldM =0; ldQ =1; ldcnt =0 ;     
            end 
            S2 : begin
                #1 decr =0; ldQ =0; sftA =0; sftQ =0;
            end 
            S3 : begin
                #1 decr =0; sftA =0; sftQ =0;
            end 
            S4 : begin
                #1 decr =0; addsub =0; ldA =1; sftA =0; sftQ =0;    
            end 
            S5 : begin
                #1 decr =0; addsub =1; ldA =1; sftA =0; sftQ =0;
            end 
            S6 : begin
                #1 decr =1; ldA =0; sftA =1; sftQ =1;    
            end 
            S7 : begin
                #1 done =1;    
            end 
            default: state <= S0;
        endcase
    end
endmodule