module FPU_Decoder(
    input [4:0] funct5,
    input [2:0] rm,
    output reg [4:0] sel
);

wire [7:0] opR;
assign opR = {funct5, rm};

always @ (*)
begin
    casex(op)
        8'b00000_xxx: sel = 4; // Soma
        8'b00001_xxx: sel = 5; // Subtração
        8'b00010_xxx: sel = 6; // Multiplicação
        8'b00101_000: sel = 7; // Min
        8'b00101_001: sel = 8; // Max
        8'b10100_010: sel = 9; // Eq
        8'b10100_001: sel = 10; // Lt
        8'b10100_000: sel = 11; // Le

        8'b11110_xxx: sel = 12; // Mv s-r 
        8'b11100_000: sel = 13; // Mv r-s
        // confirmar como as mv serão feitas para alterar o registrador e salvar no correto
        
        8'b11010_xxx: sel = 14; // cvt s-w

        // cvt w-s tem op code diferente, sabosta. Ver o que pode ser feito
    endcase
end

endmodule
