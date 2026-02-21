class apb_monitor #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_monitor;

  `uvm_component_param_utils(apb_monitor #(ADDR_WIDTH, DATA_WIDTH))

  // Virtual interface
  virtual apb_if #(ADDR_WIDTH, DATA_WIDTH) vif;

  // Analysis port
  uvm_analysis_port #(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)) ap;

  // -------------------------------------------------
  // Constructor
  // -------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  // -------------------------------------------------
  // Build phase
  // -------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(
          virtual apb_if #(ADDR_WIDTH, DATA_WIDTH)
        )::get(this, "", "vif", vif)) begin
      `uvm_fatal("APB_MON", "Virtual interface not set")
    end
  endfunction

  // -------------------------------------------------
  // Run phase (FIXED)
  // -------------------------------------------------
 task run_phase(uvm_phase phase);
    apb_seq_item #(ADDR_WIDTH, DATA_WIDTH) txn;

    // 1. Wait for reset release (using raw signal is fine here)
    wait (vif.PRESETn === 1'b1);
    
    `uvm_info("APB_MON", "Monitor started and waiting for handshake...", UVM_LOW)

    forever begin
      // 2. Sync to the clocking block edge
      @(vif.mon_cb); 

      // 3. Use the clocking block signals for the condition
      if (vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY) begin
        
        txn = apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("txn");

        // 4. Capture data from the clocking block
        txn.addr  = vif.mon_cb.PADDR;
        txn.write = vif.mon_cb.PWRITE;
        txn.error = vif.mon_cb.PSLVERR;

        if (vif.mon_cb.PWRITE) begin
          txn.wdata = vif.mon_cb.PWDATA;
          txn.wstrb = vif.mon_cb.PSTRB;
        end else begin
          txn.rdata = vif.mon_cb.PRDATA;
        end

        // 5. Broadcast to scoreboard
        ap.write(txn);

        `uvm_info("APB_MON", $sformatf("Captured %s | addr=%0h", 
                  txn.write ? "WRITE" : "READ", txn.addr), UVM_LOW)
      end
    end
  endtask

endclass
