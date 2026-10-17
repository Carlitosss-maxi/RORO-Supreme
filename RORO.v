// RORO: ROM (ROMa) + ROM (ROMina) + ALU MIPS.
// instruccion = OP[11:8] | R1[7:4] | R2[3:0]
module RORO #(
	parameter ARCHIVO_A = "ROMa_init.txt",
	parameter ARCHIVO_B = "ROMina_init.txt"
)(
	input  [11:0] instruccion,
	output [31:0] resultado,
	output        ZF
);

wire [31:0] c1, c2;

ROM #(.ARCHIVO(ARCHIVO_A)) Roma(
	.DirL(instruccion[7:4]),
	.Data(c1)
);

ROM #(.ARCHIVO(ARCHIVO_B)) Romina(
	.DirL(instruccion[3:0]),
	.Data(c2)
);

MIPSALU Pablo(
	.ALUctl(instruccion[11:8]),
	.A(c1),
	.B(c2),
	.ALUOut(resultado),
	.Zero(ZF)
);

endmodule
