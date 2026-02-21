class apb_seq_item #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_sequence_item;

 
  rand bit [ADDR_WIDTH-1:0]   addr;
  rand bit                    write;
  rand bit [DATA_WIDTH-1:0]   wdata;
  rand bit [DATA_WIDTH/8-1:0] wstrb;

  bit  [DATA_WIDTH-1:0]       rdata;
  bit                         error;

  // -----------------------------
  // Constraints
  // -----------------------------
  constraint addr_align_c {
    addr[1:0] == 2'b00;
  }

  constraint strobe_c {
    write == 0 -> wstrb == '0;
  }

  // -----------------------------
  // UVM macros
  // -----------------------------
  `uvm_object_param_utils_begin(apb_seq_item #(ADDR_WIDTH, DATA_WIDTH))
    `uvm_field_int(addr , UVM_ALL_ON)
    `uvm_field_int(write, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(wstrb, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(error, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction

endclass
