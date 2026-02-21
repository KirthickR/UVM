interface apb_if #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32
)(
  input logic PCLK,
  input logic PRESETn
);

  // -------------------------------
  // USER CONTROL SIGNALS
  // -------------------------------
  logic                   start;
  logic                   write_en;
  logic [ADDR_WIDTH-1:0]  addr;
  logic [DATA_WIDTH-1:0]  wdata;
  logic [DATA_WIDTH/8-1:0] wstrb;

  logic [DATA_WIDTH-1:0]  rdata;
  logic                   done;
  logic                   error;

  // -------------------------------
  // APB SIGNALS
  // -------------------------------
  logic [ADDR_WIDTH-1:0]   PADDR;
  logic                    PSEL;
  logic                    PENABLE;
  logic                    PWRITE;
  logic [DATA_WIDTH-1:0]   PWDATA;
  logic [DATA_WIDTH/8-1:0] PSTRB;
  logic [2:0]              PPROT;
  logic [DATA_WIDTH-1:0]   PRDATA;
  logic                    PREADY;
  logic                    PSLVERR;

  // ✅ CLOCKING BLOCK (THIS FIXES EVERYTHING)
  clocking mon_cb @(posedge PCLK);
    input PADDR;
    input PSEL;
    input PENABLE;
    input PWRITE;
    input PWDATA;
    input PSTRB;
    input PRDATA;
    input PREADY;
    input PSLVERR;
  endclocking

endinterface
