class fa_scb extends uvm_scoreboard ;
  
  `uvm_component_utils(fa_scb)
  
  uvm_analysis_imp#(fa_seq_item,fa_scb) item_collected_export;
  
  fa_seq_item tx_q[$];
  
  function new(string name = "fa_scb",uvm_component parent);
    super.new(name,parent);
    
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export=new("item_collected_export",this);
  endfunction
  
  function void write(fa_seq_item tx);
  bit expected_sum   = tx.a ^ tx.b ^ tx.c;
  bit expected_carry = (tx.a & tx.b) | (tx.b & tx.c) | (tx.c & tx.a);

  $display("-----------------------------------------------------");

  if ((tx.sum === expected_sum) && (tx.carry === expected_carry)) begin
    `uvm_info("SCOREBOARD = [PASSED]", $sformatf("TIME=%0t,a=%b,b=%b,c=%b,sum=%b,carry=%b", $time, tx.a, tx.b, tx.c, tx.sum, tx.carry), UVM_LOW)
  end
  else begin
    `uvm_error("[SCOREBOARD = [FAILED]", $sformatf("TIME=%0t,a=%b,b=%b,c=%b,sum=%b,carry=%b", $time, tx.a, tx.b, tx.c, tx.sum, tx.carry))
  end

  $display("-----------------------------------------------------");
endfunction
endclass
