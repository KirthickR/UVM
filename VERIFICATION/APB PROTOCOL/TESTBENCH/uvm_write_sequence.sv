`ifndef WR_SEQUENCE_SV
`define WR_SEQUENCE_SV

class apb_wr_sequence #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_sequence #(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH));

  `uvm_object_param_utils(apb_wr_sequence #(ADDR_WIDTH, DATA_WIDTH))

  // Constructor
  function new(string name = "apb_wr_sequence");
    super.new(name);
  endfunction

  // --------------------------------------------------
  // Body : Directed WRITE transaction
  // --------------------------------------------------
  task body();

    apb_seq_item #(ADDR_WIDTH, DATA_WIDTH) req;

    `uvm_info("WR_SEQ", "Starting APB WRITE sequence", UVM_LOW)

    // Create transaction
    req = apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("req");

    start_item(req);

      // Directed values
      req.write  = 1'b1;
      req.addr   = 32'h0000_0010;
      req.wdata  = 32'hA5A5_A5A5;
      req.wstrb  = {DATA_WIDTH/8{1'b1}};  // All bytes enabled

    finish_item(req);

    `uvm_info("WR_SEQ",
      $sformatf("WRITE txn | addr=0x%0h data=0x%0h strobe=0x%0h",
                req.addr, req.wdata, req.wstrb),
      UVM_LOW)

    `uvm_info("WR_SEQ", "APB WRITE sequence completed", UVM_LOW)

  endtask

endclass

`endif
