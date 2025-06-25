class ha_driver extends uvm_driver#(ha_seq_item);

  `uvm_component_utils(ha_driver)

      virtual intf intff;
  ha_seq_item tx;

  function new(string name = "ha_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("Driver class", "constructor", UVM_MEDIUM)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual intf)::get(this, "*", "intff", intff))
      `uvm_fatal("NOVIF", "Virtual Interface failed in the config db");
  endfunction

  task run_phase(uvm_phase phase);
    repeat(4) begin
      seq_item_port.get_next_item(tx);
      drive(tx);
      seq_item_port.item_done();
    end
  endtask

  task drive(ha_seq_item tx);
    intff.a = tx.a;
    intff.b = tx.b;

    `uvm_info("DRIVE TASK", $sformatf("TIME=%0t, a=%b, b=%b", $time, intff.a, intff.b), UVM_LOW);
    
#3;
  endtask

endclass
