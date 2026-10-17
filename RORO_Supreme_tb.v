`timescale 1ns/1ps
// Testbench del sistema completo: recorre las 16 direcciones de instruccion.
module RORO_Supreme_tb;

reg  [3:0]  DirInst;
wire [31:0] DD;
wire        ZF;

reg [31:0] esp_dd [0:15];
reg        esp_zf [0:15];
integer i, errores;

RORO_Supreme uut(.DirInst(DirInst), .DD(DD), .ZF(ZF));

initial begin
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
		DirInst = i[3:0];
		#10;
		if (DD === esp_dd[i] && ZF === esp_zf[i])
			$display("PASS dir %0d: DD=%0d ZF=%b", i, DD, ZF);
		else begin
			$display("FAIL dir %0d: DD=%0d (esp %0d) ZF=%b (esp %b)",
				i, DD, esp_dd[i], ZF, esp_zf[i]);
			errores = errores + 1;
		end
	end
	if (errores == 0) $display("RORO_Supreme_tb: 16/16 PASS");
	else              $display("RORO_Supreme_tb: %0d FAIL", errores);
	$finish;
end

endmodule
