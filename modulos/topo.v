module topo (
    input clk, rst;
);

// CUIDAR COM TIPOS REG E WIRE, MANTER REGS NOS FF`S APENAS

// sinais do IF
wire [31:0] branchOffset, inst;
wire zeroFlag, branchFlag, flush;

// Fetch
InstructionFetch IF (
    .clk(clk),
    .rst(rst),
    .branchOffset(branchOffset),
    .zeroFlag(zeroFlag),
    .branchFlag(branchFlag),   
    .inst(inst),
    .flush(flush)
);

// flip flop INST
reg [31:0] Instr;
always @ (posedge clk) Instr <= inst; // instrução no decode <= instrução no fetch

// Decode
wire [31:0] Ain, Bin, ImmExt;
wire [1:0] ResultSrc;
wire MemWrite, RegWrite, ALUSrc, Branch;
wire [2:0] ALUControl;

InstructionDecode ID (
    .clk(clk),
    .Instr(Instr), 
    .WB(WB),
    .Branch(Branch),
    .Ain(Ain), // FF A
    .Bin(Bin), // FF B
    .ImmExt(ImmExt), // FF IMM
    .ResultSrc(ResultSrc), // FF CTRL
    .MemWrite(MemWrite), // FF CTRL
    .RegWrite(RegWrite), // FF CTRL
    .ALUSrc(ALUSrc), // FF CTRL
    .ALUControl(ALUControl) // FF CTRL
);

// flip flops A, B e IMM
reg [31:0] A, B, IMM;
always @ (posedge clk) A <= Ain;
always @ (posedge clk) B <= Bin;
always @ (posedge clk) IMM <= ImmExt;

assign branchOffset = IMM;

// flip flop CTRL
reg [2:0] AC;
reg [1:0] RS;
reg BF, WEM, WER, AS;
always @ (posedge clk or posedge flush)
begin
    if (flush) 
    begin
        BF <= 0; // Branch, posteriormente se torna branchflag
        WER <= 0; // WriteEnable Register
        WEM <= 0; // WriteEnable Memory
    end
    else
    begin
        BF <= Branch;
        RS <= ResultSrc;
        WEM <= MemWrite;
        WER <= RegWrite;
        AS <= ALUSrc;
        AC <= ALUControl; 
    end
end

assign branchFlag = BF;

// resto da implementação

endmodule
