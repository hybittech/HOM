// ============================================================================
// HCPU Gowin FPGA Wrapper — hcpu_gowin_top.v
// Target: Tang Nano 9K (GW1NR-LV9QN88PC6/I5)
// (c) 2026 HMCL
// ============================================================================
//
// Board resources:
//   - 27 MHz onboard oscillator → PLL → 50 MHz system clock
//   - 6 LEDs (active low)
//   - 2 buttons (active low)
//   - UART via USB-C
//

`include "hcpu_pkg.vh"

module hcpu_gowin_top (
    input  wire        clk_27m,     // 27 MHz onboard oscillator
    input  wire        btn_rst_n,   // Button S2 — active low reset
    output wire        uart_txd,    // UART TX → USB bridge
    output wire [5:0]  led          // 6 LEDs — active low
);

    // ── PLL: 27 MHz → 50 MHz ────────────────────────────────────
    // For Gowin: use rPLL primitive
    // Multiply by 50, divide by 27 → 50 MHz
    wire clk_50m;
    wire pll_locked;

    Gowin_rPLL u_pll (
        .clkout (clk_50m),
        .lock   (pll_locked),
        .clkin  (clk_27m)
    );

    // ── Reset synchronizer ──────────────────────────────────────
    reg [2:0] rst_sync;
    wire      sys_rst_n = rst_sync[2];

    always @(posedge clk_50m or negedge btn_rst_n) begin
        if (!btn_rst_n)
            rst_sync <= 3'b000;
        else
            rst_sync <= {rst_sync[1:0], pll_locked};
    end

    // ── Instruction memory (block RAM) ──────────────────────────
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

    // ── LED mapping (active low) ────────────────────────────────
    // LED[0]: GUARD flag (ON = pass)
    // LED[1]: Halted (ON = stopped)
    // LED[2]: PLL locked
    // LED[3]: Reset active
    // LED[4:5]: Reserved (off)
    assign led[0] = ~guard_led_out;
    assign led[1] = ~halted_out;
    assign led[2] = ~pll_locked;
    assign led[3] = ~sys_rst_n;
    assign led[4] = 1'b1;  // Off
    assign led[5] = 1'b1;  // Off

endmodule

// ── Gowin rPLL stub (replace with Gowin IP instantiation) ───────
// This is a placeholder. In actual Gowin IDE, use the IP Generator
// to create the PLL configuration file.
module Gowin_rPLL (
    output wire clkout,
    output wire lock,
    input  wire clkin
);
    // Placeholder for simulation
    assign clkout = clkin;
    assign lock   = 1'b1;
endmodule
