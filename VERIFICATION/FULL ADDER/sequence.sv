class fa_sequence extends uvm_sequence;
  
  `uvm_object_utils(fa_sequence)
  
  fa_seq_item tx;
  
  function new(string name = "fa_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(8)begin
      tx=fa_seq_item ::type_id::create("tx");
      
      start_item(tx);
      tx.randomize();
      finish_item(tx);
      
    end
  endtask
endclass
