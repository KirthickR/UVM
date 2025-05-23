`include "uvm_macros.svh"
import uvm_pkg::*;

class seq_item extends uvm_sequence_item;
  randc logic [3:0] A, B, Cin;

  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(A, UVM_ALL_ON)
    `uvm_field_int(B, UVM_ALL_ON)
    `uvm_field_int(Cin, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "seq_item");
    super.new(name);
  endfunction

  function void display();
    `uvm_info("DATA", $sformatf("A = %b, B = %b, Cin = %b", A, B, Cin), UVM_LOW)
  endfunction
endclass

module test;
  seq_item it;

  initial begin
//     it = seq_item::type_id::create();
    it=new();
    repeat (4) begin
      it.randomize();
//         it.display();
      it.print();
    
    end
  end
endmodule



















// -------------------------------
// Name      Type      Size  Value
// -------------------------------
// seq_item  seq_item  -     @1798
//   A       integral  4     'h5  
//   B       integral  4     'h5  
//   Cin     integral  4     'h3  
// -------------------------------
// -------------------------------
// Name      Type      Size  Value
// -------------------------------
// seq_item  seq_item  -     @1798
//   A       integral  4     'he  
//   B       integral  4     'h7  
//   Cin     integral  4     'h6  
// -------------------------------
// -------------------------------
// Name      Type      Size  Value
// -------------------------------
// seq_item  seq_item  -     @1798
//   A       integral  4     'hd  
//   B       integral  4     'h0  
//   Cin     integral  4     'hb  
// -------------------------------
// -------------------------------
// Name      Type      Size  Value
// -------------------------------
// seq_item  seq_item  -     @1798
//   A       integral  4     'h7  
//   B       integral  4     'h8  
//   Cin     integral  4     'h8  
// -------------------------------









`include "uvm_macros.svh"
import uvm_pkg::*;

class seq_item extends uvm_sequence_item;
  randc logic [3:0] A, B, Cin;

  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(A, UVM_ALL_ON)
    `uvm_field_int(B, UVM_ALL_ON)
    `uvm_field_int(Cin, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "seq_item");
    super.new(name);
  endfunction

  function void display();
    `uvm_info("DATA", $sformatf("A = %b, B = %b, Cin = %b", A, B, Cin), UVM_LOW)
  endfunction
endclass

module test;
  seq_item it;

  initial begin
    it = seq_item::type_id::create();
    //     it=new();     // this line and above line are same and it is used to create object for the above class
    repeat (4) begin
      it.randomize();
        it.display();
//       it.print();
    
    end
  end
endmodule

// UVM_INFO testbench.sv(18) @ 0: reporter@@seq_item [DATA] A = 0101, B = 0101, Cin = 0011
// UVM_INFO testbench.sv(18) @ 0: reporter@@seq_item [DATA] A = 1110, B = 0111, Cin = 0110
// UVM_INFO testbench.sv(18) @ 0: reporter@@seq_item [DATA] A = 1101, B = 0000, Cin = 1011
// UVM_INFO testbench.sv(18) @ 0: reporter@@seq_item [DATA] A = 0111, B = 1000, Cin = 1000
