module apb_slave #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32,
  parameter DEPTH      = 16,
  parameter WAIT_CYCLES = 0        // <-- configurable wait states
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

  // -----------------------------
  // Memory
  // -----------------------------
  logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  wire [$clog2(DEPTH)-1:0] addr_index;
  assign addr_index = PADDR[$clog2(DEPTH)+1 : 2];

  // -----------------------------
  // Wait-state counter
  // -----------------------------
  logic [$clog2(WAIT_CYCLES+1)-1:0] wait_cnt;

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PRDATA   <= '0;
      PREADY   <= 1'b0;
      PSLVERR  <= 1'b0;
      wait_cnt <= '0;
    end
    else begin

      PSLVERR <= 1'b0;

      //-------------------------------------------------
      // ACCESS phase handling
      //-------------------------------------------------
      if (PSEL && PENABLE) begin

        // Wait-state logic
        if (wait_cnt < WAIT_CYCLES) begin
          wait_cnt <= wait_cnt + 1;
          PREADY   <= 1'b0;
        end
        else begin
          PREADY   <= 1'b1;
          wait_cnt <= '0;

          // Perform actual transfer when ready
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
      else begin
        // Not in ACCESS
        PREADY   <= 1'b0;
        wait_cnt <= '0;
      end

    end
  end

endmodule
