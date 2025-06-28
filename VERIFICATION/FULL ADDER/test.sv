class fa_test extends uvm_test;
  
  `uvm_component_utils(fa_test)
  
  fa_sequence seq;
  fa_env env;
  
  function new(string name = "fa_test",uvm_component parent );
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env= fa_env::type_id::create("env",this);
    seq= fa_sequence::type_id::create("seq",this);
    
  endfunction
  
  virtual function void end_of_eloboration();
    `uvm_info("test class","eloboration phase",UVM_MEDIUM)
    print();
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    repeat(8)begin
      seq.start(env.agt.seqr);
      #15;
    end
    
    phase.drop_objection(this);
  endtask
endclass
  
