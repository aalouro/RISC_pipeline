module Main_Decoder (
    input [6:0] op,
    output reg Branch,
    output reg [1:0] ResultSrc, // mux de WB, um bit a mais por conta do jal
    output reg MemWrite,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg RegWriteF, // WE RFF
    output reg MemSrc, // Seletor mux da memória
    output reg DSrc // Seletor mux da saída ULA/FPU
    );

always @ (*)
begin
    // Ver tabela com códigos das novas instruções
    casex (op)
        7'b0000011: begin //lw
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 2'b01;
            Branch = 0;
            ALUOp = 2'b00;
            // referente a FPU
            RegWriteF = 0;
            MemSrc = 0;
            DSrc = 0;
        end
        7'b0100011: begin //sw
            RegWrite = 0;
            ImmSrc = 2'b01;
            ALUSrc = 1;
            MemWrite = 1;
            ResultSrc = 2'bx;
            Branch = 0;
            ALUOp = 2'b00;
            // referente a FPU
            RegWriteF = 0;
            MemSrc = 0;
            DSrc = 0;
        end
        7'b0110011: begin //r-type
            RegWrite = 1;
            ImmSrc = 2'bxx;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 2'b00;
            Branch = 0;
            ALUOp = 2'b10;
            // referente a FPU
            RegWriteF = 0;
            MemSrc = 0;
            DSrc = 0;
        end
        7'b1100011: begin //beq
            RegWrite = 0;
            ImmSrc = 2'b10;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 2'bxx;
            Branch = 1;
            ALUOp = 2'b01;
            // referente a FPU
            RegWriteF = 0;
            MemSrc = 0;
            DSrc = 0;
        end
        7'b0010011: begin // I-type
            RegWrite = 1'b1;
            ImmSrc = 2'b00; // Immediate source
            ALUSrc = 1'b1; // ALU source is immediate
            MemWrite = 1'b0; // No memory write
            ResultSrc = 2'b00; // Result comes from ALU
            Branch = 0; // No branching
            ALUOp = 2'b10; // ALU operation for I-type instructions
            // referente a FPU
            RegWriteF = 0;
            MemSrc = 0;
            DSrc = 0;
        end

        // SEÇÃO DE INSTRUCÕES F (OLHAR QUAIS SÃO OS SINAIS)
        7'b0000111: begin // flw 
        // mux de saída precisa selecionar a FPU
            RegWrite = 0;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 2'b01;
            Branch = 0;
            ALUOp = 2'b00;

            RegWriteF = 1;
            MemSrc = 1;
            DSrc = 1;
        end
        
        7'b0100111: begin //fsw
        // mux da memória precisa selecionar a FPU
            RegWrite = 0;
            ImmSrc = 2'b01;
            ALUSrc = 1;
            MemWrite = 1;
            ResultSrc = 2'bx;
            Branch = 0;
            ALUOp = 2'b00;

            RegWriteF = 0;
            MemSrc = 1;
            DSrc = 1;
        
        end

        7'b1010011: begin // Tipo fp (Análogo ao R)
            RegWrite = 0;
            ImmSrc = 2'bxx; // Indiferente. Imediato não utilizado
            ALUSrc = 1'bx; // Indiferente. ULA não utilizada
            MemWrite = 0; // Não há necessidade de escrever na memória
            ResultSrc = 2'b00; // Resultado vem do conjunto FPU/ULA
            Branch = 0;
            ALUOp = 2'b00; // Indiferente. ULA não utilizada

            RegWriteF = 1; // Escreve o resultado no registrador F
            MemSrc = 1'bx; // Memória não utilizada
            DSrc = 1;
        end
        
        default: begin
            RegWrite = 0;
            ImmSrc = 2'bxx;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 1'bx;
            Branch = 0;
            ALUOp = 2'b00;
            RegWriteF = 0;
        end
    endcase
end
endmodule
