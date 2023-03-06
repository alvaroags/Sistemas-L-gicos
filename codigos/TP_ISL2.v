module CaesarEncoder(ready, reset, a, b, c, d, S0, S1, S2, S3, S4);

    //Declaração das entradas e saídas
    input a, b, c, d, ready, reset;
    output reg S0, S1, S2, S3, S4;
    //Quando é detectada uma borda de subida do sinal reset as saidas são redefinidas para o estado inicial
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
        if (a && (b || c)) begin
            S0 <= 1'bx;
            S1 <= 1'bx;
            S2 <= 1'bx;
            S3 <= 1'bx;
            S4 <= 1'bx;
        end else begin
            S0 <= ~b & (~c | ~d);
            S1 <= (~b & ~c) | (b & c & d);
            S2 <= a | (b & c) | (~b & ~c & ~d);
            S3 <= a | (b & d) | (b & c);
            S4 <= b | (a & ~d);
        end

    end

endmodule

module display(S4, S3, S2, S1, S0, c0, c1, c2, c3, c4, c5, c6);

    input S0, S1, S2, S3, S4;
    output c0, c1, c2, c3, c4, c5, c6;

    assign c0 = (~S4 | S0 | (S3 & S1));
    assign c1 = (~S3 | ~S0);
    assign c2 = (~S3 | S2);
    assign c3 = (S3 & ~S1) | (S3 & S0) | (~S2 & S1) | (~S4 & ~S0);
    assign c4 = (~S4 & ~S0) | (~S2 & S1) | (~S4 & S3) | (S3 & ~S2);
    assign c5 = (S3 & S1) | (~S4 & ~S2);
    assign c6 = S3 | (~S2 & S0);


endmodule

//Gerador de pulsos para o ready, apenas para fins de teste

module readyclk(ready);

    output reg ready;
    always begin
        #2 ready = 1'b0;
        #2 ready = 1'b1;
    end

endmodule