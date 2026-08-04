`timescale 1ns/1ps
module booth (clk,rst,start,X,Y,Z,valid); //important
    input clk,rst,start;
    input signed [3:0] X,Y;
    output reg signed [7:0] Z;
    output reg valid;

    reg signed [7:0] next_Z, temp_Z;
    reg pre_state, next_state;
    reg next_valid; 
    reg [1:0] count, next_count;
    reg [1:0] temp, next_temp;
    parameter IDLE = 1'b0, START = 1'b1;

    always @(posedge clk or negedge rst) 
    begin
        if (!rst) // reset and then give a start signal
        begin
            Z <= 8'd0;
            pre_state <= 1'b0;
            valid <= 1'b0;
            count <= 2'd0;
            temp <= 2'd0;
        end
        else
        begin
            Z <= next_Z;
            pre_state <= next_state;
            valid <= next_valid;
            count <= next_count;
            temp <= next_temp;
        end
    end
    
    always @(*) begin
        case (pre_state)
            IDLE :
            begin
            next_count = 2'd0;
            next_valid = 1'b0;
            if(start)
            begin
                next_state = START;
                next_temp = {X[0],1'b0};
                next_Z = {4'd0,X[3:0]};
            end
            else
            begin
                next_state = pre_state;
                next_temp = 2'd0;
                next_Z = 8'd0;
            end
            end

            START :
            begin
            case (temp)
                2'b10 : temp_Z = {Z[7:4] - Y,Z[3:0]}; 
                2'b01 : temp_Z = {Z[7:4] + Y,Z[3:0]}; 
                default: temp_Z = Z;
            endcase 
            next_temp = {X[count + 1],X[count]};
            next_count = count + 1;
            next_Z = temp_Z >>> 1;
            next_valid = (&count) ? 1'b1 : 1'b0;
            next_state = (&count) ? IDLE : pre_state;
            end
        endcase
    end
endmodule