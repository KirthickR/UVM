`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_env extends uvm_env;

  `uvm_component_utils(apb_env)

  // ----------------------------------
  // Components
  // ----------------------------------
  apb_agent      agent;
  apb_scoreboard scoreboard;

  // ----------------------------------
  // Constructor
  // ----------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // ----------------------------------
  // Build phase
  // ----------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = apb_agent::type_id::create("agent", this);
    scoreboard = apb_scoreboard::type_id::create("scoreboard", this);
  endfunction

  // ----------------------------------
  // Connect phase
  // ----------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect monitor to scoreboard
    agent.monitor.ap.connect(scoreboard.item_collected_imp);
  endfunction

endclass
