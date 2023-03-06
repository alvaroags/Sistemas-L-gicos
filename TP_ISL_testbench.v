`include "TP_ISL2.v"

module testbench; //Módulo criado para realizarmos testes com o modulo CaesarEncoder, alertando as saídas e o resultado do display de 7 segmentos(quais dos segmentos acendem ou apagam)

    reg [3:0] entrada; //Cria um conjunto de 4 bits, responsável por armazenar a entrada
    reg reset; //Sinal de controle para voltar o módulo ao estado inicial
    wire ready; //Sinal de controle para representar que a entrada já está pronta para ser codificada.
    wire [4:0] saida; //Cria um conjunto de 5 bits, responsável por armazenar a saída
    wire [6:0] sDisplay; //Cria um conjunto de 7 bits, responsável por armazenar o valor em bit de cada segmento do display
    //Modulo ready, funciona como um clock, apenas para fins de teste
    readyclk rd(.ready(ready)); //Chama o módulo readyclk, responsável por alterar os valores da variável ready repetidamente
    //Modulo codificador
    CaesarEncoder Codificador (.ready(ready), .reset(reset), .a(entrada[3]), .b(entrada[2]), .c(entrada[1]), .d(entrada[0]), .S0(saida[0]), .S1(saida[1]), .S2(saida[2]), .S3(saida[3]), .S4(saida[4]));
    display display1(.S4(saida[4]), .S3(saida[3]), .S2(saida[2]), .S1(saida[1]), .S0(saida[0]), .c0(sDisplay[0]), .c1(sDisplay[1]), .c2(sDisplay[2]), .c3(sDisplay[3]), .c4(sDisplay[4]), .c5(sDisplay[5]), .c6(sDisplay[6]));

    initial begin
        
        $dumpfile("testbench.vcd"); //Responsável por gerar o arquivo vcd, para visualizarmos as ondas
        $dumpvars(0, testbench);
        $monitor("Entrada:\n%1b %1b %1b %1b\nSaida:\n%1b %1b %1b %1b %1b\nDisplay:\n%1b %1b %1b %1b %1b %1b %1b\n", entrada[3], entrada[2], entrada[1], entrada[0], saida[4], saida[3], saida[2], saida[1], saida[0], sDisplay[0], sDisplay[1], sDisplay[2], sDisplay[3], sDisplay[4], sDisplay[5], sDisplay[6]); //Responsável por imprimir no console os dados de entrada e saída a cada atualização nas entradas
        #0 reset = 1'b0; //Inicia a variável reset como 0
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
        #1 reset = 1'b0; //Finaliza a variavel reset como 0

        #2 $finish; 
        end



endmodule
