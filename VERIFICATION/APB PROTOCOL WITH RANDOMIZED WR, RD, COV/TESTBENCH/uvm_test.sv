`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_test extends uvm_test;

  `uvm_component_utils(apb_test)

  apb_env env;

  // Sequence handles
  apb_wr_sequence      #(32,32) wr_seq;
  apb_rd_sequence      #(32,32) rd_seq;
  apb_basic_seq        #(32,32) rand_seq;   // randomized mixed traffic

  function new(string name="apb_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_env::type_id::create("env", this);

    uvm_config_db#(uvm_active_passive_enum)::set(
      this, "env.agent", "is_active", UVM_ACTIVE);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    //--------------------------------------------------
    // 1️⃣ WRITE sequence
    //--------------------------------------------------
    `uvm_info("TEST", "Starting WRITE sequence", UVM_LOW)

    wr_seq = apb_wr_sequence#(32,32)::type_id::create("wr_seq");
    wr_seq.start(env.agent.sequencer);


    //--------------------------------------------------
    // 2️⃣ READ sequence
    //--------------------------------------------------
    `uvm_info("TEST", "Starting READ sequence", UVM_LOW)

    rd_seq = apb_rd_sequence#(32,32)::type_id::create("rd_seq");
    rd_seq.start(env.agent.sequencer);


    //--------------------------------------------------
    // 3️⃣ RANDOMIZED mixed traffic
    //--------------------------------------------------
    `uvm_info("TEST", "Starting RANDOM mixed sequence", UVM_LOW)

    rand_seq = apb_basic_seq#(32,32)::type_id::create("rand_seq");
    rand_seq.start(env.agent.sequencer);


    `uvm_info("TEST", "All sequences completed", UVM_LOW)

    phase.drop_objection(this);

  endtask

endclass
