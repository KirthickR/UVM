module apb_master #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32
)(
  input  logic                     PCLK,
  input  logic                     PRESETn,

  // -------- Control inputs --------
  input  logic                     start,
  input  logic                     write_en,
  input  logic [ADDR_WIDTH-1:0]    addr,
  input  logic [DATA_WIDTH-1:0]    wdata,
  input  logic [DATA_WIDTH/8-1:0]  wstrb,

  // -------- Status outputs --------
  output logic [DATA_WIDTH-1:0]    rdata,
  output logic                     done,
  output logic                     error,

  // -------- APB bus --------
  output logic [ADDR_WIDTH-1:0]    PADDR,
  output logic                     PSEL,
  output logic                     PENABLE,
  output logic                     PWRITE,
  output logic [DATA_WIDTH-1:0]    PWDATA,
  output logic [DATA_WIDTH/8-1:0]  PSTRB,
  output logic [2:0]               PPROT,

  input  logic [DATA_WIDTH-1:0]    PRDATA,
  input  logic                     PREADY,
  input  logic                     PSLVERR
);

  typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
  state_t state, next_state;

  // -----------------------------------------
  // Internal transaction holding registers
  // -----------------------------------------
  logic [ADDR_WIDTH-1:0]    addr_reg;
  logic                     write_reg;
  logic [DATA_WIDTH-1:0]    wdata_reg;
  logic [DATA_WIDTH/8-1:0]  wstrb_reg;

  // -----------------------------------------
  // Start edge detection
  // -----------------------------------------
  logic start_d;
  wire  start_pulse;

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
      start_d <= 0;
    else
      start_d <= start;
  end

  assign start_pulse = start & ~start_d;

  // -----------------------------------------
  // State register
  // -----------------------------------------
  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
      state <= IDLE;
    else
      state <= next_state;
  end

  // -----------------------------------------
  // Next-state logic
  // -----------------------------------------
  always_comb begin
    next_state = state;

    case (state)
      IDLE   : if (start_pulse) next_state = SETUP;
      SETUP  :                  next_state = ACCESS;
      ACCESS : if (PREADY)      next_state = IDLE;
    endcase
  end

  // -----------------------------------------
  // Output & datapath logic
  // -----------------------------------------
  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PSEL      <= 0;
      PENABLE   <= 0;
      PWRITE    <= 0;
      PADDR     <= 0;
      PWDATA    <= 0;
      PSTRB     <= 0;
      PPROT     <= 3'b000;
      rdata     <= 0;
      done      <= 0;
      error     <= 0;

      addr_reg  <= 0;
      write_reg <= 0;
      wdata_reg <= 0;
      wstrb_reg <= 0;

    end else begin

      done  <= 0;
      error <= 0;

      // Drive APB control signals from NEXT STATE
      PSEL    <= (next_state != IDLE);
      PENABLE <= (next_state == ACCESS);

      case (state)

        // ---------------------------------
        // Capture transaction in SETUP
        // ---------------------------------
        SETUP: begin
          addr_reg  <= addr;
          write_reg <= write_en;
          wdata_reg <= wdata;
          wstrb_reg <= wstrb;
        end

        // ---------------------------------
        // ACCESS phase
        // ---------------------------------
        ACCESS: begin
          if (PREADY) begin
            done  <= 1;
            error <= PSLVERR;

            if (!write_reg)
              rdata <= PRDATA;
          end
        end

      endcase

      // ---------------------------------
      // Drive bus from REGISTERED values
      // ---------------------------------
      PADDR  <= addr_reg;
      PWRITE <= write_reg;
      PWDATA <= wdata_reg;
      PSTRB  <= write_reg ? wstrb_reg : 0;
      PPROT  <= 3'b000;

    end
  end

endmodule
