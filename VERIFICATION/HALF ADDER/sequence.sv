class ha_sequence extends uvm_sequence;
  
  `uvm_object_utils(ha_sequence)
  
  ha_seq_item tx;
  
  function new(string name = "ha_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(4)begin
      tx=ha_seq_item ::type_id::create("tx");
      
      start_item(tx);
      tx.randomize();
      finish_item(tx);
      
    end
  endtask
endclass
