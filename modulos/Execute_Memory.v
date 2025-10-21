module Execute_Memory (
  input [31:0] ImmExt,
  input [31:0] WriteData,
  input [31:0] SrcA,
  input MemSrc,
  input DSrc,
  // instanciar duas entradas da FPU (A e B)
  // instanciar também o select da FPU
  // instanciar dois controles de muxes de 1 bit
  input [2:0] ALUControl,
  input [2:0] funct3,
  input MemWrite,
  input clk,
  input ALUSrc,
  output zero, // Ver se existe este sinal para FPU
  output [31:0] ReadData,
);

// MÓDULO INCOMPLETO, FALTA A FPU E SEUS SINAIS, ALÉM DE COMPLETAR MUXES

  wire [31:0] SrcB, ALUResult, FPUResult;
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

  FPU fpu (

  );

  mux2x1_32bits muxin ( // mux de entrada para a memória
    .inA(InBFPU), // entrada B da FPU
    .inB(WriteData),
    .sel(MemSrc),
    .out()
  );

  mux2x1_32bits muxin ( // mux para saída da AUL/FPU
    .inA(ALUResult),
    .inB(FPUResult),
    .sel(DSrc),
    .out()
  );
// instanciar dois muxes, um para a entrada da memória (decide se pega o dado de B ou fB), outro para a saida até o ff D (Decide se o dado vem da ULA ou FPU)
// instanciar FPU com entrada dos novos sinais de input

// em análise diagonal, 4 wires de 32 bits novos serão utilizados(para entrada e saída dos muxes), ver quais no esquemático

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
