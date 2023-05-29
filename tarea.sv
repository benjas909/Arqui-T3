// USADOS EN LA TAREA
module and8(input logic[7:0] a, b,
            output logic[7:0] y);
  
  assign y = a & b;
endmodule


module or8(input  logic [7:0] a, b,
           output logic [7:0] y);

  assign y = a | b;

endmodule


module xor8(input  logic [7:0] a, b,
            output logic [7:0] y);

  assign y = a ^ b;
endmodule


module not8(input  logic [7:0] a, b,
            output logic [7:0] y);

  assign y = ~a;
endmodule


module counter #(parameter N = 6)
                (input  logic clock, 
                 input  logic reset,
                 output logic [N - 1: 0] q);

  always_ff @(posedge clock or posedge reset) 
    if (reset) q <= 0;
    else       q <= q + 1;
endmodule


module ROM(input  logic [5:0] address,
           output logic [18:0] databit);

  always_comb
    case (address)
      6'h0: data = 19'b0000001011100010011;
      6'h1: data = 19'b0010000011101001100;
      6'h2: data = 19'b0100001111100000101;
      6'h3: data = 19'b0110001111100000010;
      6'h4: data = 19'b1000101110101010010;
      6'h5: data = 19'b1010101110101010010;
      6'h6: data = 19'b1100101110101010010;
      6'h7: data = 19'b1110101110100000000;
      6'h8: data = 19'b0000101001100010110;
    endcase
endmodule


module prefix1bit(input  logic a, b,
                  // input  logic g_prev,
                  output logic g, p);
  
  assign g = a & b;
  assign p = a | b;
  // assign si = g_prev ^ (a ^ b);
endmodule

module prefix2bit(input  logic [1:0] a, b,
                  // input  logic g_prev,
                  output logic gi, pi)
  
  logic g_left, g_right, p_left, p_right;
  
  prefix1bit gpright(a[0], b[0], g_right, p_right);
  prefix1bit gpleft(a[1], b[1], g_left, p_left);

  assign gi = g_left | (p_left & g_right);
  assign pi = p_left & p_right;

endmodule

module prefix4bit(input  logic [3:0] a, b,
                  output logic gi, pi);

  logic g_left, p_left, g_right, p_right;

  prefix2bit gpright(a[1:0], b[1:0], g_right, p_right);
  prefix2bit gpleft(a[3:2], b[3:2], g_left, p_left);

  assign gi = g_left | (p_left & g_right);
  assign pi = p_left & p_right;

endmodule




module prefix8bit(input  logic [7:0] a, b,
                  //  input  logic cin,
                  //  output logic [7:0] s);
                  output logic gi, pi);
            
  logic g_left, p_left, g_right, p_right;
  
  prefix4bit gp8_right(a[3:0], b[3:0], g_right, p_right);
  prefix4bit gp8_left(a[7:4], b[7:4], g_left, p_left);

  assign gi = g_left | (p_left & g_right);
  assign pi = p_left & p_right;

endmodule


module 8prefixadder(input  logic [7:0] a, b,
                    input  logic cin,
                    output logic [7:0] s);

  logic [6:0] g, p;
  logic [3:0] g_2, p_2;
  logic [3:0] g_4, p_4;
  logic [3:0] g_8, p_8;
  

  prefix1bit p_1_0(a[0], b[0], g[0], p[0]);
  prefix1bit p_1_1(a[1], b[1], g[1], p[1]);
  prefix1bit p_1_2(a[2], b[2], g[2], p[2]);
  prefix1bit p_1_3(a[3], b[3], g[3], p[3]);
  prefix1bit p_1_4(a[4], b[4], g[4], p[4]);
  prefix1bit p_1_5(a[5], b[5], g[5], p[5]);
  prefix1bit p_1_6(a[6], b[6], g[6], p[6]);


  prefix8bit 8block({a[6:0], cin}, {b[6:0], 0}, g_8[3], p_8[3]);
  
  prefix4bit 4block_L(a[6:3], b[6:3], g_4[3], p_4[3]);
  
  prefix2bit 2block_LL(a[6:5], b[6:5], g_2[3], p_2[3]);
  prefix2bit 2block_LR(a[4:3], b[4:3], g_2[2]. p_[2]);

  prefix4bit 4block_R({a[2:0], cin}, {b[2:0], ?}, g_4[1], p_4[1]);

  prefix2bit 2block_RL(a[2:1], b[2:1], g_2[1], p_2[1]);
  prefix2bit 2block_RR({a[0], cin}, {b[0], ?}, g_2[0], p_2[0]);

  assign g_4[2] = g[5] | (p[5] & g_2[2]);
  assign p_4[2] = p[5] & p_2[2];

  assign g_4[0] = g[1] | (p[1] & g_2[0]);
  // p_4 se ignora

  assign g_8[2] = g_4[2] | (p_4[2] & g_4[1]);
  assign p_8[2] = p_4[2] & p_4[1];
  
  assign g_8[1] = g_2[2] | (p_2[2] & g_4[1]);
  assign p_8[1] = p_2[2] & p_4[1];

  assign g_8[0] = g[3] | (p[3] & g_4[1]);
  assign p_8[0] = p[3] & p_4[1];
  

  assign s[7] = (a[7] ^ b[7]) ^ g_8[3];
  assign s[6] = (a[6] ^ b[6]) ^ g_8[2];
  assign s[5] = (a[5] ^ b[5]) ^ g_8[1];
  assign s[4] = (a[4] ^ b[4]) ^ g_8[0];
  assign s[3] = (a[3] ^ b[3]) ^ g_4[1];
  assign s[2] = (a[2] ^ b[2]) ^ g_4[0];
  assign s[1] = (a[1] ^ b[1]) ^ g_2[0];
  assign s[0] = cin;

endmodule
// USADOS EN LA TAREA
