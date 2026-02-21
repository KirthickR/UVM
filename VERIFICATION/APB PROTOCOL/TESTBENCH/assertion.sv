module apb_assertions #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32
)(
  input logic                     PCLK,
  input logic                     PRESETn,
  input logic                     PSEL,
  input logic                     PENABLE,
  input logic                     PREADY,
  input logic                     PWRITE,
  input logic [ADDR_WIDTH-1:0]    PADDR,
  input logic [DATA_WIDTH-1:0]    PWDATA
);

  // 1. PENABLE only when PSEL is high
  property p_enable_with_psel;
    @(posedge PCLK)
    disable iff (!PRESETn)
    PENABLE |-> PSEL;
  endproperty

  assert property (p_enable_with_psel)
    else $warning("APB WARNING: PENABLE high without PSEL");


  // 2. SETUP must be followed by ACCESS
  property p_setup_to_access;
    @(posedge PCLK)
    disable iff (!PRESETn)
    (PSEL && !PENABLE) |=> PENABLE;
  endproperty

  assert property (p_setup_to_access)
    else $warning("APB WARNING: SETUP not followed by ACCESS");


  // 3. Signals stable during wait state
  property p_stable_during_wait;
    @(posedge PCLK)
    disable iff (!PRESETn)
    (PSEL && PENABLE && !PREADY)
    |-> $stable(PADDR) && $stable(PWRITE) && $stable(PWDATA);
  endproperty

  assert property (p_stable_during_wait)
    else $warning("APB WARNING: Signals changed during wait state");


  // 4. PENABLE must drop after transfer complete
  property p_transfer_complete;
    @(posedge PCLK)
    disable iff (!PRESETn)
    (PSEL && PENABLE && PREADY)
    |=> !PENABLE;
  endproperty

  assert property (p_transfer_complete)
    else $warning("APB WARNING: PENABLE not deasserted after transfer");


  // 5. No X during active transfer
  property p_no_unknown;
    @(posedge PCLK)
    disable iff (!PRESETn)
    PSEL |-> !$isunknown({PADDR, PWRITE});
  endproperty

  assert property (p_no_unknown)
    else $warning("APB WARNING: Unknown value detected on bus");

endmodule


    // Important Note: By giving $warning then only the waveform is generated and we can analyze the waveform, by giving $error waveform is not generated.
