`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_coverage #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) extends uvm_subscriber #(apb_seq_item #(ADDR_WIDTH,DATA_WIDTH));

  `uvm_component_param_utils(apb_coverage #(ADDR_WIDTH,DATA_WIDTH))

  bit write_tr;
  bit [ADDR_WIDTH-1:0] addr;
  bit [DATA_WIDTH/8-1:0] wstrb;

  covergroup apb_cg;

    option.per_instance = 1;   // ⭐ REQUIRED

    cp_write : coverpoint write_tr {
      bins wr = {1};
      bins rd = {0};
    }

    cp_addr : coverpoint addr {
      bins low  = {[0:15]};
      bins mid  = {[16:63]};
      bins high = {[64:255]};
    }

    cp_strobe : coverpoint wstrb;

    cross cp_write, cp_addr;

  endgroup


  function new(string name, uvm_component parent);
    super.new(name,parent);
    apb_cg = new();
  endfunction


  function void write(apb_seq_item #(ADDR_WIDTH,DATA_WIDTH) t);

    if (t == null)
      return;

    write_tr = t.write;
    addr     = t.addr;
    wstrb    = t.wstrb;

    apb_cg.sample();

  endfunction


  function void report_phase(uvm_phase phase);

    `uvm_info("COVERAGE",
      $sformatf("APB Functional Coverage = %0.2f%%",
      apb_cg.get_coverage()),
      UVM_NONE)

  endfunction

endclass
