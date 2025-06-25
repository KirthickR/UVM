class ha_monitor extends uvm_monitor;

  `uvm_component_utils(ha_monitor)

  virtual intf intff;
  ha_seq_item tx;
  uvm_analysis_port#(ha_seq_item) item_collected_port;

  function new(string name = "ha_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual intf)::get(this, "*", "intff", intff)) begin
      `uvm_fatal("NOVIF", "Virtual Interface get failed")
    end
  endfunction

  task run_phase(uvm_phase phase);
    repeat(4) begin
      #1;
      tx = ha_seq_item::type_id::create("tx");
      tx.a     = intff.a;
      tx.b     = intff.b;
     
      tx.sum   = intff.sum;
      tx.carry = intff.carry;
      

      `uvm_info("MONITOR TASK", $sformatf("TIME=%0t, a=%b, b=%b, sum=%b, carry=%b", 
                $time, tx.a, tx.b, tx.sum, tx.carry), UVM_LOW)

      item_collected_port.write(tx);
      #2;
    end
  endtask

endclass
