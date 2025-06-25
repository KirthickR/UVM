
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"

module testbench;
  
  intf intff();
  
  ha dut(.a(intff.a),
         .b(intff.b),
         .sum(intff.sum),
         .carry(intff.carry));
  
  initial begin
    
    uvm_config_db#(virtual intf)::set(null,"*","intff",intff);
    
  end
  
  initial begin
    
    run_test("ha_test");
    
  end
  
  initial begin
    
    #700;
    $finish;
  end
endmodule
