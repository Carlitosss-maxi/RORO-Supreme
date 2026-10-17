// ROM de instrucciones: 16 posiciones x 12 bits.
// Formato: OP[11:8] | R1[7:4] | R2[3:0]
module ROM_Instrucciones #(
	parameter ARCHIVO = "instrucciones.txt"
)(
	input  [3:0]  Dir,
	output [11:0] Instruccion
);

reg [11:0] irom [0:15];

assign Instruccion = irom[Dir];

initial
begin
	$readmemb(ARCHIVO, irom);
end

endmodule
