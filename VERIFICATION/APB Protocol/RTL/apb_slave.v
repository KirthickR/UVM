module apb_slave #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32,
  parameter DEPTH      = 16
)(
  input  logic                     PCLK,
  input  logic                     PRESETn,

  input  logic [ADDR_WIDTH-1:0]    PADDR,
  input  logic                     PSEL,
  input  logic                     PENABLE,
  input  logic                     PWRITE,
  input  logic [DATA_WIDTH-1:0]    PWDATA,
  input  logic [DATA_WIDTH/8-1:0]  PSTRB,

  output logic [DATA_WIDTH-1:0]    PRDATA,
  output logic                     PREADY,
  output logic                     PSLVERR
);

  logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  wire [$clog2(DEPTH)-1:0] addr_index;
  assign addr_index = PADDR[$clog2(DEPTH)+1 : 2];

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PRDATA  <= '0;
      PREADY  <= 1'b0;
      PSLVERR <= 1'b0;
    end
    else begin

      // ------------------------------------------------
      // Default assignments (VERY IMPORTANT)
      // ------------------------------------------------
      PREADY  <= 1'b0;    // Default LOW every cycle
      PSLVERR <= 1'b0;

      // ------------------------------------------------
      // ACCESS Phase
      // ------------------------------------------------
      if (PSEL && PENABLE) begin
        PREADY <= 1'b1;   // Only HIGH in ACCESS

        if (addr_index >= DEPTH) begin
          PSLVERR <= 1'b1;
        end
        else if (PWRITE) begin
          if (PSTRB[0]) mem[addr_index][7:0]   <= PWDATA[7:0];
          if (PSTRB[1]) mem[addr_index][15:8]  <= PWDATA[15:8];
          if (PSTRB[2]) mem[addr_index][23:16] <= PWDATA[23:16];
          if (PSTRB[3]) mem[addr_index][31:24] <= PWDATA[31:24];
        end
        else begin
          PRDATA <= mem[addr_index];
        end
      end
    end
  end

endmodule
