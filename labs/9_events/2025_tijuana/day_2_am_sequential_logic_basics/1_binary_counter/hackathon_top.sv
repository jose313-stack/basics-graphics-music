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

    assign led = counter [31:24];  // Try to put [23:16] here

    // assign led = counter >> 20;  // Try alternative way to shift the value
    
    // Try to add "if (key)" after "else".

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

    /*

    wire k = | key;  // Any key is on

    logic k_previous;

    always_ff @ (posedge clock)
        if (reset)
            k_previous <= 0;
        else
            k_previous <= k;

    wire k_pressed = k & ~ k_previous;

    always_ff @ (posedge clock)
        if (reset)
            led <= 0;
        else if (k_pressed)
            led <= led + 1;

    */

endmodule
