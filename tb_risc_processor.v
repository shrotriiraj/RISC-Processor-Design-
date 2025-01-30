module tb_risc_processor;
  reg clk, reset;
  
  // Instantiate processor
  risc_processor uut (clk, reset);
  
  // Clock generation
  always #5 clk = ~clk;
  
  initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    
    // Reset sequence
    #10 reset = 0;
    
    // Test case 1: ADD instruction
    // Load instructions.hex with test program
    #100;
    
    // Test case 2: Data hazard (requires forwarding)
    #100;
    
    // Test case 3: Branch instruction (BEQ)
    #100;
    
    $finish;
  end
  
  // Monitor results
  always @(posedge clk) begin
    $display("PC: %h, Reg[5]: %h", uut.IF_ID_PC, uut.reg_file[5]);
  end
endmodule
