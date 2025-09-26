module InstructionDecode (
    input clk,
    input [31:0] Instr, WB,
    output [31:0] Ain, Bin, ImmExt,
    // outputs do controle
    output [1:0] ResultSrc, // passivel de mudança por conta do jal, teoricamente não entra em estados não previstos
    output MemWrite,
    output RegWrite,
    output Branch
    output ALUSrc,
    output [2:0] ALUControl
);

wire [1:0] ImmSrc;

Control_Unit control (
  .op(Instr[6:0]),
  .ResultSrc(ResultSrc), //out
  .MemWrite(MemWrite),//out
  .ALUSrc(ALUSrc),//out
  .ImmSrc(ImmSrc),//wire para outro módulo do mesmo estado
  .RegWrite(RegWrite),//out (vai retornar, mas precisa estar no ciclo de clock correto, por isso vai para frente, apesar de register file estar no mesmo estágio)
  .funct3(Instr[14:12]),
  .funct7(Instr[30]),
  .Branch(Branch), // falgBranch
  .ALUControl(ALUControl)//out
);

register_file rf (
    .clk(clk),
    .A1(Instr[19:15]), // endereço de leitura A
    .A2(Instr[24:20]), // endereço de leitura B
    .A3(Instr[11:7]), // endereço de escrita
    .WD3(WB), // dado de escrita
    .RD1(Ain), // dado de leitura A
    .RD2(Bin), // dado de leitura B
    .WE(RegWrite) // write enable
);

SignExtend signextend (
    .in(Instr[31:7]), // vem da instrução
    .ImmSrc(ImmSrc), // vem da unidade de controle
    .out(ImmExt) // vai para o próximo estágio
  );

endmodule
