`include "codigos/TP_ISL2.v"

module testbench;

    reg [3:0] entrada;
    reg reset;
    wire ready;
    wire [4:0] saida;
    wire [6:0] sDisplay;
    //Modulo ready, funciona como um clock, apenas para fins de teste
    readyclk rd(.ready(ready));
    //Modulo codificador
    CaesarEncoder Codificador (.ready(ready), .reset(reset), .a(entrada[3]), .b(entrada[2]), .c(entrada[1]), .d(entrada[0]), .S0(saida[0]), .S1(saida[1]), .S2(saida[2]), .S3(saida[3]), .S4(saida[4]));
    display display1(.S4(saida[4]), .S3(saida[3]), .S2(saida[2]), .S1(saida[1]), .S0(saida[0]), .c0(sDisplay[0]), .c1(sDisplay[1]), .c2(sDisplay[2]), .c3(sDisplay[3]), .c4(sDisplay[4]), .c5(sDisplay[5]), .c6(sDisplay[6]));

    initial begin
        
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
        $monitor("Entrada:\n%1b %1b %1b %1b\nSaida:\n%1b %1b %1b %1b %1b\nDisplay:\n%1b %1b %1b %1b %1b %1b %1b\n", entrada[3], entrada[2], entrada[1], entrada[0], saida[4], saida[3], saida[2], saida[1], saida[0], sDisplay[0], sDisplay[1], sDisplay[2], sDisplay[3], sDisplay[4], sDisplay[5], sDisplay[6]);
        #0 reset = 1'b0;
        #0 entrada = 4'b0000;
        #5 entrada = 4'b0001;
        #5 entrada = 4'b0010;
        #5 entrada = 4'b0011;
        #5 entrada = 4'b0100;
        #5 entrada = 4'b0101;
        #5 entrada = 4'b0110;
        #5 entrada = 4'b0111;
        #5 entrada = 4'b1000;
        #5 entrada = 4'b1001;
        #1 reset = 1'b1;
        #1 reset = 1'b0;

        #2 $finish;
        end



endmodule
