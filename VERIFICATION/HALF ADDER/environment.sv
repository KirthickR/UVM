class ha_env extends uvm_env;
  
  `uvm_component_utils(ha_env)
  
  ha_agent agt;
  ha_scb scb;
  
  function new(string name = "ha_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agt = ha_agent::type_id::create("agt", this);
    scb = ha_scb::type_id::create("scb", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    `uvm_info("Env class", "connect phase", UVM_MEDIUM);
    
    agt.mon.item_collected_port.connect(scb.item_collected_export);
  endfunction

endclass
