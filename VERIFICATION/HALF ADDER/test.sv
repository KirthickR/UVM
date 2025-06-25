class ha_test extends uvm_test;
  
  `uvm_component_utils(ha_test)
  
  ha_sequence seq;
  ha_env env;
  
  function new(string name = "ha_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env=ha_env::type_id::create("env",this);
    seq=ha_sequence::type_id::create("seq",this);
  endfunction
  
  virtual function  void end_of_eloboration();
    `uvm_info("Test class","Eloboration phase",UVM_MEDIUM)
    print();
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    repeat(4)begin
      seq.start(env.agt.seqr);
      #15;
    end
      
      phase.drop_objection(this);
      endtask
      endclass
      
  
