class fa_agent extends uvm_agent;
  
  `uvm_component_utils(fa_agent)
  
  fa_sequencer seqr;
  fa_driver drv;
  fa_monitor mon;
  
  function new(string name = "fa_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    seqr = fa_sequencer ::type_id::create("seqr",this);
    drv  = fa_driver    ::type_id::create("drv",this);
    mon  = fa_monitor   ::type_id::create("mon",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    `uvm_info("Agent class","Connect phase",UVM_MEDIUM)
    
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction 
endclass
