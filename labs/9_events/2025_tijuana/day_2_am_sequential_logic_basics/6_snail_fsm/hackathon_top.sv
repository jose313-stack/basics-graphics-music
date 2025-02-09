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

    input  logic a,

    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue
);

    //------------------------------------------------------------------------
/*
    wire enable;
    wire fsm_in, moore_fsm_out, mealy_fsm_out;

    // Generate a strobe signal 3 times a second

    strobe_gen
    # (.clk_mhz (27), .strobe_hz (3))
    i_strobe_gen (.clk (clock), .rst (reset), .strobe (enable));

    shift_reg # (8) i_shift_reg
    (
        .clk     (   clock  ),
        .rst     (   reset  ),
        .en      (   enable ),
        .seq_in  ( | key    ),
        .seq_out (   fsm_in ),
        .par_out (   led    )
    );

    snail_moore_fsm i_moore_fsm
    (
        .clock,  // a shortcut for ".clock (clock)"
        .reset,
        .enable,
        .a       ( fsm_in        ),
        .y       ( moore_fsm_out )
    );

    snail_mealy_fsm i_mealy_fsm
    (
        .clock,
        .reset,
        .enable,
        .a       ( fsm_in        ),
        .y       ( mealy_fsm_out )
    );

    //------------------------------------------------------------------------

    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h

    always_comb
    begin
        case ({ mealy_fsm_out, moore_fsm_out })
        2'b00: abcdefgh = 8'b0000_0000;
        2'b01: abcdefgh = 8'b1100_0110;  // Moore only
        2'b10: abcdefgh = 8'b0011_1010;  // Mealy only
        2'b11: abcdefgh = 8'b1111_1110;
        endcase

        digit = 8'b00000001;
    end
*/


    // Exercise: Implement FSM for recognizing other sequence,
    // for example 0101

// --- Detector de flanco para las teclas ---
logic key0_d, key1_d;
logic key_event;

always_ff @(posedge clock or posedge reset) begin
  if (reset) begin
    key0_d <= 1'b0;
    key1_d <= 1'b0;
  end else begin
    key0_d <= key[0];
    key1_d <= key[1];
  end
end

assign key_event = ((~key0_d & key[0]) || (~key1_d & key[1]));

// --- Lógica para definir la entrada de la FSM ---
logic in_machine;
always_comb begin
  // Por ejemplo, si se presiona key[0] se envía un 0,
  // y si se presiona key[1] se envía un 1.
  // En este ejemplo, la prioridad se da a key[1].
  if (key[1])
    in_machine = 1'b1;
  else if (key[0])
    in_machine = 1'b0;
  else
    in_machine = 1'b0; // Valor por defecto
end

// --- FSM para reconocer la secuencia 0101 ---
typedef enum logic [2:0] {
  S0, // Estado inicial
  S1, // Se recibió '0'
  S2, // Secuencia '0,1'
  S3, // Secuencia '0,1,0'
  S4  // Secuencia reconocida: '0,1,0,1'
} state_t;

state_t current_state, next_state;

// Lógica combinacional para la transición entre estados
always_comb begin
  // Por defecto, se mantiene el estado actual.
  next_state = current_state;
  case (current_state)
    S0: begin
      if (in_machine == 1'b0)
        next_state = S1;
      else
        next_state = S0;
    end

    S1: begin
      if (in_machine == 1'b0)
        next_state = S1;
      else if (in_machine == 1'b1)
        next_state = S2;
    end

    S2: begin
      if (in_machine == 1'b0)
        next_state = S3;
      else
        next_state = S0;
    end

    S3: begin
      if (in_machine == 1'b1)
        next_state = S4;
      else
        next_state = S1;
    end

    S4: begin
      // Secuencia reconocida, luego se permite detectar secuencias superpuestas
      next_state = S2;
    end

    default: next_state = S0;
  endcase
end

// Actualización del estado solo en el pulso key_event:
always_ff @(posedge clock or posedge reset) begin
  if (reset)
    current_state <= S0;
  else if (key_event)
    current_state <= next_state;
end

// --- Visualización del estado en los LEDs ---
assign led = {5'b0, current_state};  // Extiende current_state a 8 bits


seven_segment_display # (.w_digit (8)) i_7segment
    (
        .clk      ( clock     ),
        .rst      ( reset     ),
        .number   ( current_state ),
        .dots     ( 0         ),
        .abcdefgh ( abcdefgh  ),
        .digit    ( digit     )
    );

endmodule



