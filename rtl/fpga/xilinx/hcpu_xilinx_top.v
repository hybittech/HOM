// ============================================================================
// HCPU Xilinx FPGA Wrapper — hcpu_xilinx_top.v
// Target: Digilent Arty A7-35T (XC7A35T-1CPG236C)
// (c) 2026 HMCL
// ============================================================================
//
// Board resources:
//   - 100 MHz onboard oscillator → MMCM → 50 MHz system clock
//   - 4 RGB LEDs + 4 green LEDs
//   - 4 buttons, 4 switches
//   - UART via USB-FTDI
//

`include "hcpu_pkg.vh"

module hcpu_xilinx_top (
    input  wire        clk_100m,    // 100 MHz onboard oscillator
    input  wire        btn_rst,     // BTN0 — active high reset
    output wire        uart_txd,    // UART TX → USB-FTDI
    output wire [3:0]  led          // 4 green LEDs
);

    // ── MMCM: 100 MHz → 50 MHz ─────────────────────────────────
    wire clk_50m;
    wire mmcm_locked;
    wire clk_fb;

    MMCME2_BASE #(
        .CLKFBOUT_MULT_F  (10.0),    // VCO = 100 × 10 = 1000 MHz
        .CLKOUT0_DIVIDE_F (20.0),    // 1000 / 20 = 50 MHz
        .CLKIN1_PERIOD     (10.0)     // 100 MHz = 10 ns period
    ) u_mmcm (
        .CLKOUT0  (clk_50m),
        .CLKFBOUT (clk_fb),
        .LOCKED   (mmcm_locked),
        .CLKIN1   (clk_100m),
        .CLKFBIN  (clk_fb),
        .PWRDWN   (1'b0),
        .RST      (btn_rst)
    );

    // ── Reset synchronizer ──────────────────────────────────────
    reg [2:0] rst_sync;
    wire      sys_rst_n = rst_sync[2];

    always @(posedge clk_50m) begin
        rst_sync <= {rst_sync[1:0], mmcm_locked & ~btn_rst};
    end

    // ── Instruction memory (block RAM) ──────────────────────────
    (* ram_style = "block" *)
    reg [`ILEN-1:0] imem [0:1023];
    wire [`CODE_ADDR_W-1:0] imem_addr;
    reg  [`ILEN-1:0]        imem_data;

    initial begin
        $readmemh("program.hex", imem);
    end

    always @(posedge clk_50m) begin
        imem_data <= imem[imem_addr[9:0]];
    end

    // ── HCPU core ───────────────────────────────────────────────
    wire halted_out, guard_led_out;

    hcpu_top #(
        .CLK_HZ(50_000_000),
        .BAUD  (115200)
    ) u_hcpu (
        .clk       (clk_50m),
        .rst_n     (sys_rst_n),
        .imem_addr (imem_addr),
        .imem_data (imem_data),
        .uart_tx   (uart_txd),
        .halted    (halted_out),
        .guard_led (guard_led_out)
    );

    // ── LED mapping (active high) ───────────────────────────────
    assign led[0] = guard_led_out;   // GUARD flag
    assign led[1] = halted_out;      // Halted
    assign led[2] = mmcm_locked;     // MMCM locked
    assign led[3] = sys_rst_n;       // Reset deasserted

endmodule
