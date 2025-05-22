`include "uvm_macros.svh"
import uvm_pkg::*;

class seq_item extends uvm_sequence_item;

  rand int arr[2][5];

  constraint c1 {
    foreach (arr[i, j]) {
      arr[i][j] == (i * 5 + j);
    }
  }

  function new(string name = "seq_item");
    super.new(name);
    `uvm_info("Sequence", "Created the object", UVM_DEBUG)
  endfunction

  function void display();
    `uvm_info("Randomized", "2x5 consecutive array:", UVM_LOW)
    foreach (arr[i]) begin
      string line = "";
      foreach (arr[i][j])
        line = {line, $sformatf("%0d ", arr[i][j])};  // Added space
      `uvm_info("Array row", line, UVM_LOW)
    end
  endfunction

endclass

module test;
  seq_item it;

  initial begin
    it = new();

    if (it.randomize()) begin
      it.display();
    end else begin
      $display("Randomization failed.");
    end
    #5;
  end
endmodule





































UVM_INFO testbench.sv(20) @ 0: reporter@@seq_item [Randomized] 2x5 consecutive array:
UVM_INFO testbench.sv(25) @ 0: reporter@@seq_item [Array row] 0 1 2 3 4 
UVM_INFO testbench.sv(25) @ 0: reporter@@seq_item [Array row] 5 6 7 8 9 
