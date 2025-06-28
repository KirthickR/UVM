class fa_env extends uvm_env;

  `uvm_component_utils(fa_env)

  fa_agent agt;
  fa_scb   scb;

  function new(string name = "fa_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agt = fa_agent::type_id::create("agt", this);
    scb = fa_scb::type_id::create("scb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info("ENV class", "connect phase", UVM_MEDIUM)
    agt.mon.item_collected_port.connect(scb.item_collected_export);
  endfunction
endclass
