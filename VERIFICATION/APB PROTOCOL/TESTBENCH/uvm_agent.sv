class apb_agent #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_agent;

  `uvm_component_param_utils(apb_agent #(ADDR_WIDTH, DATA_WIDTH))

  // ----------------------------------
  // Agent components
  // ----------------------------------
  apb_sequencer #(ADDR_WIDTH, DATA_WIDTH) sequencer;
  apb_driver    #(ADDR_WIDTH, DATA_WIDTH) driver;
  apb_monitor   #(ADDR_WIDTH, DATA_WIDTH) monitor;

  // ----------------------------------
  // Agent mode
  // ----------------------------------
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // ----------------------------------
  // Build phase
  // ----------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get agent mode from config DB (optional)
    uvm_config_db#(uvm_active_passive_enum)::get(
      this, "", "is_active", is_active);

    // Monitor is always created
    monitor = apb_monitor #(ADDR_WIDTH, DATA_WIDTH)
                ::type_id::create("monitor", this);

    // Create sequencer and driver only if ACTIVE
    if (is_active == UVM_ACTIVE) begin
      sequencer = apb_sequencer #(ADDR_WIDTH, DATA_WIDTH)
                    ::type_id::create("sequencer", this);
      driver    = apb_driver #(ADDR_WIDTH, DATA_WIDTH)
                    ::type_id::create("driver", this);
    end
  endfunction

  // ----------------------------------
  // Connect phase
  // ----------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (is_active == UVM_ACTIVE) begin
      // Connect sequencer to driver
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass
