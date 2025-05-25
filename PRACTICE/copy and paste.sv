`include "uvm_macros.svh"
import uvm_pkg::*;

class seq_item extends uvm_sequence_item;
  rand bit [3:0] A, B, Cin;

  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(A, UVM_ALL_ON)
    `uvm_field_int(B, UVM_ALL_ON)
    `uvm_field_int(Cin, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "seq_item");
    super.new(name);
  endfunction
endclass

module test;
  seq_item it1, it2, it3;

  initial begin
    it1 = seq_item::type_id::create("it1");
    it2 = seq_item::type_id::create("it2");
    it3 = seq_item::type_id::create("it3");

    it1.randomize();
    it1.print();
    
    it1.randomize();
    it1.print();
    it2.print();

    it2.copy(it1);
    it2.print();

    it3.copy(it1);
    it3.print();
 
    it1.randomize();
    it1.print();
    it2.print();

    it2.copy(it1);
    it2.print();

    it3.copy(it1);
    it3.print();
  end
endmodule
































































// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it1    seq_item  -     @1799
//   A    integral  4     'h4  
//   B    integral  4     'hd  
//   Cin  integral  4     'h5  
// ----------------------------
// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it1    seq_item  -     @1799
//   A    integral  4     'h3  
//   B    integral  4     'h3  
//   Cin  integral  4     'h6  
// ----------------------------
// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it2    seq_item  -     @1809
//   A    integral  4     'h0  
//   B    integral  4     'h0  
//   Cin  integral  4     'h0  
// ----------------------------
// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it2    seq_item  -     @1809
//   A    integral  4     'h3  
//   B    integral  4     'h3  
//   Cin  integral  4     'h6  
// ----------------------------
// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it3    seq_item  -     @1811
//   A    integral  4     'h3  
//   B    integral  4     'h3  
//   Cin  integral  4     'h6  
// ----------------------------
// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it1    seq_item  -     @1799
//   A    integral  4     'h1  
//   B    integral  4     'hd  
//   Cin  integral  4     'h9  
// ----------------------------
// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it2    seq_item  -     @1809
//   A    integral  4     'h3  
//   B    integral  4     'h3  
//   Cin  integral  4     'h6  
// ----------------------------
// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it2    seq_item  -     @1809
//   A    integral  4     'h1  
//   B    integral  4     'hd  
//   Cin  integral  4     'h9  
// ----------------------------
// ----------------------------
// Name   Type      Size  Value
// ----------------------------
// it3    seq_item  -     @1811
//   A    integral  4     'h1  
//   B    integral  4     'hd  
//   Cin  integral  4     'h9  
// ----------------------------
