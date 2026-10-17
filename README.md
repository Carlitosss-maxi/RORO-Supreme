# RORO Supreme

**Arquitectura de Computadoras · Informática**
Integración de dos memorias ROM, una ALU MIPS y una ROM externa de instrucciones.

**Integrantes:** _(nombres del equipo)_ · **Organización GitHub:** _(enlace)_

## 1. Objetivo
Ejecutar una secuencia de 16 instrucciones de 12 bits (6 sumas, 6 restas y 4 SLT) reutilizando los módulos `ROM`, `MIPSALU` y `RORO` vistos en clase, y verificar `DD[31:0]` y `ZF` con testbenches PASS/FAIL.

## 2. Arquitectura
```
DirInst[3:0] -> ROM_Instrucciones (16x12) -> OP[11:8] | R1[7:4] | R2[3:0]
                                              R1 -> ROMa    (32b) -+
                                                                   +-> MIPSALU -> DD[31:0], ZF
                                              R2 -> ROMina  (32b) -+
                                              OP ----------------------^
```
La dirección de instrucción la maneja el testbench (no hay contador de programa).

## 3. Archivos
| Archivo | Descripción |
|---|---|
| `ROM.v` | ROM de datos 16x32, parametrizada con `ARCHIVO`, carga con `$readmemb` |
| `MIPSALU.v` | ALU de clase, **sin modificar** (en el enunciado aparece como ALUMIPS) |
| `RORO.v` | ROM + ROM + ALU |
| `ROM_Instrucciones.v` | ROM de 16 posiciones x 12 bits |
| `RORO_Supreme.v` | Módulo superior |
| `RORO_tb.v`, `RORO_Supreme_tb.v` | Testbenches con PASS/FAIL |
| `ROMa_init.txt`, `ROMina_init.txt`, `instrucciones.txt` | Inicialización (binario) |

## 4. Decisiones y justificación de cambios
- **Codificación de la ALU verificada** en `MIPSALU.v`: `0010` suma, `0110` resta, `0111` SLT (`A<B ? 1 : 0`, comparación sin signo). Coincide con el enunciado.
- **ROM.v modificada** (única modificación a un módulo de clase): la versión original tenía 9 posiciones y datos fijos en un `initial`. Se cambió a 16 posiciones y se parametrizó el archivo para que ROMa y ROMina tengan datos distintos. Los puertos (`DirL`, `Data`) no cambian. La dirección ya es de 4 bits, por lo que no hace falta extenderla con ceros; por eso los archivos de inicialización tienen 16 líneas (no 64).
- **RORO.v**: se agregaron parámetros para los archivos de cada ROM; la interfaz `instruccion/resultado/ZF` se conserva.
- **Programa**: la instrucción `i` usa `R1 = R2 = i`, de modo que cada una de las 16 direcciones de ROMa y ROMina se usa exactamente una vez.

## 5. Tabla de instrucciones
| Dir | Instrucción (bin) | OP | R1 | R2 | Operación | ROMa[R1] | ROMina[R2] | DD esperado | ZF |
|---|---|---|---|---|---|---|---|---|---|
| 0 | `0010_0000_0000` | 2 | 0 | 0 | ADD | 12 | 5 | 17 | 0 |
| 1 | `0010_0001_0001` | 2 | 1 | 1 | ADD | 7 | 14 | 21 | 0 |
| 2 | `0010_0010_0010` | 2 | 2 | 2 | ADD | 25 | 10 | 35 | 0 |
| 3 | `0010_0011_0011` | 2 | 3 | 3 | ADD | 3 | 9 | 12 | 0 |
| 4 | `0010_0100_0100` | 2 | 4 | 4 | ADD | 40 | 20 | 60 | 0 |
| 5 | `0010_0101_0101` | 2 | 5 | 5 | ADD | 18 | 30 | 48 | 0 |
| 6 | `0110_0110_0110` | 6 | 6 | 6 | SUB | 0 | 0 | 0 | 1 |
| 7 | `0110_0111_0111` | 6 | 7 | 7 | SUB | 15 | 6 | 9 | 0 |
| 8 | `0110_1000_1000` | 6 | 8 | 8 | SUB | 63 | 12 | 51 | 0 |
| 9 | `0110_1001_1001` | 6 | 9 | 9 | SUB | 9 | 50 | 4294967255 | 0 |
| 10 | `0110_1010_1010` | 6 | 10 | 10 | SUB | 100 | 3 | 97 | 0 |
| 11 | `0110_1011_1011` | 6 | 11 | 11 | SUB | 2 | 2 | 0 | 1 |
| 12 | `0111_1100_1100` | 7 | 12 | 12 | SLT | 31 | 31 | 0 | 1 |
| 13 | `0111_1101_1101` | 7 | 13 | 13 | SLT | 55 | 11 | 0 | 1 |
| 14 | `0111_1110_1110` | 7 | 14 | 14 | SLT | 8 | 16 | 1 | 0 |
| 15 | `0111_1111_1111` | 7 | 15 | 15 | SLT | 20 | 4 | 0 | 1 |

`ZF = 1` únicamente cuando `DD = 0`. En la dirección 9 el resultado negativo se interpreta como patrón de 32 bits en complemento a dos.

## 6. Casos explicados
**Resta negativa (dir 9):** `9 - 50 = -41`. En 32 bits, `-41 = 2^32 - 41 = 4294967255 = 0xFFFFFFD7`. La ALU resta con aritmética modular, así que `DD = 4294967255` y `ZF = 0` porque el patrón no es cero.

**ZF = 1 (dir 11):** `2 - 2 = 0`. `DD = 0` y `Zero = (ALUOut == 0)` vale 1. También ocurre en la dir 6 (`0 - 0`) y en los SLT falsos (dirs 12, 13 y 15), donde `DD = 0`.

## 7. Cómo simular
```bash
iverilog -o roro_tb RORO_tb.v RORO.v ROM.v MIPSALU.v && vvp roro_tb
iverilog -o supreme_tb RORO_Supreme_tb.v RORO_Supreme.v ROM_Instrucciones.v RORO.v ROM.v MIPSALU.v && vvp supreme_tb
```
Ejecutar desde la carpeta donde están los `.txt`.

## 8. Evidencia de simulación
Salida esperada de `RORO_Supreme_tb`:
```
PASS dir 0: DD=17 ZF=0
PASS dir 1: DD=21 ZF=0
PASS dir 2: DD=35 ZF=0
PASS dir 3: DD=12 ZF=0
PASS dir 4: DD=60 ZF=0
PASS dir 5: DD=48 ZF=0
PASS dir 6: DD=0 ZF=1
PASS dir 7: DD=9 ZF=0
PASS dir 8: DD=51 ZF=0
PASS dir 9: DD=4294967255 ZF=0
PASS dir 10: DD=97 ZF=0
PASS dir 11: DD=0 ZF=1
PASS dir 12: DD=0 ZF=1
PASS dir 13: DD=0 ZF=1
PASS dir 14: DD=1 ZF=0
PASS dir 15: DD=0 ZF=1
RORO_Supreme_tb: 16/16 PASS
```
> Reemplazar este bloque con la captura/log real de la simulación del equipo (y capturas de GTKWave).

## 9. Aportaciones del equipo
| Integrante | Commits / aportación |
|---|---|
| _(nombre)_ | _(descripción)_ |

## 10. Conclusiones
Toreando los detalles de la ROM original (9 posiciones y datos fijos) logramos reutilizar los módulos de clase con cambios mínimos. Toreando la interpretación de los resultados negativos como complemento a dos se entiende por qué `9 - 50` produce `4294967255`. Y Toreando cada caso de `ZF` se confirma que solo se activa cuando `DD = 0`.
