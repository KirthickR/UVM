class apb_seq_item #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32,
  parameter int DEPTH      = 16
) extends uvm_sequence_item;

  rand bit [ADDR_WIDTH-1:0]   addr;
  rand bit                    write;
  rand bit [DATA_WIDTH-1:0]   wdata;
  rand bit [DATA_WIDTH/8-1:0] wstrb;

  bit  [DATA_WIDTH-1:0]       rdata;
  bit                         error;

  // -------------------------------------------------
  // Constraints
  // -------------------------------------------------

  // 1️⃣ Word alignment (APB 32-bit aligned)
  constraint addr_align_c {
    addr[1:0] == 2'b00;
  }

  // 2️⃣ Address must be inside memory range
  constraint addr_range_c {
    addr < (DEPTH * 4);
  }

  // 3️⃣ Strobe valid only for WRITE
  constraint strobe_c {
    if (!write)
      wstrb == 0;
    else
      wstrb inside {[1 : (2**(DATA_WIDTH/8))-1]}; 
      // at least one byte enabled
  }

  // 4️⃣ Optional: Bias more writes (if you want)
  // constraint write_bias_c {
  //   write dist {1 := 60, 0 := 40};
  // }

  // -------------------------------------------------
  // UVM macros
  // -------------------------------------------------
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
