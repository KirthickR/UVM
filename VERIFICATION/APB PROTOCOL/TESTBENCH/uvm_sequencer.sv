class apb_sequencer #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_sequencer #(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH));

  `uvm_component_param_utils(apb_sequencer #(ADDR_WIDTH, DATA_WIDTH))

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
