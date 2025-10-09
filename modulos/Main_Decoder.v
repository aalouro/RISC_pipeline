module Main_Decoder (
    input [6:0] op,
    output reg Branch,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg RegWrite,
    output reg [1:0] ALUOp
    );

always @ (*)
begin
    casex (op)
        7'b0000011: begin //lw
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 2'b01;
            Branch = 0;
            ALUOp = 2'b00;
        end
        7'b0100011: begin //sw
            RegWrite = 0;
            ImmSrc = 2'b01;
            ALUSrc = 1;
            MemWrite = 1;
            ResultSrc = 2'bx;
            Branch = 0;
            ALUOp = 2'b00;
        end
        7'b0110011: begin //r-type
            RegWrite = 1;
            ImmSrc = 2'bxx;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 2'b00;
            Branch = 0;
            ALUOp = 2'b10;
        end
        7'b1100011: begin //beq
            RegWrite = 0;
            ImmSrc = 2'b10;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 2'bxx;
            Branch = 1;
            ALUOp = 2'b01;
        end
        7'b0010011: begin // I-type
            RegWrite = 1'b1;
            ImmSrc = 2'b00; // Immediate source
            ALUSrc = 1'b1; // ALU source is immediate
            MemWrite = 1'b0; // No memory write
            ResultSrc = 2'b00; // Result comes from ALU
            Branch = 0; // No branching
            ALUOp = 2'b10; // ALU operation for I-type instructions
        end

        default: begin
            RegWrite = 0;
            ImmSrc = 2'bxx;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 1'bx;
            Branch = 0;
            ALUOp = 2'b00;
        end
    endcase
end
endmodule