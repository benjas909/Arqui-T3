module maintestbench();

  reg clk = 0;
  reg reset;
  logic [7:0] result, inm_A, inm_B;
  logic [2:0] select;
  logic [18:0] databits;

  main dut(clk, reset,  result, inm_A, inm_B, select, databits);
  
  always
  begin
    #5 clk = 1;
    #5 clk = 0;
  end
  
  initial
    begin
      reset = 1; #27; reset = 0;
    end
  
  	
  task display;
    begin
      $display("%h	%b	%b	%b	%b", databits, select, inm_A, inm_B, result);  
    end
  endtask
  
  initial begin
    $display("INS | OP |	  A 	 |	  B	  |	  R	 |");
    repeat (64) begin
      #10;
      display; 
    end
    $finish; 
  end
  
endmodule
