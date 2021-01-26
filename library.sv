`default_nettype none

module MagComp
  #(parameter WIDTH = 1)
  (input logic [WIDTH-1:0] A, B,
  output logic AltB, AeqB, AgtB);

  always_comb begin
    AltB = 0; AeqB = 0; AgtB = 0;
    if (A < B) AltB = 1;
    else if (A == B) AeqB = 1;
    else AgtB = 1;
  end
endmodule: MagComp

module Adder
  #(parameter WIDTH = 1)
  (input logic [WIDTH-1:0] A, B,
  input logic Cin,
  output logic [WIDTH-1:0] S,
  output logic Cout);

  assign {Cout, S} = A + B + Cin;
endmodule: Adder

module Multiplexer
  #(parameter WIDTH = 1)
  (input logic [WIDTH-1:0] I,
  input logic [$clog2(WIDTH-1):0] S,
  output logic Y);

  assign Y = I[S];
endmodule: Multiplexer

module Mux2to1
  #(parameter WIDTH = 1)
  (input logic [WIDTH-1:0] I0, I1,
  input logic S,
  output logic [WIDTH-1:0] Y);

  always_comb begin
    Y = I0;
    if (S) Y = I1;
  end
endmodule: Mux2to1

module Decoder
  #(parameter WIDTH = 1)
  (input logic [$clog2(WIDTH-1):0] I,
  input logic en,
  output logic [WIDTH-1:0] D);

  always_comb begin
    D = 0;
    if (en)
      D[I] = 1;
  end
endmodule: Decoder


module Register
  #(parameter WIDTH = 1)
  (input logic [WIDTH-1:0] D,
  input logic clock, reset_n, en, 
  output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock, negedge reset_n)
    if (~reset_n) Q <= 0;
    else if (en) Q <= D;
  
endmodule: Register

module Counter
  #(parameter WIDTH = 1)
  (input logic clock, reset_n, en, 
  output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock, negedge reset_n) begin
    if (~reset_n) Q <= 0;
    else if (en) Q <= Q + 1;
  end
endmodule: Counter


module dataFF
  (input logic D, 
  input logic clock,
  output logic Q);

  always_ff @(posedge clock) 
    Q <= D;
endmodule: dataFF

module Sync
  (input logic asyncIn, 
  input logic clock, 
  output logic syncOut);

  logic tempOut;
  dataFF temp(.D(asyncIn), .clock(clock), .Q(tempOut));
  dataFF stable(.D(tempOut), .clock(clock), .Q(syncOut));
endmodule: Sync