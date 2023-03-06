module urna_do_mal(voto, swap, valid, finish, clock, TC1, TC2, TNULL);

    
    input [3:0]voto;
    input swap, valid, finish, clock;
    reg [7:0]C1 = 8'b00000000;
    reg [7:0]C2 = 8'b00000000;
    reg [7:0]NULL = 8'b00000000;
    output reg [7:0]TC1 = 8'b00000000;
    output reg [7:0]TC2 = 8'b00000000;
    output reg [7:0]TNULL = 8'b00000000;
    parameter estado_inicial = 2'b00;
    parameter estado_1 = 2'b01;
    parameter estado_2 = 2'b10;
    reg [1:0] estado_atual = estado_inicial;
    reg [1:0] prox_estado = estado_inicial;

    always @(posedge clock) begin

        if (finish)
            estado_atual = estado_inicial;
        else
            estado_atual = prox_estado;

    end

    always @(posedge valid or posedge finish) begin

        case(estado_atual)
            estado_inicial: begin //Estado inicial, quando todos os contadores se iniciam em 0
                C1 = 8'b00000000;
                C2 = 8'b00000000;
                NULL = 8'b00000000;
                TC1 = 8'b00000000;
                TC2 = 8'b00000000;
                TNULL = 8'b00000000;
                prox_estado = estado_1;
            end estado_1: begin
                if((voto == 4'b1010) && swap == 1'b0) begin
                    C1 <= C1 + 1'b1;
                end else if(voto == 4'b1010 && swap == 1'b1) begin
                    C2 <= C2 + 1'b1;
                end else if((voto == 4'b1111) && swap == 1'b0) begin
                    C2 <= C2 + 1'b1;
                end else if(voto == 4'b1111 && swap == 1'b1) begin
                    C1 <= C1 + 1'b1;
                end else begin
                    NULL <= NULL + 1'b1;
                end
                if(finish) prox_estado = estado_2;
            end estado_2: begin
                    TC1 = C1;
                    TC2 = C2;
                    TNULL = NULL;
                    if(finish) prox_estado = estado_inicial;

            end
        endcase
    end

endmodule

module testbench;

    reg [3:0]voto;
    reg swap;
    reg valid;
    wire [7:0]C1;
    wire [7:0]C2;
    wire [7:0]NULL;
    reg finish;
    wire clock;
    wire [3:0]DTC1bcd;
    wire [3:0]DTC2bcd;
    wire [3:0]DTNULLbcd;
    wire [3:0]ETC1bcd;
    wire [3:0]ETC2bcd;
    wire [3:0]ETNULLbcd;
    
    wire [6:0] Display7;
    wire [6:0] Display6;
    wire [6:0] Display5;
    wire [6:0] Display4;
    wire [6:0] Display3;
    wire [6:0] Display2;

    clock clock1(.clock(clock));
    urna_do_mal urna(.voto(voto), .swap(swap), .valid(valid), .finish(finish), .TC1(C1), .TC2(C2), .clock(clock), .TNULL(NULL));

    tentativa2bcd bill(.bin(C1), .esqbcd(ETC1bcd), .dirbcd(DTC1bcd));
    tentativa2bcd bill1(.bin(C2), .esqbcd(ETC2bcd), .dirbcd(DTC2bcd));
    tentativa2bcd bill2(.bin(NULL), .esqbcd(ETNULLbcd), .dirbcd(DTNULLbcd));

    display display7(.A(ETC1bcd[3]), .B(ETC1bcd[2]), .C(ETC1bcd[1]), .D(ETC1bcd[0]), .c0(Display7[0]), .c1(Display7[1]), .c2(Display7[2]), .c3(Display7[3]), .c4(Display7[4]), .c5(Display7[5]), .c6(Display7[6]));
    display display6(.A(DTC1bcd[3]), .B(DTC1bcd[2]), .C(DTC1bcd[1]), .D(DTC1bcd[0]), .c0(Display6[0]), .c1(Display6[1]), .c2(Display6[2]), .c3(Display6[3]), .c4(Display6[4]), .c5(Display6[5]), .c6(Display6[6]));
    display display5(.A(ETC2bcd[3]), .B(ETC2bcd[2]), .C(ETC2bcd[1]), .D(ETC2bcd[0]), .c0(Display5[0]), .c1(Display5[1]), .c2(Display5[2]), .c3(Display5[3]), .c4(Display5[4]), .c5(Display5[5]), .c6(Display5[6]));
    display display4(.A(DTC2bcd[3]), .B(DTC2bcd[2]), .C(DTC2bcd[1]), .D(DTC2bcd[0]), .c0(Display4[0]), .c1(Display4[1]), .c2(Display4[2]), .c3(Display4[3]), .c4(Display4[4]), .c5(Display4[5]), .c6(Display4[6]));
    display display3(.A(ETNULLbcd[3]), .B(ETNULLbcd[2]), .C(ETNULLbcd[1]), .D(ETNULLbcd[0]), .c0(Display3[0]), .c1(Display3[1]), .c2(Display3[2]), .c3(Display3[3]), .c4(Display3[4]), .c5(Display3[5]), .c6(Display3[6]));
    display display2(.A(DTNULLbcd[3]), .B(DTNULLbcd[2]), .C(DTNULLbcd[1]), .D(DTNULLbcd[0]), .c0(Display2[0]), .c1(Display2[1]), .c2(Display2[2]), .c3(Display2[3]), .c4(Display2[4]), .c5(Display2[5]), .c6(Display2[6]));
    
    initial begin

        $monitor("Voto: %b\nSwap: %b\nValid: %b\nC1: %b\nC2: %b\nNULL: %b\nFINISH: %b\n", voto, swap, valid, C1, C2, NULL, finish);

        #0 finish = 1'b0;
        #10 voto = 4'b1010; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1111; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1111; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1010; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1010; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1010; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1111; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1010; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1110; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1011; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 finish = 1'b1;
        #10 finish = 1'b0;
        #10 voto = 4'b1010; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1111; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;
        #10 voto = 4'b1111; swap = 1'b0;
        #10 valid = 1'b0;
        #10 valid = 1'b1;

        #3 $display("Display7: %b", Display7[6:0]);
        #0 $display("Display6: %b", Display6[6:0]);
        #0 $display("Display5: %b", Display5[6:0]);
        #0 $display("Display4: %b", Display4[6:0]);
        #0 $display("Display3: %b", Display3[6:0]);
        #0 $display("Display2: %b", Display2[6:0]);

        #2 $finish;


    end

endmodule

module clock(clock);

    output reg clock;
    always begin
        #1 clock = 1'b0;
        #1 clock = 1'b1;
    end

endmodule

module display(A, B, C, D, c0, c1, c2, c3, c4, c5, c6);

    input A, B, C, D;

    output c0, c1, c2, c3, c4, c5, c6;

    assign c0 = (C | A | (~B & ~D) | (B & D)); 
    assign c1 = (~B | (~C & ~D) | (C & D));
    assign c2 = (~C | D | B);
    assign c3 = (A | (~B & ~D) |(~B & C)|(C & ~D) | (B & ~C & D));
    assign c4 = (~D & (~B | C));
    assign c5 = (A | (~C & ~D) | (B & ~C) | (B & ~D));
    assign c6 = (A | (~B & C) | (C & ~D) | (B & ~C));


endmodule



module tentativa2bcd(bin, esqbcd, dirbcd);

    input [7:0]bin;
    output [3:0]esqbcd;
    output [3:0]dirbcd;
    assign esqbcd = (bin % 1100100) / 1010;
    assign dirbcd = (bin % 1100100) % 1010;

endmodule