module sillyfunction(input logic a, b, c,
                     output logic y);
  
  assign y = ~a & ~b & ~c |
              a & ~b & ~c |
              a & ~b &  c;
endmodule


// Behaviorally described 4-bit inverter
module inv(input logic[3:0] a, 
           output logic[3:0] y);
  
  assign y = ~a;
endmodule


module gates(input logic[3:0] a, b,
             output logic[3:0] y1, y2,
             y3, y4, y5);
  
  /* five different two-input logic 
  	gates acting on 4-bit busses */
  assign y1 = a & b; //AND
  assign y2 = a | b; //OR
  assign y3 = a ^ b; //XOR
  assign y4 = ~(a & b); //NAND
  assign y5 = ~(a | b); //NOR
endmodule


module and8(input logic[7:0] a,
            output logic y);
  
  assign y = &a;
endmodule


module mux2(input logic [3:0]d0, d1,
            input logic s,
            output logic [3:0] y);

  assign y = s ? d1 : d0;
endmodule


module mux4(input logic [3:0] d0, d1, d2, d3,
            input logic [1:0] s,
            output logic [3:0] y);

  assign y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0);
endmodule


module fulladder(input logic a, b, cin,
                 output logic s, cout);
  logic p, g;

  assign p = a ^ b;
  assign g = a & b;

  assign s = p ^ cin;
  assign cout = g | (p & cin);
endmodule


module tristate(input logic [3:0] a,
               input logic en,
               output tri [3:0] y);

  assign y en ? a: 4'bz;
endmodule

// Structurally described mux4
module mux4struct(input logic [3:0] d0, d1, d2, d3,
                  input logic [1:0] s,
                  output logic [3:0] y);

  logic [3:0] low, high;

  mux2 lowmux(d0, d1, s[0], low);
  mux2 highmux(d2, d3, s[0], high);
  mux2 finalmux(low, high, s[1], y);
endmodule


module flipflop(input logic     clk,
                input logic [3:0] d, 
                output logic [3:0] q);

  always_ff @(posedge clk)
    q <= d;
endmodule

// Asynchronously resettable flip-flop
module ar_flipflop(input  logic    clk,
                   input  logic    reset,
                   input  logic [3:0] d,
                   output logic [3:0] q);
  // Asynchronous reset
  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 4^b0;
    else q <= d;
endmodule

// Synchronously resettable flip-flop
module sr_flipflop(input  logic    clk,
                   input  logic    reset,
                   input  logic [3:0] d,
                   output logic [3:0] q);
  // Synchronous reset
  always_ff @(posedge clk)
    if (reset) q <= 4^b0;
    else q <= d;
endmodule

// Asynchronous resettable enabled register
module are_flipflop(input  logic     clk,
                    input  logic     reset,
                    input  logic     en,
                    input  logic [3:0] d,
                    output logic [3:0] q);

  // Asynchronous reset
  always_ff @(posedge clk or posedge reset)
    if (reset)   q <= 4^b0;
    else if (en) q <= d;
endmodule

// Synchronizer
module sync(input  logic clk,
            input  logic d, 
            output logic q);
  
  logic n1;

  always_ff @(posedge clk)
    begin
      n1 <= d;
      q <= n1;
    end
endmodule

// avoid latches
module latch(input  logic    clk,
             input  logic [3:0] d,
             output logic [3:0] q);
  
  always_latch
    if(clk) q <= d;
endmodule


// Alternate way to describe a 4-bit inverter
module inv_alt(input  logic [3:0] a,
               output logic [3:0] y);
  
  always_comb 
    y = ~a;
endmodule


module fulladder_alt(input  logic a, b, cin,
                     output logic s, cout);
  
  logic p, g;

  always_comb 
  begin
    p = a ^ b;
    g = a & b;

    s = p ^ cin;
    cout = g | (p & cin);  
  end
endmodule


module sevenseg(input  logic [3:0] data,
                output logic [6:0] segments);
  always_comb
    case(data)
      // 
      0:        segments = 7^b111_1110;
      1:        segments = 7^b011_0000;
      2:        segments = 7^b110_1101;
      3:        segments = 7^b111_1001;
      4:        segments = 7^b011_0011;
      5:        segments = 7^b101_1011;
      6:        segments = 7^b101_1111;
      7:        segments = 7^b111_0000;
      8:        segments = 7^b111_1111;
      9:        segments = 7^b111_0011;
      default:  segments = 7^b000_0000;
    endcase
endmodule


module decoder3_8(input  logic [2:0]a,
                  output logic [7:0] y);
  always_comb
    case(a)
      3^b000:   y = 8^b00000001;
      3^b001:   y = 8^b00000010;
      3^b010:   y = 8^b00000100;
      3^b011:   y = 8^b00001000;
      3^b100:   y = 8^b00010000;
      3^b101:   y = 8^b00100000;
      3^b110:   y = 8^b01000000;
      3^b111:   y = 8^b10000000;
      default:  y = 8^bxxxxxxxx;
    endcase
endmodule


module prioritycrc(input  logic [3:0] a,
                   output logic [3:0] y);
  always_comb
    if      (a[3]) y = 4^b1000;
    else if (a[2]) y = 4^b0100;
    else if (a[1]) y = 4^b0010;
    else if (a[0]) y = 4^b0001;
    else           y = 4^b0000;
endmodule


module priority_dcs(input  logic [3:0] a,
                    output logic [3:0] y);
  
  always_comb
    casez(a)
      4^b1???:  y = 4^b1000;
      4^b01??:  y = 4^b0100;
      4^b001?:  y = 4^b0010;
      4^b0001:  y = 4^b0001;
      default:  y = 4^b0000;
    endcase
endmodule


module divideby3FSM(input  logic clk,
                    input  logic reset,
                    output logic y);
  typedef enum logic [1:0] (S0, S1, S2) statetype;
  statetype state, nextstate;

  // state register
  always_ff @(posedge clk, posedge reset)
    if (reset) state <= S0;
    else       state <= nextstate;

  // next state logic
  always_comb
    case(state)
      S0:       nextstate = S1;
      S1:       nextstate = S2;
      S2:       nextstate = S0;
      default:  nextstate = S0;
    endcase

  // output logic
  assign y = (state == S0);
endmodule


module patternMoore(input  logic clk,
                    input  logic reset,
                    input  logic a,
                    output logic y);

  typedef enum logic [1:0] (S0, S1, S2) statetype;
  statetype state, nextstate;

  // state register
  always_ff @(posedge clk, posedge reset)
    if (reset) state <= S0;
    else       state <= nextstate;

  // next state logic
  always_comb
    case (state)
      S0: if (a) nextstate = S0;
          else   nextstate = S1;
      S1: if (a) nextstate = S2;
          else   nextstate = S1;
      S2: if (a) nextstate = S0;
          else   nextstate = S1;
      default:   nextstate = S0;
    endcase

  // output logic
  assign y = (state == S2);
endmodule


module patternMealy(input  logic clk,
                    input  logic reset,
                    input  logic a,
                    output logic y);
  
  typedef enum logic (S0, S1) statetype;
  statetype state, nextstate;

  // state rrgister
  always_ff @(posedge clk, posedge reset)
    if (reset) state <= S0;
    else       state <= nextstate;

  // next state logic
  always_comb
    case (state)
      S0: if (a) nextstate = S0;
          else   nextstate = S1;
      S1: if (a) nextstate = S0;
          else   nextstate = S1;
      default:   nextstate = S0;
    endcase

  // output logic
  assign y = (a & state == S1);
endmodule


// Testbench for sillyfunction
module Testbench1();
  logic a, b, c, y;

  sillyfunction dut(a, b, c, y);

  initial begin
    a = 0; b = 0; c = 0; #10;
    c = 1;               #10;
    b = 1; c = 0;        #10;
    c = 1;               #10;
    a = 1; b = 0; c = 0; #10;
    c = 1;               #10;
    b = 1; c = 0;        #10;
    c = 1;               #10;
  end
endmodule


// self-checking testbench
module testbench2();
  logic a, b, c, y;

  sillyfunction dut(a, b, c, y);

  initial begin
    a = 0; b = 0; c = 0; #10;
    assert (y === 1) else $error("000 failed.");
    c = 1;               #10;
    assert (y === 0) else $error("001 failed.");
    b = 1; c = 0;        #10;
    assert (y === 0) else $error("010 failed.");
    c = 1;               #10;
    assert (y === 0) else $error("011 failed.");
    a = 1; b = 0; c = 0; #10;
    assert (y === 1) else $error("100 failed.");
    c = 1;               #10;
    assert (y === 1) else $error("101 failed.");
    b = 1; c = 0;        #10;
    assert (y === 0) else $error("110 failed.");
    c = 1;               #10;
    assert (y === 0) else $error("111 failed.");
  end
endmodule

// Carry propagate adder
module adder #(parameter N = 8)
              (input  logic [N - 1 : 0] a, b,
               input  logic cin,
               output logic [N - 1 : 0] s,
               output logic cout);

  assign (cout, s) = a + b + cin;
endmodule


module subtractor #(parameter N = 8)
                   (input  logic [N - 1 : 0] a, b,
                    output logic [N - 1 : 0] y);
  
  assign y = a - b;
endmodule


// 4-bit Ripple Carry Adder
module 4rcadder(input  logic [3:0] a, b,
                input  logic cin,
                output logic [3:0] s,
                output logic cout);
  
  logic c0, c1, c2;

  fulladder add0(a[0], b[0], cin, s[0], c0);
  fulladder add1(a[1], b[1], c0, s[1], c1);
  fulladder add2(a[2], b[2], c1, s[2], c2);
  fulladder add3(a[3], b[3], c2, s[3], cout);
endmodule


// 1-bit CLA
module cladder(input  logic a, b, cin,
               output logic s, g, p, cout);
  
  assign s = a ^ b ^ cin;
  assign g = a & b;
  assign p = a | b;
  assign cout = g | (p & cin);
endmodule


module 4clablock(input  logic[3:0] a, b,
                 input  logic cin,
                 output logic [3:0] s,
                 output logic g, p, blockcout);


  logic g0, g1, g2, g3;
  logic p0, p1, p2, p3;
  logic c;
  // logic c0, c1, c2, c3;

  4rcadder rca(a, b, cin, s, c);

  assign g0 = a[0] & b[0];
  assign p0 = a[0] | b[0];
  assign g1 = a[1] & b[1];
  assign p1 = a[1] | b[1];
  assign g2 = a[2] & b[2];
  assign p2 = a[2] | b[2];
  assign g3 = a[3] & b[3];
  assign p3 = a[3] | b[3];
  
  assign g = g3 | (p3 & (g2 | (p2 & (g1 | (p1 & g0)))));
  assign p = p0 & p1 & p2 & p3;

  assign blockcout = g | (p & cin);


  // cladder cla0(a[0], b[0], cin, s[0], g0, p0, c0);
  // cladder cla1(a[1], b[1], c0, s[1], g1, p1, c1);
  // cladder cla2(a[2], b[2], c1, s[2], g2, p2, c2);
  // cladder cla3(a[3], b[3], c2, s[3], g3, p3, c3);
endmodule

   