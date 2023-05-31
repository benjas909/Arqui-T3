module testprefixadder();
  logic [7:0] a, b;
  logic cin;
  logic [7:0] s;
  
  
  prefixadder8 add_test(a, b, cin, s);
  
  initial begin
    a = 8'b00010111; b = 8'b00010011; cin = 0; #27;
    assert (s === 8'b0101010) else $error ("first sum failed");
    a = 8'b00000111; b = 8'b01001100; cin = 0; #10;
    assert (s === 8'b01010011) else $error ("second sum failed");
    
  end
endmodule


/*
module test1bitprefix();
  logic a, b, g, p;
  
  prefix1bit dut(a, b, g, p);
  
  initial begin
    a = 0; b = 0; #10;
    assert (g === 0 & p === 0) else $error("00 failed");
    $display ("00, g = %b, p = %b", g, p);
    b = 1;		  #10;
    assert (g === 0 & p === 1) else $error("01 failed");
    $display ("01, g = %b, p = %b", g, p);
    a = 1; b = 0; #10;
    assert (g === 0 & p === 1) else $error("10 failed");
    $display ("10, g = %b, p = %b", g, p);
    b = 1;        #10;
    assert (g === 1 & p === 1) else $error("11 failed");
    $display ("11, g = %b, p = %b", g, p);
  end
endmodule



module test2bitprefix();
  logic 	   clk, reset;
  logic [1:0]  a, b, gp_expected;
  logic 	   gi, pi;
  logic [31:0] vectornum, errors;
  logic [5:0]  testvectors[10000:0];
  
  prefix2bit dut(a, b, gi, pi);
  
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end
  
  initial
    begin
      $readmemb("inputs.tv", testvectors);
      vectornum = 0; errors = 0;
      reset = 1; #27; reset = 0;
    end
  
  always @(posedge clk)
    begin
      #1; {a, b, gp_expected} = testvectors[vectornum];
    end
  
  always @(negedge clk)
    if(~reset) begin
      if({gi, pi} !== gp_expected) begin
        $display("Error: inputs = %b, %b", a, b);
        $display("outputs = %b, %b (%b and %b expected)", gi, pi, gp_expected[1], gp_expected[0]);
        errors = errors + 1;
      end
      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 6'bx) begin
        $display("%d tests completed with %d errors", vectornum, errors);
        $finish;
      end
    end
endmodule
*/