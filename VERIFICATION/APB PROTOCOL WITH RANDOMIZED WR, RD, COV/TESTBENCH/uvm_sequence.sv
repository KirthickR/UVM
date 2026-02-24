class apb_basic_seq #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_sequence #(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH));

  `uvm_object_param_utils(apb_basic_seq #(ADDR_WIDTH, DATA_WIDTH))

  function new(string name = "apb_basic_seq");
    super.new(name);
  endfunction

  task body();

    apb_seq_item #(ADDR_WIDTH, DATA_WIDTH) req;

    `uvm_info("SEQ", "Starting 3 WRITE + 2 READ randomized sequence", UVM_LOW)

    // --------------------------------------------------
    // 3 RANDOM WRITE transactions
    // --------------------------------------------------
    repeat (3) begin
      req = apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("req");

      start_item(req);
        if (!req.randomize() with { write == 1; }) begin
          `uvm_error("SEQ", "WRITE Randomization failed")
        end
      finish_item(req);

      `uvm_info("SEQ",
        $sformatf("WRITE txn | addr=%0h data=%0h strobe=%0h",
          req.addr, req.wdata, req.wstrb),
        UVM_LOW)
    end


    // --------------------------------------------------
    // 2 RANDOM READ transactions
    // --------------------------------------------------
    repeat (2) begin
      req = apb_seq_item #(ADDR_WIDTH, DATA_WIDTH)::type_id::create("req");

      start_item(req);
        if (!req.randomize() with { write == 0; }) begin
          `uvm_error("SEQ", "READ Randomization failed")
        end
      finish_item(req);

      `uvm_info("SEQ",
        $sformatf("READ txn  | addr=%0h",
          req.addr),
        UVM_LOW)
    end

    `uvm_info("SEQ", "Sequence completed", UVM_LOW)

  endtask

endclass
