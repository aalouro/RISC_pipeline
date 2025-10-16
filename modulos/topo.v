module topo (
    input clk, rst
);

// CUIDAR COM TIPOS REG E WIRE, MANTER REGS NOS FF`S APENAS
// ALTERAÇÕES PARA UTILIZAÇÃO DA FPU INCOMPLETOS, NÃO VAI FUNCIONAR

// sinais do IF
wire [31:0] branchOffset, inst, WB;
wire zeroFlag, branchFlag, flush, Branch;
wire RSWIRE; // seletor mux
wire WER2WIRE; // write enable do register file
wire [4:0] WA;
// Fetch
InstructionFetch IF (
    .clk(clk),
    .rst(rst),
    .branchOffset(branchOffset),
    .zeroFlag(zeroFlag),
    .branchFlag(Branch),   
    .inst(inst),
    .flush(flush)
);

// flip flop INST
reg [31:0] Instr;
always @ (posedge clk) Instr <= inst; // instrução no decode <= instrução no fetch

// Decode
wire [31:0] Ain, Bin, ImmExt;
wire [1:0] ResultSrc;
wire MemWrite, RegWrite, ALUSrc;
wire [2:0] ALUControl;
wire [2:0]F3WIRE;
wire [31:0] FAin, FBin;

InstructionDecode ID (
    .clk(clk),
    .Instr(Instr), 
    .WB(WB),
    .WA(WA),
    .WE(WER2WIRE),
    .Branch(branchFlag),
    .Ain(Ain), // FF A
    .Bin(Bin), // FF B
    .floatRegisterAin(FAin), //FF fA
    .floatRegisterBin(FBin), // FF fb
    .ImmExt(ImmExt), // FF IMM
    .ResultSrc(ResultSrc), // FF CTRL
    .MemWrite(MemWrite), // FF CTRL
    .RegWrite(RegWrite), // FF CTRL
    //.RegWriteF(RegWriteF)
    .ALUSrc(ALUSrc), // FF CTRL
    .ALUControl(ALUControl) // FF CTRL

);

// flip flops A, B, IMM, fA e fB
wire [31:0] Aout, Bout;
reg [31:0] A, B, IMM, FA, FB;
always @ (posedge clk) A <= Ain;
always @ (posedge clk) B <= Bin;
always @ (posedge clk) FA <= FAin;
always @ (posedge clk) FB <= FBin;
always @ (posedge clk) IMM <= ImmExt;

assign branchOffset = IMM;
assign Aout = A;
assign Bout = B;

// flip flop CTRL
reg [2:0] AC, F3;
reg [1:0] RS;
reg BF, WEM, WER, AS;
reg [4:0] II;
wire [2:0] ACWIRE;
wire WEMWIRE;
always @ (posedge clk)
begin

    if (flush) 
    begin
        BF <= 0; // Branch, posteriormente se torna branchflag
        WER <= 0; // WriteEnable Register
        WEM <= 0; // WriteEnable Memory
    end
    else
    begin
        BF <= branchFlag; 
        RS <= ResultSrc;
        WEM <= MemWrite;
        WER <= RegWrite;
        AS <= ALUSrc;
        AC <= ALUControl;
        II <= Instr[11:7];
        F3 <= Instr[14:12];
    end
end

assign Branch = BF;
assign ASWIRE = AS;
assign ACWIRE = AC;
assign WEMWIRE = WEM;
assign F3WIRE = F3;

wire [31:0] ReadData, ALUResult;
Execute_Memory EXMEM (
    .ImmExt(branchOffset),
    .WriteData(Bout),
    .SrcA(Aout),
    .ALUControl(ACWIRE),
    .MemWrite(WEMWIRE),
    .clk(clk),
    .ALUSrc(ASWIRE),
    .zero(zeroFlag),
    .ReadData(ReadData),
    .ALUResult(ALUResult),
    .funct3(F3WIRE)
);

// flip flops D e M
reg [31:0] ALUR;
reg [31:0] MR;
always @ (posedge clk) ALUR <= ALUResult; // ALU Result do estágio MEM/WB
always @ (posedge clk) MR <= ReadData; // Memory Result do estágio MEM/WB
wire [31:0] ALURWIRE, MRWIRE;
assign ALURWIRE = ALUR;
assign MRWIRE = MR;

// flip flop controle
reg [31:0] RS2; // Ver se é necessario tantos bits, aparentemente são necessários apenas 2
reg [4:0] II2;
reg WER2;
always @ (posedge clk)
begin
        RS2 <= RS;
        WER2 <= WER;
        II2 <= II;
end

assign RSWIRE = RS2; // seletor mux
assign WER2WIRE = WER2; // write enable do register file
assign WA = II2;

mux2x1_32bits muxout (
  .inA(ALURWIRE),
  .inB(MRWIRE),
  .sel(RSWIRE),
  .out(WB)
);
endmodule
