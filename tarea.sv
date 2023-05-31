// USADOS EN LA TAREA

module mux2(input  logic [1:0] d,
            input  logic s,
            output logic y);

  assign y = s ? d[1] : d[0];
endmodule


module mux4(input  logic [3:0] d,
            input  logic [1:0] s,
            output logic y);

  logic low, high;

  mux2 lowmux(d[0], d[1], s[0], low);
  mux2 highmux(d[2], d[3], s[0], high);
  mux2 finalmux(low, high, s[1], y);
endmodule



module mux8(input  logic [7:0] d1, d2,
            input  logic [2:0] s,
            output logic y);

  logic low, high;

  mux4 mux4_low(d[7:4], s[1:0], low);
  mux4 mux4_high(d[3:0], s[1:0], high);

  mux2 mux2_center({low, high}, s[2], y);
endmodule

//Intentar implementar shifts


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
           output logic [18:0] databits);

  always_comb
    case (address)
      6'h0: databits = 19'b0000001011100010011;
      6'h1: databits = 19'b0010000011101001100;
      6'h2: databits = 19'b0100001111100000101;
      6'h3: databits = 19'b0110001111100000010;
      6'h4: databits = 19'b1000101110101010010;
      6'h5: databits = 19'b1010101110101010010;
      6'h6: databits = 19'b1100101110101010010;
      6'h7: databits = 19'b1110101110100000000;
      6'h8: databits = 19'b0000101001100010110;
      6'h9: databits
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

endmodule/*
module ALU(input  logic [2:0] select,
           input  logic [7:0] inm_A, inm_B,
           output logic [7:0] result);

  mux8 alu_mux(inm_A, inm_B, select, inm_A, inm_B);
  */[7:0] s);
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
  
     

  assign g_minus1 = cin;
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

module splitter(input  logic [18:0] data
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

  
  prefixadder8 sum(inm_A, inm_B, 1'b0, sum_result);
  
  not8 invert_sub(inm_B, inm_A, invB);

  prefixadder8 sub(inm_A, invB, 1'b0, sub_result);

  shift_left shift_L(inm_A, inm_B, bleft);

  shift_right shift_R(inm_A, inm_B, bright);

  and8 comp(inm_A, inm_B, and_res);

  or8 dis(inm_A. inm_B, or_res);

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
  




module main(input  logic clock,
            output logic [7:0] result);
  
  logic reset;
  logic [5:0] address;
  logic [18:0] databits;
  logic [2:0] select;
  logic [7:0] inmediato_A, inmediato_B;

  
  counter count(clock, reset, address);

  ROM datarom(address, databits);

  splitter split(databits, select, inmediato_A, inmediato_B);

  ALU ALU_main(inmediato_A, inmediato_B, select, result);

endmodule

