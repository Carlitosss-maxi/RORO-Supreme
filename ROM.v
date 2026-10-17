// ROM de datos: 16 posiciones x 32 bits, cargada desde archivo con $readmemb.
// Modificacion justificada respecto a la ROM original de clase: el contenido
// ya no esta fijo en un initial; se parametriza el archivo (ARCHIVO) para poder
// tener ROMa y ROMina con datos distintos. Puertos y funcionalidad se conservan.
module ROM #(
	parameter ARCHIVO = "ROMa_init.txt"
)(
	input  [3:0]  DirL,
	output [31:0] Data
);

reg [31:0] srom [0:15];

assign Data = srom[DirL];

initial
begin
	$readmemb(ARCHIVO, srom);
end

endmodule
