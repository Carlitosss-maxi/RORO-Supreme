// RORO Supreme: ROM de instrucciones + RORO (ROMa + ROMina + ALU).
// La direccion de instruccion la controla el testbench (sin contador de programa).
module RORO_Supreme(
	input  [3:0]  DirInst,
	output [31:0] DD,
	output        ZF
);

wire [11:0] instruccion;

ROM_Instrucciones IROM(
	.Dir(DirInst),
	.Instruccion(instruccion)
);

RORO nucleo(
	.instruccion(instruccion),
	.resultado(DD),
	.ZF(ZF)
);

endmodule
