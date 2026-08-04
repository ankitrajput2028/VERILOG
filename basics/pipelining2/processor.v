`timescale 1ns/1ps
module pipe_ex2 (rs1,rs2,rd,func,addr,clk1,clk2,wr,Z);

    input[3:0] rs1,rs2,rd,func;
    input[7:0] addr;
    input clk1,clk2,wr;
    //input[15:0] wrdata_reg;
   // input[15:0] wrdata_mem;
    output[15:0] Z;

    parameter ADD = 4'b0000,SUB = 4'b0001,MUL = 4'b0010,SELA = 4'b0011,
    SELB = 4'b0100,AND = 4'b0101,OR = 4'b0110,XOR = 4'b0111,NEGA = 4'b1000,NEGB = 4'b1001,
    SRA = 4'b1010,SLA = 4'b1011;

    reg [15:0] A,B;
    //reg [15:0] rddata1_mem;
    reg [3:0] L12f;
    reg [7:0] L12addr;
    reg [3:0] L12rd;
    reg L12wr;

    reg [7:0] L23addr;
    reg [3:0] L23rd;
    reg L23wr;
    reg [15:0] L23Z;

    reg [7:0] L34addr;
    reg L34wr;
    reg [15:0] L34Z;


    reg [15:0] R[15:0];
    reg [15:0] mem[255:0];

    assign Z = L34Z;

    always @(posedge clk1) begin
        A <=#2 R[rs1];
        B <=#2 R[rs2];

        L12f<=#2 func;
        L12rd<=#2 rd;
        L12addr<=#2 addr;
        L12wr<=#2wr;
    end

    always @(posedge clk2) begin
        case (L12f)
           ADD : L23Z <=#2 A + B;
           SUB : L23Z <=#2 A - B;
           MUL : L23Z <=#2 A * B;
           SELA : L23Z <=#2 A ;
           SELB : L23Z <=#2 B;
           AND : L23Z <=#2 A & B;
           OR : L23Z <=#2 A | B;
           XOR : L23Z <=#2 A ^ B;
           NEGA : L23Z <=#2 ~A;
           NEGB : L23Z <=#2 ~B;
           SRA : L23Z <=#2 A >>1 ;
           SLA : L23Z <=#2 A <<1 ;
        endcase
        L23rd<=#2 L12rd;
        L23addr<=#2 L12addr;
        L23wr<=#2L12wr;
    end

    always @(posedge clk1) begin
        R[L23rd] <=#2 L23Z;
        L34Z<=#2 L23Z;
        L34addr<=#2 L23addr;
        L34wr<=#2L23wr;
    end

    always @(posedge clk2) begin
        if (L34wr) begin
        mem[L34addr] <=#2 L34Z;
        end
    end
endmodule
