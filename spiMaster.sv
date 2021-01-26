`default_nettype none

//SPI protocol with one master & slave
module SPImaster
  #(parameter DATALEN = 64)
  (input logic clock, reset_n,
  input logic send,
  input logic masterDataEn,
  input logic [DATALEN-1:0] masterData,
  input logic MISO,
  output logic MOSI, 
  output logic SS_n);


  logic [DATALEN-1:0] slaveReg, masterReg;
  logic slaveShift, en, doneSending;
  logic [6:0] n;

  shiftRegister sD(.D(MISO), .clock, .reset_n, .en(en), .Q(slaveReg));
  Register #(DATALEN) mD(.D(masterData), .clock, .reset_n, .en(masterDataEn), .Q(masterReg));
  
  Counter #(7) ct(.clock, .reset_n, .en(en), .Q(n));
  assign doneSending = (n == 7'd64);

  enum logic [1:0] {IDLE, SEND} curr, next;

  always_comb begin
    MOSI = 1'b0; SS_n = 1'b1; en = 1'b0;
    case (curr)
      IDLE : begin
        if (send) begin
          next = SEND;
          SS_n = 1'b0;
        end
        else next = IDLE;
      end
      SEND : begin
        SS_n = 1'b0; en = 1'b1;
        MOSI = masterReg[n]; //send LSB first
        next = (doneSending) ? IDLE : SEND;
      end
    endcase
  end


  always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) curr <= IDLE;
    else curr <= next;
  end

endmodule: SPImaster


module shiftRegister
  (input logic clock, reset_n,
  input logic en, D,
  output logic [63:0] Q);

  always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) Q <= 0;
    else if (en) Q <= {Q[62:0], D};
  end

endmodule: shiftRegister