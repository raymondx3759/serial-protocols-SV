`default_nettype none

//SPI protocol with one master & slave
module SPIslave
  #(parameter DATALEN = 64)
  (input logic clock, reset_n,
  input logic SS_n, //low when master is about to transmit and held until done
  input logic MOSI, //master out slave in
  output logic MISO); //master in slave out


  logic [DATALEN-1:0] slaveReg;
  logic slaveShift, en;

  assign MISO = 1'b0;
     
  shiftRegister sD(.D(MOSI), .clock, .reset_n, .en(en), .Q(slaveReg));

  assign en = (SS_n) ? 1'b0 : 1'b1;


  // always_ff @(posedge clock, negedge reset_n) begin
  //   if (~reset_n) curr <= IDLE;
  //   else curr <= next;
  // end

endmodule: SPIslave

