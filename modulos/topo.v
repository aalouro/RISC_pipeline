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
wire [31:0] FAin, FBin; // Wire de entrada dos registradores fA e fB
wire [4:0] selFPU;
wire RegWriteF;
wire MemSrc;
wire DSrc;

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
    .RegWriteF(RegWriteF) // FF CTRL (PRECISA INSTANCIAR O WIRE E FAZER O ROTEAMENTO POSTERIOR)
    .WEF(WEFWIRE2) // write enable para entrada do rf
    .selFPU(selFPU), // FF CTRL (PRECISA INSTANCIAR O WIRE E FAZER O ROTEAMENTO POSTERIOR)
    .MemSrc(MemSrc), // FF CTRL (PRECISA INSTANCIAR O WIRE E FAZER O ROTEAMENTO POSTERIOR)
    .DSrc(DSrc), // FF CTRL (PRECISA INSTANCIAR O WIRE E FAZER O ROTEAMENTO POSTERIOR)
    .ALUSrc(ALUSrc), // FF CTRL
    .ALUControl(ALUControl) // FF CTRL

);

// flip flops A, B, IMM, fA e fB
wire [31:0] Aout, Bout, FAout, FBout;
reg [31:0] A, B, IMM, FA, FB;
always @ (posedge clk) A <= Ain;
always @ (posedge clk) B <= Bin;
always @ (posedge clk) FA <= FAin;
always @ (posedge clk) FB <= FBin;
always @ (posedge clk) IMM <= ImmExt;

assign branchOffset = IMM;
assign Aout = A;
assign Bout = B;
assign FAout = FA;
assign FBout = FB;

// flip flop CTRL
reg [2:0] AC, F3;
reg [1:0] RS;
reg BF, WEM, WER, AS, MMS, MFAS, WERF; // mux mem sel e mux alu fpu sel
reg [4:0] II, FSEL;
wire [2:0] ACWIRE;
wire WEMWIRE, MMSWIRE, MFASWIRE, WERFWIRE;
wire [4:0] FSELWIRE;

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
        MMS <= MemSrc; // mux mem
        MFAS <= DSrc; // mux d
        WERF <= RegWriteF; // write enable F
        FSEL <= selFPU; // seletor fpu
    end
end

assign Branch = BF;
assign ASWIRE = AS;
assign ACWIRE = AC;
assign WEMWIRE = WEM;
assign F3WIRE = F3;
assign FSELWIRE = FSEL;
assign WERFWIRE = WERF;
assign MFASWIRE = MFAS;
assign MMSWIRE = MMS; 

wire [31:0] ReadData, ALUResult;
Execute_Memory EXMEM (
    .ImmExt(branchOffset),
    .WriteData(Bout),
    .SrcA(Aout),
    .SrcAF(FAout),
    .SrcBF(FBout),
    .MemSrc(MMSWIRE),
    .DSrc(MFASWIRE)
    .selFPU(FSELWIRE)
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
reg WER2, WEF2;
always @ (posedge clk)
begin
        RS2 <= RS;
        WER2 <= WER;
        II2 <= II;
        WEF2 <= WERFWIRE;
end

assign RSWIRE = RS2; // seletor mux
assign WER2WIRE = WER2; // write enable do register file
assign WA = II2;
assign WEFWIRE2 = WEF2;

mux2x1_32bits muxout (
  .inA(ALURWIRE),
  .inB(MRWIRE),
  .sel(RSWIRE),
  .out(WB)
);
endmodule
