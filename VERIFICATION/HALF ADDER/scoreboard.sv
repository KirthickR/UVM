class ha_scb extends uvm_scoreboard;

  `uvm_component_utils(ha_scb)

  uvm_analysis_imp#(ha_seq_item, ha_scb) item_collected_export;

  
  ha_seq_item tx_q[$];

  function new(string name = "ha_scb", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    item_collected_export = new("item_collected_export", this);
  endfunction

  function void write(ha_seq_item tx);
//     fork
//       begin
    bit expected_sum   = tx.a ^ tx.b;    
    bit expected_carry = tx.a & tx.b;
$display("_______________________________________________");
    if ((tx.sum === expected_sum) && (tx.carry === expected_carry)) begin
      `uvm_info("SCOREBOARD=[PASSED]",
                $sformatf("TIME=%0t, a=%b, b=%b, sum=%b, carry=%b",
                          $time, tx.a, tx.b, tx.sum, tx.carry),
                UVM_LOW)
    end else begin
      `uvm_error("SCOREBOARD=[FAILED]",
                 $sformatf("TIME=%0t, a=%b, b=%b, sum=%b, carry=%b",
                           $time, tx.a, tx.b, tx.sum, tx.carry)) 
    end
          $display("_______________________________________________");
//       end
//     join_none
  endfunction

endclass
