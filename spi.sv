`default_nettype none

//SPI protocol with one master & slave
module SPI
  #(parameter DATALEN = 64;)
  (input logic clock, reset_n,
  input logic send,
  input logic masterDataEn,
  input logic [DATALEN-1:0] masterData,
  input logic MISO,
  output logic MOSI, 
  output logic SS_n);


  logic [DATALEN-1:0] slaveReg, masterReg;
  logic slaveShift;

  shiftRegister sD(.shiftD(MISO), .D(0), .clock, .reset_n, .en(0), .shift(slaveShift), .Q(slaveReg));
  Register mD(.D(masterData), .clock, .reset_n, .en(masterDataEn), .Q(masterReg));


  enum logic [1:0] {IDLE, SEND} curr, next;

  always_comb begin
    MOSI = 1'b0; SS_n = 1'b1;
    case (curr)
      IDLE : begin
        if (send) begin
          next = SEND;
          SS_n = 1'b0;
        end
        else next = IDLE;
      end
      SEND : begin
        SS_n = 1'b0;
        MOSI = masterReg[0];
        next = (doneSending) ? IDLE : SEND;
      end
    endcase
  end


  always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) curr <= IDLE;
    else curr <= next;
  end

endmodule: SPI


module shiftRegister
  (input logic clock, reset_n,
  input logic shiftD,
  input logic [63:0] D, 
  input logic en, shift,
  ouput logic [63:0] Q);

  always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) Q <= 0;
    else if (en) Q <= D;
    else if (shift) Q <= {Q[62:0], shiftD}
  end

endmodule: shiftRegister