// Board configuration: tang_nano_9k_lcd_480_272_tm1638_hackathon
// This module uses few parameterization and relaxed typing rules

module hackathon_top
(
    input  logic       clock,
    input  logic       reset,

    input  logic [7:0] key,
    output logic [7:0] led,

    // A dynamic seven-segment display

    output logic [7:0] abcdefgh,
    output logic [7:0] digit,

    // LCD screen interface

    input  logic [8:0] x,
    input  logic [8:0] y,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue
);

    //------------------------------------------------------------------------

    logic [31:0] counter;

    always_ff @ (posedge clock)
        if (reset)
            counter <= 0;
        else
            counter <= counter + 1;

    wire enable = (counter [22:0] == 0);
    // Try different slices here, for example "counter [20:0] == 0"

    //------------------------------------------------------------------------

    wire button_on = | key;

    logic [7:0] shift_reg;

    /*
    always_ff @ (posedge clock)
        if (reset)
            shift_reg <= 1;
        else if (enable)
            shift_reg <= { button_on, shift_reg [7:1] };
            // si el boton se presiona se enciende button_on y al hacer el { button_on, shift_reg [7:1] }
            // se esta colocando ese 1 del encendido en la posicion mas significativa de shift_reg
            // y los demas valores del 7 al 1 ignorando el 0 se colocan a continuacion, eso seria como
            // hacer un corrimiento hacia la derecha agregando un 1 desde la parte mas significativa.
            // Alternatively you can write:
            // shift_reg <= (button_on << 7) | (shift_reg >> 1);
    */



    // Exercise 1: Make the light move in the opposite direction.
   
   /*
    always_ff @ (posedge clock)
        if (reset)
            shift_reg <= 1;
        else if (enable)
            shift_reg <= { shift_reg[6:0], button_on };
            // si queremos lo contrario, se puede hacer lo siguiente { shift_reg[6:0], button_on };
            // aqui colocamos en shift_reg primero los valores del 6 al 0 ignorando el mas significativo osea el 7
            // estos iniciarian desde la parte mas significativa osea se recorrieron un lugar hacia la izquierda
            // y en la posicion menos signiticativa se coloca el valor del boton si esta encendido o no.
    */


    // Exercise 2: Make the light moving in a loop.
    // Use another key to reset the moving lights back to no lights.
/*
    //hacia la derecha
    always_ff @ (posedge clock)
        if (reset)
            shift_reg <= 8'b00000001;
        else if (enable)
            shift_reg <= { shift_reg [0], shift_reg [7:1] };
*/
///*
    //hacia la izquierda
    always_ff @ (posedge clock)
        if (reset)
            shift_reg <= 8'b10000000;
        else if (enable)
            shift_reg <= { shift_reg [6:0], shift_reg [7] };
//*/

    assign led = shift_reg;

    // Exercise 3: Display the state of the shift register
    // on a seven-segment display, moving the light in a circle.

    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h

    always_comb begin
        case (shift_reg)
                                    // abcdefgh
            8'b00000001: abcdefgh = 8'b11111100; // 0
            8'b00000010: abcdefgh = 8'b01100000; // 1
            8'b00000100: abcdefgh = 8'b11011010; // 2
            8'b00001000: abcdefgh = 8'b11110010; // 3
            8'b00010000: abcdefgh = 8'b01100110; // 4
            8'b00100000: abcdefgh = 8'b10110110; // 5
            8'b01000000: abcdefgh = 8'b10111110; // 6
            8'b10000000: abcdefgh = 8'b11100000; // 7
            default: abcdefgh = 8'b00000000; // Apagado
        endcase
    end

    // Seleccionar el primer digito en el display de 7 segmentos
    assign digit = 8'b00000001;
endmodule
