`include "apb_master.v"
`include  "apb_slave.v"
module apb_top #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32
)(
  input  logic                     PCLK,
  input  logic                     PRESETn,

  // -------- Control (from UVM / TB) --------
  input  logic                     start,
  input  logic                     write_en,
  input  logic [ADDR_WIDTH-1:0]    addr,
  input  logic [DATA_WIDTH-1:0]    wdata,
  input  logic [DATA_WIDTH/8-1:0]  wstrb,

  // -------- Status (to TB / scoreboard) --------
  output logic [DATA_WIDTH-1:0]    rdata,
  output logic                     done,
  output logic                     error
);

  // -------- APB wires --------
  logic [ADDR_WIDTH-1:0]    PADDR;
  logic                     PSEL;
  logic                     PENABLE;
  logic                     PWRITE;
  logic [DATA_WIDTH-1:0]    PWDATA;
  logic [DATA_WIDTH/8-1:0]  PSTRB;
  logic [2:0]               PPROT;
  logic [DATA_WIDTH-1:0]    PRDATA;
  logic                     PREADY;
  logic                     PSLVERR;

 apb_master  u_apb_master (.*);
  apb_slave  u_apb_slave (.*);

endmodule
