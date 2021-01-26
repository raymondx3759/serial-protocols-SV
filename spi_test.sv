`default_nettype none

module tb;

  logic clock, reset_n;
  logic send, masterDataEn; 
  logic [63:0] masterData;
  logic MISO, MOSI, SS_n;
  
  
  SPI #(64) master(.*);
  

endmodule: tb