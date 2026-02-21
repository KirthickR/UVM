`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_test extends uvm_test;

  `uvm_component_utils(apb_test)

  // ----------------------------------
  // Environment handle
  // ----------------------------------
  apb_env env;

  // Sequence handles
  apb_wr_sequence  #(32,32) wr_seq;
  apb_rd_sequence  #(32,32) rd_seq;

  // ----------------------------------
  // Constructor
  // ----------------------------------
  function new(string name = "apb_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // ----------------------------------
  // Build phase
  // ----------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_env::type_id::create("env", this);

    // Configure agent as ACTIVE
    uvm_config_db#(uvm_active_passive_enum)::set(
      this, "env.agent", "is_active", UVM_ACTIVE);
  endfunction

  // ----------------------------------
  // Run phase
  // ----------------------------------
  task run_phase(uvm_phase phase);

  apb_wr_sequence #(32,32) wr_seq;
  apb_rd_sequence #(32,32) rd_seq;

  phase.raise_objection(this);

  `uvm_info("TEST", "Starting WRITE followed by READ", UVM_LOW)

  // Create sequences
  wr_seq = apb_wr_sequence#(32,32)::type_id::create("wr_seq");
  rd_seq = apb_rd_sequence#(32,32)::type_id::create("rd_seq");

  // 1️⃣ Start WRITE first
  wr_seq.start(env.agent.sequencer);

  // 2️⃣ After write completes, start READ
  rd_seq.start(env.agent.sequencer);

  `uvm_info("TEST", "WRITE-READ test completed", UVM_LOW)

  phase.drop_objection(this);

endtask

endclass
