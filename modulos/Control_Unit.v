module Control_Unit (
  input [6:0] op,
  output [1:0]ResultSrc,
  output Branch,
  output MemWrite,
  output ALUSrc,
  output [1:0] ImmSrc,
  output RegWrite,
  input [2:0] funct3,
  input funct7,
  output [2:0] ALUControl
  // Ver novos sinais necessários, talvez seja interessante criar FPU_Decoder, a discutir
);


wire [1:0] ALUOp;

Main_Decoder maindecoder (
  .op(op),
  .Branch(Branch),
  .ResultSrc(ResultSrc),
  .MemWrite(MemWrite),
  .ALUSrc(ALUSrc),
  .ImmSrc(ImmSrc),
  .RegWrite(RegWrite),
  .ALUOp(ALUOp)
  // sinais referentes a fpu, incluindo seletor, we, seletor de muxes
);

ULA_Decoder uladecoder (
  .ALUOp(ALUOp),
  .op(op[5]),
  .funct3(funct3),
  .funct7(funct7),
  .ALUControl(ALUControl)
);

endmodule
