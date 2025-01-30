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

    // Exercise 1: Free running counter.
    // How do you change the speed of LED blinking?
    // Try different bit slices to display.

    logic [31:0] counter;

    always_ff @ (posedge clock)
        if (reset)
            counter <= 0;
        else
            counter <= counter + 1;

    //assign led = counter [27:20];  // Try to put [23:16] here
    //27:20 es un rango que permite ver los cambios en los leds, pero no tan lento.


    //assign led = counter << 5;  //hace corrimiento hacia la derecha, seria como multiplicar por 32 o 2^5
    //assign led = counter >> 5;  // Try alternative way to shift the value
    
    // Try to add "if (key)" after "else".

    //logic led; //se maneja logic ya que lo controlaremos dentro de un bloque condicional 

    //la logica combinacional genera una salida directamente dependiente de las entradas actuales, 
    //sin depender de un reloj o estado previo. Es utilizada para circuitos como sumadores, 
    //multiplexores, y puertas logicas.

    /*always_comb begin //sirve cuando usaremos logica combinacional (no depende del reloj)
        if (key[0])
            led = counter << 5;  //hace corrimiento hacia la derecha, seria como multiplicar por 32 o 2^5
        else
            led = counter >> 5;  // Try alternative way to shift the value
    end
    */

    

    // Exercise 2: Key-controlled counter.
    // Comment out the code above.
    // Uncomment and synthesize the code below.
    // Press the key to see the counter incrementing.
    //
    // Change the design, for example:
    //
    // 1. One key is used to increment, another to decrement.
    //
    // 2. Two counters controlled by different keys
    // displayed in different groups of LEDs.

    

    wire k = | key;  // Any key is on

    logic k_previous;

    //la logica secuencial genera una salida que depende no solo de las entradas actuales, sino también del 
    //estado previo, lo cual requiere almacenamiento de datos (flip-flops o registros). 
    //Es sincronizada mediante un reloj.

    //posedge clock es el flanco positivo del reloj
/*
    always_ff @ (posedge clock)   //always_ff se usa para logica secuencial sincronizada con el flaco del reloj
        if (reset)
            k_previous <= 0;
        else
            k_previous <= k; //actializa el estado previo de k con el valor actual

    wire k_pressed = k & ~ k_previous; //se usa para detectar si se hubo cambios o no

    always_ff @ (posedge clock)
        if (reset)
            led <= 0;
        else if (k_pressed)
            led <= led + 1;
*/
/*
//begin e end funcionan como los corchetes en c al usar un if con mas de una linea
    
logic flag_change = 0; // para sumar o restar solo una vez y ver el cambio

always_ff @ (posedge clock) begin
    if (reset) begin
        led <= 0;
        flag_change <= 0;
    end else if (key[0] && flag_change == 0) begin // incrementar con key[0]
        led <= led + 1;
        flag_change <= 1;
    end else if (key[1] && flag_change == 1) begin // decrementar con key[1]
        led <= led - 1;
        flag_change <= 0;
    end else if(k):
end
*/




//dos contadores
logic [7:0] counter1, counter2;

always_ff @ (posedge clock) begin
    if (reset) begin
        counter1 <= 0;
        counter2 <= 0;
    end else begin
        if (key[0])  // Incrementar contador1 con key[0]
            counter1 <= counter1 + 1;
        if (key[1])  // Incrementar contador2 con key[1]
            counter2 <= counter2 + 1;
    end
end

assign led[7:4] = counter1[3:0];  // Muestra contador1 en los LEDs 7 a 4
assign led[3:0] = counter2[3:0];  // Muestra contador



    

endmodule
