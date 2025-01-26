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

    reg [31:0] cntder = 0;
    reg [31:0] cntizq = 0;

    always_comb
    begin
        red   = 0;
        green = 0;
        blue  = 0;

        if (key[0]) 
            begin 
                if (x > 50 & x < 250 & y > 50 & y < 100)
                    red = 31;
            end
        else 
            begin 
                if (x > 100 & x < 300 & y > 100 & y < 150)
                    red = 31;
            end 
        
>>>>>>> upstream/main
        // 31 is the maximum 5-bit number, 5'b11111

        // Exercise 1: Uncomment the code for a green rectangle
        // that overlaps red rectangle
        // Desplazamiento hacia la derecha
        if (key[1]) begin 
            if (x > 150+cntder & x < 350+cntder & y > 70 & y < 120) begin
                green = 63; 
            end
            cntder = cntder + 1;
            if (cntder % 100 == 0)
                cntder = cntder + 1;
        
        end else if (key[2]) begin
        // Desplazamiento hacia la izquierda
        if (x > 150 - cntizq && x < 350 - cntizq && y > 70 && y < 120) begin
            green = 63; 
        end
        cntizq = cntizq + 1;
        if (cntizq % 100 == 0)
            cntizq = cntizq + 1;

        end else begin
            if (x > 150 & x < 350 & y > 70 & y < 120) begin
                green = 63;
            end
            cntder = 0;
            cntizq = 0;
        end 

        // 63 is the maximum 6-bit number, 6'b111111

        // Exercise 2: Add a blue rectangle
        // that overlaps both rectangles
        if (key[2]) 
            begin 
                if (x > 0 & x < 200 & y > 200 & y < 250)
                    blue = 31;
            end
        else 
            begin 
                if (x > 200 & x < 400 & y > 100 & y < 150)
                    blue = 31;
            end 
            
    end 
>>>>>>> upstream/main

endmodule
