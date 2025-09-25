module Execute_Memory (
  input [31:0] ImmExt,
  input [31:0] WriteData,
  input [31:0] SrcA,
  input [2:0] ALUControl,
  input MemWrite,
  input clk,
  input ALUSrc,
  output zero,
  output [31:0] ReadData,
  output [31:0] ALUResult,
  output [31:0] ReadData,
  output [31:0] ALUResult
);

  wire [31:0] SrcB;
  

  mux2x1_32bits muxin (
    .inA(WriteData),
    .inB(ImmExt),
    .sel(ALUSrc),
    .out(SrcB)
  );

  ALU alu (
    .A(SrcA),
    .B(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(zero)
  );

  data_memory dmemory (
    .clk(clk),
    .A(ALUResult),
    .WD(WriteData),
    .WE(MemWrite),
    .RD(ReadData)
  );
    
endmodule
