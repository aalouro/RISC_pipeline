module Execute_Memory (
  input [31:0] ImmExt,
  input [31:0] WriteData,
  input [31:0] SrcA,
  input [2:0] ALUControl,
  input [2:0] funct3,
  input MemWrite,
  input clk,
  input ALUSrc,
  output zero,
  output [31:0] ReadData,
  output [31:0] ALUResult
);

  wire [31:0] SrcB;
  wire [5:0] deslocado;
  
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

/*  data_memory dmemory (
    .clk(clk),
    .A(ALUResult),
    .WD(WriteData),
    .WE(MemWrite),
    .RD(ReadData)
  );
*/
assign deslocado = (funct3[1] != 1'b1) ? (ALUResult << 2) : ((ALUResult <<2 ) - 4 );

  memTopo32LittleEndian dmemory (
    .clk(clk),
    .size(funct3[1:0]),
    .addr(deslocado),
    .din(WriteData),
    .sign_ext(funct3[2]),
    .writeEnable(MemWrite),
    .dout(ReadData)
  );
    
endmodule