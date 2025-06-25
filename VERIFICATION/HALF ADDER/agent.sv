class ha_agent extends uvm_agent;

  `uvm_component_utils(ha_agent)

  ha_monitor mon;
  ha_sequencer seqr;
  ha_driver drv;

  function new(string name = "ha_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    mon  = ha_monitor  ::type_id::create("mon", this);
    seqr = ha_sequencer::type_id::create("seqr", this);
    drv  = ha_driver   ::type_id::create("drv", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    `uvm_info("Agent class", "Connect phase", UVM_MEDIUM)
    
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass
