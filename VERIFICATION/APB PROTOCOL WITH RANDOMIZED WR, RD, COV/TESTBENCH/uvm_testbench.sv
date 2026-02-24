`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "assertion.sv"

// UVM files
`include "sequence_item.sv"
`include "sequence.sv"
`include "wr_sequence.sv"
`include "rd_sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "coverage.sv"
`include "environment.sv"
`include "test.sv"

module tb_top;

  parameter int ADDR_WIDTH = 32;
  parameter int DATA_WIDTH = 32;

  logic PCLK;
  logic PRESETn;

  // Clock generation
  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end

  // Reset generation
  initial begin
    PRESETn = 0;
    repeat (3) @(posedge PCLK);
    PRESETn = 1;
  end

  // Interface
  apb_if #(ADDR_WIDTH, DATA_WIDTH) apb_vif(PCLK, PRESETn);

  // DUT
  apb_top #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) DUT (
    .PCLK     (PCLK),
    .PRESETn  (PRESETn),

    .start    (apb_vif.start),
    .write_en (apb_vif.write_en),
    .addr     (apb_vif.addr),
    .wdata    (apb_vif.wdata),
    .wstrb    (apb_vif.wstrb),

    .rdata    (apb_vif.rdata),
    .done     (apb_vif.done),
    .error    (apb_vif.error)
  );

  // UVM Configuration
  initial begin
    uvm_config_db#(virtual apb_if #(ADDR_WIDTH, DATA_WIDTH))::set(
      null, "*", "vif", apb_vif
    );
    run_test("apb_test");
  end

  // Timeout
  initial begin
    #2000;
    $display("Simulation Timeout Reached");
    $finish;
  end

  // Wave dump
  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0, tb_top);
  end

endmodule


// =========================================================
// Correct Assertion Bind
// =========================================================

bind apb_top apb_assertions #(
  .ADDR_WIDTH(32),
  .DATA_WIDTH(32)
) u_apb_assertions (
  .PCLK     (PCLK),
  .PRESETn  (PRESETn),
  .PSEL     (PSEL),
  .PENABLE  (PENABLE),
  .PREADY   (PREADY),
  .PWRITE   (PWRITE),
  .PADDR    (PADDR),
  .PWDATA   (PWDATA)
);
