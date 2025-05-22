`include "uvm_macros.svh"
import uvm_pkg::*;

class seq_item extends uvm_sequence_item;
  rand int a;
  rand int b;
  
  constraint c1 { a >= 0 && a <= 50; b >= 51 && b <= 100;
                a!=20;b!=99;}
  
  function new(string name = "seq_item");
    super.new(name);
    `uvm_info("Sequence", "Created the object", UVM_DEBUG)
  endfunction
  
  function void display();
    `uvm_info("Randomized", $sformatf("a = %0d, b = %0d", a, b), UVM_LOW)
  endfunction
endclass

module test;
  seq_item it;

  initial begin
    it = new();
    repeat (4) begin
      if (it.randomize()) begin
        it.display();
      end else begin
        $display("Randomization failed.");
      end
      #5;
    end
  end
endmodule





















UVM_INFO testbench.sv(19) @ 0: reporter@@seq_item [Randomized] a = 21, b = 80
UVM_INFO testbench.sv(19) @ 5: reporter@@seq_item [Randomized] a = 36, b = 89
UVM_INFO testbench.sv(19) @ 10: reporter@@seq_item [Randomized] a = 34, b = 92
UVM_INFO testbench.sv(19) @ 15: reporter@@seq_item [Randomized] a = 2, b = 88
