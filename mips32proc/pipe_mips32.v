`timescale 1ns/1ps
module  pipe_mips32(clk1,clk2);

    input clk1,clk2; //take intr every two clk edge
    reg [31:0] IF_ID_IR,ID_EX_IR,EX_MEM_IR,MEM_WB_IR;
    reg TAKEN_BRANCH,HALTED,EX_MEM_COND;
    reg [5:0] PC,IF_ID_NPC,ID_EX_NPC;
    reg [31:0] mem[0:1023]; // 1024 instruction can be stored
    reg [31:0] EX_MEM_ALU,ID_EX_A,ID_EX_B,EX_MEM_B,MEM_WB_ALU,MEM_WB_LMD;
    reg [31:0] ID_EX_IMM;
    reg [2:0] ID_EX_TYPE,EX_MEM_TYPE,MEM_WB_TYPE;
    reg [31:0] REG[0:63];

    
    parameter ADD = 6'b000000,SUB = 6'b000001,AND = 6'b000010,OR = 6'b000011,SLT = 6'b000100,
              MUL = 6'b000101, HLT = 6'b111111, LW = 6'b001000, SW = 6'b001001,ADDI = 6'b001010,
              SUBI = 6'b001011,SLTI = 6'b001100, BNEQZ = 6'b001101, BEQZ = 6'b001110;
    
    parameter RR_ALU = 3'b000, RM_ALU = 3'b001, LOAD = 3'b010 ,STORE = 3'b011, BRANCH = 3'b100,
              HALT = 3'b101;

    always @(posedge clk1) begin // instr Fetch
        if (HALTED == 0) begin
            if (((EX_MEM_IR[31:26] == BEQZ) && (EX_MEM_COND == 1)) 
                || ((EX_MEM_IR[31:26] == BNEQZ) && (EX_MEM_COND == 0))) 
                begin
                    IF_ID_IR <= mem[EX_MEM_ALU];
                    TAKEN_BRANCH <= 1'b1;
                    IF_ID_NPC <= EX_MEM_ALU +1;
                    PC <= EX_MEM_ALU +1;
                end
            else
                begin
                    IF_ID_IR <= mem[PC];
                    IF_ID_NPC <= PC + 1;
                    PC <= PC + 1;
                end
        end
    end

    always @(posedge clk2) begin // instr decode
        if (HALTED == 0) 
        begin
            if (IF_ID_IR[25:21] == 5'b00000) // this suggest rs is 00000 means rs is R0
            begin
                ID_EX_A <= 0; // AND R0 is always 0 permanently
            end
            else
            begin
                ID_EX_A <= REG[IF_ID_IR[25:21]]; //rs ID_EX_A contains the vlue of inside rs
            end // rs contains the base memory address
            
            if (IF_ID_IR[20:16] == 5'b00000) 
            begin
                ID_EX_B <= 0;
            end
            else
            begin
                ID_EX_B <= REG[IF_ID_IR[20:16]]; //rt
            end

            ID_EX_NPC <= IF_ID_NPC;
            ID_EX_IR <= IF_ID_IR;
            ID_EX_IMM <= {{16{IF_ID_IR[15]}},{IF_ID_IR[15:0]}};


            case (IF_ID_IR[31:26])
                ADD,SUB,AND,OR,SLT,MUL: ID_EX_TYPE <= RR_ALU;
                ADDI,SUBI,SLTI  : ID_EX_TYPE <= RM_ALU;
                LW  : ID_EX_TYPE <= LOAD;
                SW  : ID_EX_TYPE <= STORE;
                BEQZ,BNEQZ  : ID_EX_TYPE <= BRANCH;
                HLT  : ID_EX_TYPE <= HALT;
                default: ID_EX_TYPE <= HALT;
            endcase
        end
    end

    always @(posedge clk1) begin //EXECUTION
        if (HALTED == 0) begin
            EX_MEM_IR <= ID_EX_IR;
            EX_MEM_TYPE <= ID_EX_TYPE;

            case (ID_EX_TYPE)
                RR_ALU : 
                begin
                    case (ID_EX_IR[31:26])
                        ADD : EX_MEM_ALU <= ID_EX_A + ID_EX_B;
                        SUB : EX_MEM_ALU <= ID_EX_A - ID_EX_B;
                        AND : EX_MEM_ALU <= ID_EX_A & ID_EX_B;
                        OR : EX_MEM_ALU <= ID_EX_A | ID_EX_B;
                        SLT : EX_MEM_ALU <= ID_EX_A < ID_EX_B;
                        MUL : EX_MEM_ALU <= ID_EX_A * ID_EX_B;
                        default: EX_MEM_ALU <= 32'hxxxxxxxx;
                    endcase
                end

                RM_ALU : 
                begin
                    case (ID_EX_IR[31:26])
                        ADDI : EX_MEM_ALU <= ID_EX_A + ID_EX_IMM;
                        SUBI : EX_MEM_ALU <= ID_EX_A - ID_EX_IMM;
                        SLTI : EX_MEM_ALU <= ID_EX_A < ID_EX_IMM;
                        default: EX_MEM_ALU <= 32'hxxxxxxxx;
                    endcase
                end

                LOAD, STORE :
                begin
                    EX_MEM_ALU <= ID_EX_A + ID_EX_IMM;
                    EX_MEM_B <= ID_EX_B;
                end

                BRANCH :
                begin
                    EX_MEM_ALU <= ID_EX_NPC + ID_EX_IMM;
                    EX_MEM_COND <= (ID_EX_A == 0);
                end

                HALT :
                begin
                    HALTED <= 1'b1;
                end

            endcase
        end
    end

    always @(posedge clk2) begin // memory stage 
        if (HALTED == 0) begin
            MEM_WB_TYPE <= EX_MEM_TYPE;
            MEM_WB_IR <= EX_MEM_IR;


            case (EX_MEM_TYPE)
                RR_ALU,RM_ALU :
                begin
                    MEM_WB_ALU <= EX_MEM_ALU;
                end

                LOAD :
                begin
                    MEM_WB_LMD <= mem[EX_MEM_ALU];
                end

                STORE :
                begin
                    mem[EX_MEM_ALU] <= EX_MEM_B ;
                end
            endcase
        end
    end

    always @(posedge clk1) begin //WB stage
            case (MEM_WB_TYPE)
                RR_ALU : REG[MEM_WB_IR[15:11]] <= MEM_WB_ALU; 
                RM_ALU : REG[MEM_WB_IR[20:16]] <= MEM_WB_ALU; 
                LOAD : REG[MEM_WB_IR[20:16]] <= MEM_WB_LMD;
                HALT : HALTED <= 1'b1;
            endcase
    end
endmodule