`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "assertion.sv"   // ✅ Include assertion file

// Include your UVM files
`include "sequence_item.sv"
`include "sequence.sv"
`include "wr_sequence.sv"
`include "rd_sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"

module tb_top;

  parameter int ADDR_WIDTH = 32;
  parameter int DATA_WIDTH = 32;

  // Clock & Reset signals
  logic PCLK;
  logic PRESETn;

  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end

  initial begin
  PRESETn = 1;        // Start high
  #1;
  PRESETn = 0;        // Generate negedge
  repeat (3) @(posedge PCLK);
  PRESETn = 1;        // Release
end

  // Instantiate Interface - Pass PCLK and PRESETn directly to ports
  apb_if #(ADDR_WIDTH, DATA_WIDTH) apb_vif(PCLK, PRESETn);

  // ---------------------------------------------------------
  // FIXED DUT INSTANTIATION
  // ---------------------------------------------------------
  apb_top #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) DUT (
    .PCLK     (PCLK),
    .PRESETn  (PRESETn),

    // Control/Input signals from Interface
   .start    (apb_vif.start),
  .write_en (apb_vif.write_en),
  .addr     (apb_vif.addr),      // ✅ FIXED
  .wdata    (apb_vif.wdata),     // ✅ FIXED
  .wstrb    (apb_vif.wstrb),     // ✅ FIXED

  // Status/Output signals back to Interface
  .rdata    (apb_vif.rdata),     // ✅ FIXED
    .done     (apb_vif.done),     // DUT 'done' maps to IF 'done'
    .error    (apb_vif.error)     // DUT 'error' maps to IF 'error'
  );

  // ----------------------------------
  // UVM Configuration
  // ----------------------------------
  initial begin
    uvm_config_db#(virtual apb_if #(ADDR_WIDTH, DATA_WIDTH))::set(
      null, "*", "vif", apb_vif
    );
    run_test("apb_test");
  end
  
  initial begin
    #2000;
    $display("Simulation Timeout Reached");
    $finish;
  end
initial begin
  $dumpfile("waves.vcd");
  $dumpvars;
end
endmodule

// =========================================================
// Bind Assertions to DUT
// =========================================================
bind apb_top apb_assertions #(
  .ADDR_WIDTH(32),
  .DATA_WIDTH(32)
) u_apb_assertions (
  .PCLK(PCLK),
  .PRESETn(PRESETn),
  .PSEL(DUT.PSEL),
  .PENABLE(DUT.PENABLE),
  .PREADY(DUT.PREADY),
  .PWRITE(DUT.PWRITE),
  .PADDR(DUT.PADDR),
  .PWDATA(DUT.PWDATA)
);
