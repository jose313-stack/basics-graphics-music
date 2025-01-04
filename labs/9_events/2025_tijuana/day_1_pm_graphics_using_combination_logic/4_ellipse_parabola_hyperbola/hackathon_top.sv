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

    // Parametros de la elipse
    localparam [9:0] xc = 100;       
    localparam [9:0] yc = 100;      
    localparam [9:0] rx = 100;      
    localparam [9:0] ry = 50;      
    localparam [31:0] rx_2 = rx * rx;   
    localparam [31:0] ry_2 = ry * ry;   
    localparam [31:0] rx2_ry2 = rx_2 * ry_2; 

    // Parametros de la parabola
    localparam [31:0] a_ellipse = 1;  
    localparam [31:0] h_ellipse = 250; 
    localparam [31:0] k_ellipse = 0; 

    // Parametros de la hiperbola
    localparam [9:0] h = 200;       
    localparam [9:0] k = 200;       
    localparam [9:0] a = 50;     
    localparam [9:0] b = 25;      
    localparam [31:0] a_2 = a * a;   
    localparam [31:0] b_2 = b * b;   
    localparam [31:0] a2_b2 = a_2 * b_2;


    always_comb begin
        red   = 0;
        green = 0;
        blue  = 0;

        //elipse morado
        if ((((x - xc) * (x -xc) * (ry_2)) + ((y -yc) * (y -yc) * (rx_2))) < (rx2_ry2)) begin
            red   = 31; 
            green = 0;  
            blue  = 31; 
        end

        //parabola azul claro
        if (y >  (a_ellipse * (x - h_ellipse) * (x - h_ellipse)) + k_ellipse) begin
            red   = 0; 
            green = 63;  
            blue  = 31; 
        end

        //hiperbola verdosa
        if ((((x - h) * (x - h) * (b_2)) - ((y - k) * (y - k) * (a_2))) < (a2_b2)) begin
            red   = 15; 
            green = 63;  
            blue  = 15; 
        end


    end

endmodule
