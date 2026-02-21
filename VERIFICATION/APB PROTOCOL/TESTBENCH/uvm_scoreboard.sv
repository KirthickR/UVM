class apb_scoreboard #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_scoreboard;

  `uvm_component_param_utils(apb_scoreboard #(ADDR_WIDTH, DATA_WIDTH))

  // ----------------------------------
  // Analysis implementation
  // ----------------------------------
  uvm_analysis_imp #(
    apb_seq_item #(ADDR_WIDTH, DATA_WIDTH),
    apb_scoreboard #(ADDR_WIDTH, DATA_WIDTH)
  ) item_collected_imp;

  // ----------------------------------
  // Reference model memory
  // ----------------------------------
  bit [DATA_WIDTH-1:0] mem [bit [ADDR_WIDTH-1:0]];

  // ----------------------------------
  // Constructor
  // ----------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_imp = new("item_collected_imp", this);
  endfunction

  // ----------------------------------
  // WRITE method (called by monitor)
  // ----------------------------------
  function void write(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH) txn);

    // ---------------- ERROR RESPONSE ----------------
    if (txn.error) begin
      `uvm_warning("APB_SCB",
        $sformatf("ERROR response at addr=0x%0h", txn.addr))
      return;
    end

    // ---------------- WRITE TRANSACTION ----------------
    if (txn.write) begin
      if (!mem.exists(txn.addr))
        mem[txn.addr] = '0;

      // Apply byte strobes (same as DUT)
      if (txn.wstrb[0]) mem[txn.addr][7:0]   = txn.wdata[7:0];
      if (txn.wstrb[1]) mem[txn.addr][15:8]  = txn.wdata[15:8];
      if (txn.wstrb[2]) mem[txn.addr][23:16] = txn.wdata[23:16];
      if (txn.wstrb[3]) mem[txn.addr][31:24] = txn.wdata[31:24];

      `uvm_info("APB_SCB",
        $sformatf("WRITE PASS | addr=0x%0h data=0x%0h strobe=0x%0h",
                  txn.addr, txn.wdata, txn.wstrb),
        UVM_LOW)

    end

    // ---------------- READ TRANSACTION ----------------
    else begin
      if (!mem.exists(txn.addr)) begin
        `uvm_error("APB_SCB",
          $sformatf("READ FAIL | addr=0x%0h (unwritten address)", txn.addr))
      end
      else if (mem[txn.addr] !== txn.rdata) begin
        `uvm_error("APB_SCB",
          $sformatf(
            "READ FAIL | addr=0x%0h EXP=0x%0h ACT=0x%0h",
            txn.addr, mem[txn.addr], txn.rdata))
      end
      else begin
        `uvm_info("APB_SCB",
          $sformatf(
            "READ PASS | addr=0x%0h data=0x%0h",
            txn.addr, txn.rdata),
          UVM_LOW)
      end
    end

  endfunction

endclass
