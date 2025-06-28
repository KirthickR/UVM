class fa_sequencer extends uvm_sequencer#(fa_seq_item);
  
  `uvm_component_utils(fa_sequencer)
  
  function new(string name ="fa_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
