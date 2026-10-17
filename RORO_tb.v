`timescale 1ns/1ps
// Testbench de RORO (ROMa + ROMina + ALU). Las instrucciones se aplican
// directamente (sin ROM de instrucciones) y se comparan DD y ZF.
module RORO_tb;

reg  [11:0] instruccion;
wire [31:0] resultado;
wire        ZF;

reg [11:0] instr  [0:15];
reg [31:0] esp_dd [0:15];
reg        esp_zf [0:15];
integer i, errores;

RORO uut(.instruccion(instruccion), .resultado(resultado), .ZF(ZF));

initial begin
		instr[0] = {4'd2, 4'd0, 4'd0};
		instr[1] = {4'd2, 4'd1, 4'd1};
		instr[2] = {4'd2, 4'd2, 4'd2};
		instr[3] = {4'd2, 4'd3, 4'd3};
		instr[4] = {4'd2, 4'd4, 4'd4};
		instr[5] = {4'd2, 4'd5, 4'd5};
		instr[6] = {4'd6, 4'd6, 4'd6};
		instr[7] = {4'd6, 4'd7, 4'd7};
		instr[8] = {4'd6, 4'd8, 4'd8};
		instr[9] = {4'd6, 4'd9, 4'd9};
		instr[10] = {4'd6, 4'd10, 4'd10};
		instr[11] = {4'd6, 4'd11, 4'd11};
		instr[12] = {4'd7, 4'd12, 4'd12};
		instr[13] = {4'd7, 4'd13, 4'd13};
		instr[14] = {4'd7, 4'd14, 4'd14};
		instr[15] = {4'd7, 4'd15, 4'd15};
		esp_dd[0] = 32'd17; esp_zf[0] = 1'b0;
		esp_dd[1] = 32'd21; esp_zf[1] = 1'b0;
		esp_dd[2] = 32'd35; esp_zf[2] = 1'b0;
		esp_dd[3] = 32'd12; esp_zf[3] = 1'b0;
		esp_dd[4] = 32'd60; esp_zf[4] = 1'b0;
		esp_dd[5] = 32'd48; esp_zf[5] = 1'b0;
		esp_dd[6] = 32'd0; esp_zf[6] = 1'b1;
		esp_dd[7] = 32'd9; esp_zf[7] = 1'b0;
		esp_dd[8] = 32'd51; esp_zf[8] = 1'b0;
		esp_dd[9] = 32'd4294967255; esp_zf[9] = 1'b0;
		esp_dd[10] = 32'd97; esp_zf[10] = 1'b0;
		esp_dd[11] = 32'd0; esp_zf[11] = 1'b1;
		esp_dd[12] = 32'd0; esp_zf[12] = 1'b1;
		esp_dd[13] = 32'd0; esp_zf[13] = 1'b1;
		esp_dd[14] = 32'd1; esp_zf[14] = 1'b0;
		esp_dd[15] = 32'd0; esp_zf[15] = 1'b1;
	errores = 0;
	for (i = 0; i < 16; i = i + 1) begin
		instruccion = instr[i];
		#10;
		if (resultado === esp_dd[i] && ZF === esp_zf[i])
			$display("PASS caso %0d: instr=%b DD=%0d ZF=%b", i, instruccion, resultado, ZF);
		else begin
			$display("FAIL caso %0d: instr=%b DD=%0d (esp %0d) ZF=%b (esp %b)",
				i, instruccion, resultado, esp_dd[i], ZF, esp_zf[i]);
			errores = errores + 1;
		end
	end
	if (errores == 0) $display("RORO_tb: TODOS LOS CASOS PASARON (16/16)");
	else              $display("RORO_tb: %0d CASOS FALLARON", errores);
	$finish;
end

endmodule
