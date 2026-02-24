`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_monitor #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_monitor;

  `uvm_component_param_utils(apb_monitor #(ADDR_WIDTH, DATA_WIDTH))

  // Virtual interface
  virtual apb_if #(ADDR_WIDTH, DATA_WIDTH) vif;

  // Analysis port
  uvm_analysis_port #(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if #(ADDR_WIDTH, DATA_WIDTH))::get(this, "", "vif", vif)) begin
      `uvm_fatal("APB_MON", "Virtual interface not set")
    end
  endfunction

  // -------------------------------------------------
  // Run phase - Properly handles PREADY wait states
  // -------------------------------------------------
  task run_phase(uvm_phase phase);
    apb_seq_item #(ADDR_WIDTH, DATA_WIDTH) txn;

    // Wait for reset to be de-asserted
    wait (vif.PRESETn == 1);
    `uvm_info("APB_MON", "Monitor started", UVM_LOW)

    forever begin
      @(posedge vif.PCLK);

      // 1. Detect the SETUP Phase (PSEL is high, PENABLE is low)
      if (vif.PSEL && !vif.PENABLE) begin
        
        // 2. Advance to ACCESS Phase and wait for PREADY
        // This loop handles slaves that hold PREADY low for multiple cycles
        do begin
          @(posedge vif.PCLK);
        end while (vif.PSEL && !vif.PREADY);

        // 3. Handshake complete! Create and fill the transaction object
        txn = apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("txn");

        txn.addr  = vif.PADDR;
        txn.write = vif.PWRITE;
        txn.error = (vif.PSLVERR === 1'b1); // Defensive against 'x'

        if (vif.PWRITE) begin
          txn.wdata = vif.PWDATA;
          txn.wstrb = vif.PSTRB;
        end else begin
          txn.rdata = vif.PRDATA;
        end

        // 4. Send to coverage and scoreboard
        ap.write(txn);

        `uvm_info("APB_MON",
          $sformatf("Captured %s | Addr=%0h | Data=%0h | PREADY wait observed",
            txn.write ? "WRITE" : "READ", txn.addr, (txn.write ? txn.wdata : txn.rdata)),
          UVM_HIGH)
      end
    end
  endtask

endclass
