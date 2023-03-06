module CaesarEncoder(ready, reset, a, b, c, d, S0, S1, S2, S3, S4);

    //Declaração das entradas e saídas
    input a, b, c, d, ready, reset;
    output reg S0, S1, S2, S3, S4;
    //Declaração dos fios intermeriários
    reg fio1, fio2, fio3, fio4, fio5, fio6, fio7, fio8, fio9;
    always @(posedge reset) begin
        S0 <= 1'bx;
        S1 <= 1'bx;
        S2 <= 1'bx;
        S3 <= 1'bx;
        S4 <= 1'bx;
    end
    always @(posedge ready) begin

    //Funcionamento do circuito
        if (a && (b || c)) begin
            S0 <= 1'bx;
            S1 <= 1'bx;
            S2 <= 1'bx;
            S3 <= 1'bx;
            S4 <= 1'bx;
        end else begin
            fio1 = a & ~d;
            S4 = fio1 | b;
            fio2 = b & d;
            fio3 = b & c;
            S3 = fio2 | fio3 | a;
            fio4 = ~b & ~c & ~d;
            fio5 = b & c;
            S2 = fio4 | fio5 | a;
            fio6 = ~b & ~c;
            fio7 = b & c & d;
            S1 = fio6 | fio7;
            fio8 = ~b & ~c;
            fio9 = ~b & ~d;
            S0 = fio8 | fio9;
        end

    end

endmodule

module testbench;

    reg [3:0] entrada;
    reg reset, ready;
    wire [4:0] saida;
    CaesarEncoder Codificador (.ready(ready), .reset(reset), .a(entrada[3]), .b(entrada[2]), .c(entrada[1]), .d(entrada[0]), .S0(saida[0]), .S1(saida[1]), .S2(saida[2]), .S3(saida[3]), .S4(saida[4]));
    initial begin

        $monitor("Entrada:\n%1b %1b %1b %1b\nSaida:\n%1b %1b %1b %1b %1b\n", entrada[3], entrada[2], entrada[1], entrada[0], saida[4], saida[3], saida[2], saida[1], saida[0]);

        #0 entrada = 4'b0000;
        #1 entrada = 4'b0001;
        #1 entrada = 4'b0010;
        #1 entrada = 4'b0011;
        #1 entrada = 4'b0100;
        #1 entrada = 4'b0101;
        #1 entrada = 4'b0110;
        #1 entrada = 4'b0111;
        #1 entrada = 4'b1000;
        #1 entrada = 4'b1001;
        #1 entrada = 4'b1011;
        #1 ready = 1'b1;
        #50 $finish;
        end
endmodule