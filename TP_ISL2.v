module CaesarEncoder(ready, reset, a, b, c, d, S0, S1, S2, S3, S4); //modulo principal, responsavel por realizar as conversoes da entrada de 4 bits e retornar a respectiva saida de 5 bits

    //Declaração das entradas e saídas
    input a, b, c, d, ready, reset;
    output reg S0, S1, S2, S3, S4;
    //Quando é detectada uma borda de subida do sinal reset as saidas são redefinidas para o estado inicial, x
    always @(posedge reset) begin
        S0 <= 1'bx;
        S1 <= 1'bx;
        S2 <= 1'bx;
        S3 <= 1'bx;
        S4 <= 1'bx;
    end
    //Quando é detectada uma borda de subida do sinal ready o modulo executa a logica e altera os sinais da saida para os valores correspondentes
    always @(posedge ready) begin

    //Funcionamento do circuito
        if (a && (b || c)) begin //Caso essa equação booleana retornar verdadeiro, a entrada de 4 bits é maior ou igual a 10 quando convertida em decimal, ou seja, inválida, portanto a saída de 5 bits deve ser indeterminada, ou seja, x para cada bit
            S0 <= 1'bx;
            S1 <= 1'bx;
            S2 <= 1'bx;
            S3 <= 1'bx;
            S4 <= 1'bx;
        end else begin //Caso a entrada de 4 bits seja válida, atribui os devidos valores para cada bit de saída
            S0 <= ~b & (~c | ~d);
            S1 <= (~b & ~c) | (b & c & d);
            S2 <= a | (b & c) | (~b & ~c & ~d);
            S3 <= a | (b & d) | (b & c);
            S4 <= b | (a & ~d);
        end

    end

endmodule

module display(S4, S3, S2, S1, S0, c0, c1, c2, c3, c4, c5, c6); //Módulo responsável para determinar quais dos segmentos do Display de 7 segmentos vão acender ou apagar, dependendo da entrada de 5 bits. Como são 7 segmentos, serão 7 saídas.

    input S0, S1, S2, S3, S4; //Entradas
    output c0, c1, c2, c3, c4, c5, c6; //Saídas
    //Equações booleanas para definir cada saída
    assign c0 = (~S4 | S0 | (S3 & S1));
    assign c1 = (~S3 | ~S0);
    assign c2 = (~S3 | S2);
    assign c3 = (S3 & ~S1) | (S3 & S0) | (~S2 & S1) | (~S4 & ~S0);
    assign c4 = (~S4 & ~S0) | (~S2 & S1) | (~S4 & S3) | (S3 & ~S2);
    assign c5 = (S3 & S1) | (~S4 & ~S2);
    assign c6 = S3 | (~S2 & S0);


endmodule

//Gerador de pulsos para o ready, apenas para fins de teste

module readyclk(ready); //Módulo responsável por alterar os valores da variável ready repetidamente

    output reg ready;
    always begin
        #2 ready = 1'b0; //Altera o valor de ready para 0
        #2 ready = 1'b1; //Altera o valor de ready para 1 
    end

endmodule