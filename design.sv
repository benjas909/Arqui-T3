module shift_left(input  logic [7:0] a, b,
                  output logic [7:0] y);
    
  assign y = a << b;
endmodule


module shift_right(input  logic [7:0] a, b,
                   output logic [7:0] y);
  
  assign y = a >> b;

endmodule


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


module counter6 (input  logic clock,
                 input  logic reset,
                 output logic [5: 0] q);

  always_ff @(posedge clock or posedge reset) 
    if (reset) q <= 0;
    else       q <= q + 1;
endmodule


module ROM(input  logic [5:0] address,
           output reg [18:0] databits);

  always_comb
    case (address)
      6'b000000: databits = 19'h1A3B2;
      6'b000001: databits = 19'h94D7F;
      6'b000010: databits = 19'h5E61A;
      6'b000011: databits = 19'h719F5;
      6'b000100: databits = 19'h3C8E2;
      6'b000101: databits = 19'h88249;
      6'b000110: databits = 19'h4B910;
      6'b000111: databits = 19'h127BC;
      6'b001000: databits = 19'h9F34D;
      6'b001001: databits = 19'h5A6F9;
      6'b001010: databits = 19'h78D51;
      6'b001011: databits = 19'h60398;
      6'b001100: databits = 19'h23E06;
      6'b001101: databits = 19'h1FAA2;
      6'b001110: databits = 19'h4D19C;
      6'b001111: databits = 19'h8E851;
      6'b010000: databits = 19'h79B3A;
      6'b010001: databits = 19'h2C4B6;
      6'b010010: databits = 19'h596D3;
      6'b010011: databits = 19'h41A5E;
      6'b010100: databits = 19'h8F9F8;
      6'b010101: databits = 19'h9B060;
      6'b010110: databits = 19'h6E741;
      6'b010111: databits = 19'h3D81F;
      6'b011000: databits = 19'h51C4B;
      6'b011001: databits = 19'h48810;
      6'b011010: databits = 19'h7A937;
      6'b011011: databits = 19'h5B8A5;
      6'b011100: databits = 19'h17FCE;
      6'b011101: databits = 19'h3641B;
      6'b011110: databits = 19'h912ED;
      6'b011111: databits = 19'h2F35A;
      6'b100000: databits = 19'h4A6E1;
      6'b100001: databits = 19'h3859D;
      6'b100010: databits = 19'h26832;
      6'b100011: databits = 19'h6CABF;
      6'b100100: databits = 19'h452D4;
      6'b100101: databits = 19'h98F61;
      6'b100110: databits = 19'h570A6;
      6'b100111: databits = 19'h8158D;
      6'b101000: databits = 19'h9C639;
      6'b101001: databits = 19'h5D1F7;
      6'b101010: databits = 19'h832B9;
      6'b101011: databits = 19'h7DCEF;
      6'b101100: databits = 19'h679A5;
      6'b101101: databits = 19'h34BDE;
      6'b101110: databits = 19'h48753;
      6'b101111: databits = 19'h295E4;
      6'b110000: databits = 19'h1C6BA;
      6'b110001: databits = 19'h4F8C2;
      6'b110010: databits = 19'h31E57;
      6'b110011: databits = 19'h6698F;
      6'b110100: databits = 19'h98A1D;
      6'b110101: databits = 19'h4C27E;
      6'b110110: databits = 19'h7B359;
      6'b110111: databits = 19'h5F8E4;
      6'b111000: databits = 19'h2A4D7;
      6'b111001: databits = 19'h799E6;
      6'b111010: databits = 19'h6C93D;
      6'b111011: databits = 19'h489AF;
      6'b111100: databits = 19'h540CE;
      6'b111101: databits = 19'h8BF16;
      6'b111110: databits = 19'h41359;
      6'b111111: databits = 19'h6E72A;
    endcase
endmodule


// Prefix Adder de 8 bits 
module prefix1bit(input  logic a, b,
                  // input  logic g_prev,
                  output logic g, p);
  
  assign g = (a & b);
  assign p = (a | b);
endmodule


module prefix2bit(input  logic [1:0] a, b,
                  // input  logic g_prev,
                  output logic gi, pi);
  
  logic leftgen, rightgen, leftpro, rightpro;
  
  prefix1bit gpleft(a[1], b[1], leftgen, leftpro);
  prefix1bit gpright(a[0], b[0], rightgen, rightpro);

  assign gi = leftgen | (leftpro & rightgen);
  assign pi = leftpro & rightpro;

endmodule


module prefix4bit(input  logic [3:0] a, b,
                  output logic gi, pi);

  logic leftgen, leftpro, rightgen, rightpro;

  prefix2bit gpleft(a[3:2], b[3:2], leftgen, leftpro);
  prefix2bit gpright(a[1:0], b[1:0], rightgen, rightpro);

  assign gi = leftgen | (leftpro & rightgen);
  assign pi = leftpro & rightpro;

endmodule


module prefix8bit(input  logic [7:0] a, b,
                  output logic gi, pi);
            
  logic leftgen, leftpro, rightgen, rightpro;
  
  prefix4bit gp8_left(a[7:4], b[7:4], leftgen, leftpro);
  prefix4bit gp8_right(a[3:0], b[3:0], rightgen, rightpro);

  assign gi = leftgen | (leftpro & rightgen);
  assign pi = leftpro & rightpro;

endmodule


module prefixadder8(input  logic [7:0] a, b,
                    input  logic [0:0] cin,
                    output logic [7:0] s);

  logic [6:0] g, p;
  logic [3:0] g_2, p_2;
  logic [3:0] g_4, p_4;
  logic [3:0] g_8, p_8;
  logic [7:0] a8_cin, b8_cin;
  logic [3:0] a4_cin, b4_cin;
  logic [1:0] a2_cin, b2_cin;
  
  
  assign a8_cin = {a[6:0], cin};
  assign b8_cin = {b[6:0], 1'b0};
  assign a4_cin = {a[2:0], cin};
  assign b4_cin = {b[2:0], 1'b0};
  assign a2_cin = {a[0], cin};
  assign b2_cin = {b[0], 1'b0};
  
     
  prefix1bit p1_0(a[0], b[0], g[0], p[0]);
  prefix1bit p1_1(a[1], b[1], g[1], p[1]);
  prefix1bit p1_2(a[2], b[2], g[2], p[2]);
  prefix1bit p1_3(a[3], b[3], g[3], p[3]);
  prefix1bit p1_4(a[4], b[4], g[4], p[4]);
  prefix1bit p1_5(a[5], b[5], g[5], p[5]);
  prefix1bit p1_6(a[6], b[6], g[6], p[6]);


  prefix8bit block8(a8_cin, b8_cin, g_8[3], p_8[3]);
  
  prefix4bit block4_L(a[6:3], b[6:3], g_4[3], p_4[3]);
  
  prefix2bit block2_LL(a[6:5], b[6:5], g_2[3], p_2[3]);
  prefix2bit block2_LR(a[4:3], b[4:3], g_2[2], p_2[2]);

  prefix4bit block4_R(a4_cin, b4_cin, g_4[1], p_4[1]);

  prefix2bit block2_RL(a[2:1], b[2:1], g_2[1], p_2[1]);
  prefix2bit block2_RR(a2_cin, b2_cin, g_2[0], p_2[0]);

  assign g_4[2] = g[5] | (p[5] & g_2[2]);
  assign p_4[2] = p[5] & p_2[2];

  assign g_4[0] = g[1] | (p[1] & g_2[0]);
  // p_4[0] se ignora

  assign g_8[2] = g_4[2] | (p_4[2] & g_4[1]);
  assign p_8[2] = p_4[2] & p_4[1];
  
  assign g_8[1] = g_2[2] | (p_2[2] & g_4[1]);
  assign p_8[1] = p_2[2] & p_4[1];

  assign g_8[0] = g[3] | (p[3] & g_4[1]);
  

  assign s[7] = (a[7] ^ b[7]) ^ g_8[3];
  assign s[6] = (a[6] ^ b[6]) ^ g_8[2];
  assign s[5] = (a[5] ^ b[5]) ^ g_8[1];
  assign s[4] = (a[4] ^ b[4]) ^ g_8[0];
  assign s[3] = (a[3] ^ b[3]) ^ g_4[1];
  assign s[2] = (a[2] ^ b[2]) ^ g_4[0];
  assign s[1] = (a[1] ^ b[1]) ^ g_2[0];
  assign s[0] = (a[0] ^ b[0]) ^ cin;

endmodule


module splitter(input  logic [18:0] data,
                output logic [2:0] sel,
                output logic [7:0] inmA, inmB);
  
  assign sel = data [18:16];
  assign inmA = data [15:8];
  assign inmB = data [7:0];
endmodule


module ALU_main(input  logic [7:0] inm_A, inm_B,
           input  logic [2:0] select,
           output logic [7:0] result);
  
  logic [7:0] sum_result, sub_result, bleft, bright, and_res, or_res, xor_res, invA, invB;
  logic cin = 0;

  
  prefixadder8 sum(inm_A, inm_B, cin, sum_result);
  
  not8 invert_sub(inm_B, inm_A, invB);

  prefixadder8 sub(inm_A, (~inm_B + 1'b1), cin, sub_result);

  shift_left shift_L(inm_A, inm_B, bleft);

  shift_right shift_R(inm_A, inm_B, bright);

  and8 comp(inm_A, inm_B, and_res);

  or8 dis(inm_A, inm_B, or_res);

  xor8 exc(inm_A, inm_B, xor_res);

  not8 invertA(inm_A, inm_B, invA);

  always_comb
    casex (select [2:0])
      3'b000: result = sum_result;
      3'b001: result = sub_result;
      3'b010: result = bleft;
      3'b011: result = bright;
      3'b100: result = and_res;
      3'b101: result = or_res;
      3'b110: result = xor_res;
      3'b111: result = invA;
    endcase
endmodule
  

module main(input  logic clock,reset,
            output logic [7:0] result, inmediato_A, inmediato_B,
            output logic [2:0] select,
            output logic [18:0] databits);
  
  logic [5:0] address;

  counter6 count(clock, reset, address);

  ROM datarom(address, databits);

  splitter split(databits, select, inmediato_A, inmediato_B);

  ALU_main ALU(inmediato_A, inmediato_B, select, result);

endmodule

