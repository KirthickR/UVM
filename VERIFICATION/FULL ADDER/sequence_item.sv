class fa_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(fa_seq_item);
  
  rand bit a;
  rand bit b;
  rand bit c;
  bit sum;
  bit carry;
  
  function new(string name = "ha_seq_item");
    super.new(name);
  endfunction
  
endclass
  
  
