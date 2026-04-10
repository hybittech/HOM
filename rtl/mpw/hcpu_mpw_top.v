// ============================================================================
// HCPU MPW Top-Level Wrapper — hcpu_mpw_top.v
// Caravel-compatible interface for Efabless Open MPW (SKY130)
// (c) 2026 HMCL
// ============================================================================
//
// This module wraps hcpu_top with a simple parallel interface
// suitable for integration into the Caravel user_project_wrapper.
//
// Instruction loading: write instruction words via io_in bus
// Status readback: halted, guard status via io_out
//

`include "hcpu_pkg.vh"

module hcpu_mpw_top (
`ifdef USE_POWER_PINS
    inout vccd1,    // User area 1 1.8V supply
    inout vssd1,    // User area 1 digital ground
`endif

    // Wishbone interface (directly from Caravel management SoC)
    input  wire        wb_clk_i,
    input  wire        wb_rst_i,

    // Logic Analyzer (directly from Caravel)
    input  wire [31:0] la_data_in,
    input  wire [31:0] la_oen,

    // I/O pads
    input  wire [15:0] io_in,
    output wire [15:0] io_out,
    output wire [15:0] io_oeb    // Output enable (active low)
);

    // ── Reset ───────────────────────────────────────────────────
    wire sys_rst_n = ~wb_rst_i;
    wire sys_clk   = wb_clk_i;

    // ── Instruction memory (writable via io_in) ─────────────────
    reg [`ILEN-1:0] imem [0:255];  // 256 instructions for MPW
    wire [`CODE_ADDR_W-1:0] imem_addr;
    wire [`ILEN-1:0]        imem_data;
    assign imem_data = imem[imem_addr[7:0]];

    // ── Program loading FSM ─────────────────────────────────────
    // io_in[15]    = write enable
    // io_in[14:8]  = instruction address (7 bits)
    // io_in[7:0]   = data byte
    //
    // Write 4 bytes per instruction (big-endian):
    //   Byte 0 → imem[addr][31:24]
    //   Byte 1 → imem[addr][23:16]
    //   Byte 2 → imem[addr][15:8]
    //   Byte 3 → imem[addr][7:0]

    reg [1:0] byte_cnt;
    reg [7:0] prog_addr;
    reg [`ILEN-1:0] prog_word;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            byte_cnt  <= 2'd0;
        end else if (io_in[15]) begin  // Write enable
            case (byte_cnt)
                2'd0: begin
                    prog_addr <= io_in[14:8];
                    prog_word[31:24] <= io_in[7:0];
                    byte_cnt <= 2'd1;
                end
                2'd1: begin
                    prog_word[23:16] <= io_in[7:0];
                    byte_cnt <= 2'd2;
                end
                2'd2: begin
                    prog_word[15:8] <= io_in[7:0];
                    byte_cnt <= 2'd3;
                end
                2'd3: begin
                    prog_word[7:0] <= io_in[7:0];
                    imem[prog_addr] <= {prog_word[31:8], io_in[7:0]};
                    byte_cnt <= 2'd0;
                end
            endcase
        end
    end

    // ── HCPU core ───────────────────────────────────────────────
    wire halted_out, guard_led, uart_tx_out;

    hcpu_top #(
        .CLK_HZ(40_000_000),  // Caravel typical clock
        .BAUD  (115200)
    ) u_hcpu (
        .clk       (sys_clk),
        .rst_n     (sys_rst_n),
        .imem_addr (imem_addr),
        .imem_data (imem_data),
        .uart_tx   (uart_tx_out),
        .halted    (halted_out),
        .guard_led (guard_led)
    );

    // ── Output mapping ──────────────────────────────────────────
    assign io_out[0]  = uart_tx_out;
    assign io_out[1]  = halted_out;
    assign io_out[2]  = guard_led;
    assign io_out[15:3] = 13'd0;

    // ── Output enable (active low: 0 = output) ──────────────────
    assign io_oeb[0]  = 1'b0;  // UART TX
    assign io_oeb[1]  = 1'b0;  // Halted
    assign io_oeb[2]  = 1'b0;  // Guard LED
    assign io_oeb[15:3] = {13{1'b1}};  // Input mode

endmodule
