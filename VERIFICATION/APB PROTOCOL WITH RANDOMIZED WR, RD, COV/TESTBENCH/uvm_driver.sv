class apb_driver #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_driver #(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH));

  `uvm_component_param_utils(apb_driver #(ADDR_WIDTH, DATA_WIDTH))
  apb_seq_item #(ADDR_WIDTH, DATA_WIDTH) req;

  // Virtual interface
  virtual apb_if #(ADDR_WIDTH, DATA_WIDTH) vif;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // --------------------------------------------------
  // Build phase
  // --------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_if #(ADDR_WIDTH, DATA_WIDTH))::get(
          this, "", "vif", vif)) begin
      `uvm_fatal("APB_DRIVER", "Virtual interface not set")
    end
  endfunction


  // --------------------------------------------------
  // Run phase
  // --------------------------------------------------
  task run_phase(uvm_phase phase);

    

    // --------------------------------------------
    // Initialize signals
    // --------------------------------------------
    vif.start    <= 0;
    vif.write_en <= 0;
    vif.addr     <= '0;
    vif.wdata    <= '0;
    vif.wstrb    <= '0;

    // --------------------------------------------
    // Wait for reset assertion & deassertion
    // --------------------------------------------
    wait (vif.PRESETn == 0);   // wait until reset asserted
    wait (vif.PRESETn == 1);   // wait until reset released
    @(posedge vif.PCLK);       // wait one extra clock

    `uvm_info("DRV", "Reset completed. Driver starting...", UVM_LOW)

    forever begin

      // --------------------------------------------
      // Get transaction
      // --------------------------------------------
      seq_item_port.get_next_item(req);

      `uvm_info("DRV",
        $sformatf("START txn @%0t | %s | addr=%0h wdata=%0h strobe=%0h",
          $time,
          req.write ? "WRITE" : "READ",
          req.addr,
          req.wdata,
          req.wstrb),
        UVM_LOW
      )

      // --------------------------------------------
      // Apply control signals
      // --------------------------------------------
      @(posedge vif.PCLK);

      vif.addr     <= req.addr;
      vif.write_en <= req.write;
      vif.wdata    <= req.wdata;
      vif.wstrb    <= req.write ? req.wstrb : '0;
      vif.start    <= 1'b1;    // hold HIGH

      // --------------------------------------------
      // Wait for transaction complete
      // --------------------------------------------
      while (vif.done == 0) begin
        @(posedge vif.PCLK);
      end

      // --------------------------------------------
      // Deassert start after completion
      // --------------------------------------------
      vif.start <= 1'b0;

      // --------------------------------------------
      // Capture read data
      // --------------------------------------------
      if (!req.write)
        req.rdata = vif.rdata;

      req.error = vif.error;

      `uvm_info("DRV",
        $sformatf("DONE txn @%0t | %s | addr=%0h rdata=%0h error=%0b",
          $time,
          req.write ? "WRITE" : "READ",
          req.addr,
          req.rdata,
          req.error),
        UVM_LOW
      )

      seq_item_port.item_done();

    end
  endtask

endclass
