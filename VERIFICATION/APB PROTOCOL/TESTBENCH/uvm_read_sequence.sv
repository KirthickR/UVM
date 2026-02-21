`ifndef RD_SEQUENCE_SV
`define RD_SEQUENCE_SV

class apb_rd_sequence #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_sequence #(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH));

  `uvm_object_param_utils(apb_rd_sequence #(ADDR_WIDTH, DATA_WIDTH))

  // Constructor
  function new(string name = "apb_rd_sequence");
    super.new(name);
  endfunction

  // --------------------------------------------------
  // Body : Directed READ transaction
  // --------------------------------------------------
  task body();

    apb_seq_item #(ADDR_WIDTH, DATA_WIDTH) req;

    `uvm_info("RD_SEQ", "Starting APB READ sequence", UVM_LOW)

    // Create transaction
    req = apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("req");

    start_item(req);

      // Directed values
      req.write = 1'b0;                    // READ
      req.addr  = 32'h0000_0010;           // Address to read
      req.wdata = '0;                      // Not used
      req.wstrb = '0;                      // Not used

    finish_item(req);

    `uvm_info("RD_SEQ",
      $sformatf("READ txn | addr=0x%0h",
                req.addr),
      UVM_LOW)

    `uvm_info("RD_SEQ", "APB READ sequence completed", UVM_LOW)

  endtask

endclass

`endif
