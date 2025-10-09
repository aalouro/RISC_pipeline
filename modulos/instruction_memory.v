module instruction_memory (
    input [31:0] A, // Endereço
    output reg [31:0] RD // Barramento de elitura de dados
);

reg [31:0] instruction [0:63]; // 32 espaços de instrução de 32 bits cada
wire [29:0] aux;
assign aux = A [31:2];

//espaços de memória para teste inicial    
initial begin
    /*
    ex2
    instruction[0] = 32'h00a00293; //0 addi
    instruction[1] = 32'h00000313; //4 addi
    instruction[2] = 32'h00000393; //8 addi
    instruction[3] = 32'h00000013; //12 nop
    instruction[4] = 32'h00028c63; //16 beq
    instruction[5] = 32'h0003ae03; //20 lw
    instruction[6] = 32'h00000013; //24 nop
    instruction[7] = 32'h00000013; //28 nop
    instruction[8] = 32'h01c30333; //32 add
    instruction[9] = 32'h00438393; //36 addi
    instruction[10] = 32'hfff28293; //40 addi
    instruction[11] = 32'hfc000ce3; //44 beq
    instruction[12] = 32'h00000013; //48
    instruction[13] = 32'h00000013; //52
    instruction [14] = 32'hfc0000e3; //56 //60 //64
    
    teste
    instruction [0] = 32'h0ef00093;
    instruction [1] = 32'h17c00113;
    instruction [2] = 32'h0de00193;
    instruction [3] = 32'h00000013;
    instruction [4] = 32'h00000013;
    instruction [5] = 32'h00210133;
    instruction [6] = 32'h003181b3;
    instruction [7] = 32'h00000013;
    instruction [8] = 32'h00000013;
    instruction [9] = 32'h003181b3;
    instruction [10] = 32'h00000013;
    instruction [11] = 32'h00000013;
    instruction [12] = 32'h003181b3;
    instruction [13] = 32'h00000013;
    instruction [14] = 32'h00000013;
    instruction [15] = 32'h003181b3;
    instruction [16] = 32'h00000013;
    instruction [17] = 32'h00000013;
    instruction [18] = 32'h003181b3;
    instruction [19] = 32'h00000013;
    instruction [20] = 32'h00000013;
    instruction [21] = 32'h003181b3;
    instruction [22] = 32'h003181b3;
    instruction [23] = 32'h00000013;
    instruction [24] = 32'h00000013;
    instruction [25] = 32'h003181b3;
    instruction [26] = 32'h00000013;
    instruction [27] = 32'h00000013;
    instruction [28] = 32'h003181b3;
    instruction [29] = 32'h00000013;
    instruction [30] = 32'h00000013;
    instruction [31] = 32'h003181b3;
    instruction [32] = 32'h00000013;
    instruction [33] = 32'h00000013;
    instruction [34] = 32'h003181b3;
    instruction [35] = 32'h00000013;
    instruction [36] = 32'h00000013;
    instruction [37] = 32'h003181b3;
    instruction [38] = 32'h003181b3;
    instruction [39] = 32'h00000013;
    instruction [40] = 32'h00000013;
    instruction [41] = 32'h003181b3;
    instruction [42] = 32'h00000013;
    instruction [43] = 32'h00000013;
    instruction [44] = 32'h003181b3;
    instruction [45] = 32'h00000013;
    instruction [46] = 32'h00000013;
    instruction [47] = 32'h003181b3;
    instruction [48] = 32'h00100023;
    instruction [49] = 32'h00201223;
    instruction [50] = 32'h00302423;
    instruction [51] = 32'h00000013;
    instruction [52] = 32'h00000503;
    instruction [53] = 32'h00004583;
    instruction [54] = 32'h00401603;
    instruction [55] = 32'h00405683;
    instruction [56] = 32'h00802703;
    instruction [57] = 32'h00300623;
    instruction [58] = 32'h00301823;
    instruction [59] = 32'h00000013;
    instruction [60] = 32'h00c00503;
    instruction [61] = 32'h00c04583;
    instruction [62] = 32'h01001603;
    instruction [63] = 32'h01005683;*/
    
    //ex5

    instruction [0] = 32'h00000293;
    instruction [2] = 32'h01000313;
    instruction [3] = 32'h00028383;
    instruction [4] = 32'h0002ce03;
    instruction [5] = 32'h00229e83;
    instruction [6] = 32'h00229e83;
    instruction [7] = 32'h0022df03;
    instruction [8] = 32'h0042af83;
    instruction [9] = 32'h00730023;
    instruction [10] = 32'h01c300a3;
    instruction [11] = 32'h01d31123;
    instruction [12] = 32'h01e31223;
    instruction [13] = 32'h01f32423;
    instruction [14] = 32'h07f00393;
    instruction [15] = 32'h00730623;
    instruction [16] = 32'hffe00e13;
    instruction [17] = 32'h01c31723;
    instruction [18] = 32'hfa0008e3;

end
always @ (*)
begin
    RD = instruction[aux]; // Saída recebe a instrução alinhada
end
endmodule