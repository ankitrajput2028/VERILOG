`timescale 1ns/1ps // pending , plz DONT refer will complete later!
module i2c ();
    input clk;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            sda <= 1'b1;
            scl <= 1'b1;
            STATE <= IDLE;
        end
        else if (s_bit) begin
            STATE <= START;
            sda <= 1'b0;
            scl <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (STATE) begin
            count <= 6;
            case (state)
            s_addr :  begin
                    sda <= addr[count];
                    scl <= clk;
                    count <= count - 1'b1;
                    if (count == 0) begin
                        case (rd_wr)
                            rd  :   state <= s_rd; 
                            wr  :   state <= s_wr; 
                        endcase
                    end
            end    
            s_rd : begin
                sda <= rd;
                state <= s_ack;
            end 

            s_wr : begin
                sda <= wr;
                state <= s_ack;
            end
                default: STATE <= START; 
            endcase
        end
    end
endmodule