class ha_sequencer extends uvm_sequencer#(ha_seq_item);
  
  `uvm_component_utils(ha_sequencer)
  
  function new(string name ="ha_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
