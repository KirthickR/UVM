class ha_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(ha_seq_item);
  
  rand bit a;
  rand bit b;
  bit sum;
  bit carry;
  
  function new(string name = "ha_seq_item");
    super.new(name);
  endfunction
  
endclass
  
  
