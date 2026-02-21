

class apb_basic_seq #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_sequence #(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH));

  `uvm_object_param_utils(apb_basic_seq #(ADDR_WIDTH, DATA_WIDTH))

  // Constructor
  function new(string name = "apb_basic_seq");
    super.new(name);
  endfunction

  // --------------------------------------------------
  // Sequence body : RANDOM traffic
  // --------------------------------------------------
  task body();
    apb_seq_item #(ADDR_WIDTH, DATA_WIDTH) req;

    `uvm_info("SEQ", "Starting RANDOM APB sequence", UVM_LOW)

    // Generate multiple random transactions
    repeat (10) begin
      req = apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("req");

      start_item(req);
        if (!req.randomize()) begin
          `uvm_error("SEQ", "Randomization failed")
        end
      finish_item(req);

      // Print what was generated
      if (req.write) begin
        `uvm_info("SEQ",
          $sformatf(
            "WRITE txn | addr=%0d data=%0d strobe=%0d",
            req.addr, req.wdata, req.wstrb
          ),
          UVM_LOW
        )
      end
      else begin
        `uvm_info("SEQ",
          $sformatf(
            "READ txn  | addr=%0d",
            req.addr
          ),
          UVM_LOW
        )
      end
    end

    `uvm_info("SEQ", "Random APB sequence completed", UVM_LOW)

  endtask

endclass
