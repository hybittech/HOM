// ============================================================================
// HCPU Pipeline Controller — hcpu_controller.v
// Global stall/flush management, UART blocking, halt detection
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================
//
// Stall policy (Fase 1):
//   - PRINT instruction → stall entire pipeline until UART tx_busy deasserts
//   - Future multi-cycle codex ops → stall until done
//
// Flush policy:
//   - Taken branch/jump → flush IF and ID stages (1-cycle penalty)
//
// Halt:
//   - HALT instruction reaches writeback → assert halted, freeze everything
//

`include "hcpu_pkg.vh"

module hcpu_controller (
    input  wire        clk,
    input  wire        rst_n,

    // ── Instruction info from decode/execute ────────────────────
    input  wire        ex_is_print,
    input  wire        branch_taken,
    input  wire        wb_halt,

    // ── UART status ─────────────────────────────────────────────
    input  wire        uart_busy,

    // ── Pipeline control outputs ────────────────────────────────
    output wire        pipe_stall,     // Freeze all stages
    output wire        pipe_flush,     // Flush IF + ID
    output reg         halted          // Processor halted
);

    // ── PRINT blocking stall ────────────────────────────────────
    // When a PRINT is in the execute stage AND uart is busy,
    // stall the entire pipeline.
    reg print_pending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            print_pending <= 1'b0;
        end else begin
            if (ex_is_print && !print_pending)
                print_pending <= 1'b1;
            else if (print_pending && !uart_busy)
                print_pending <= 1'b0;
        end
    end

    // ── Halt latch ──────────────────────────────────────────────
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            halted <= 1'b0;
        else if (wb_halt)
            halted <= 1'b1;
    end

    // ── Stall: UART blocking OR halted ──────────────────────────
    assign pipe_stall = (print_pending && uart_busy) || halted;

    // ── Flush: taken branch (1-cycle penalty) ───────────────────
    assign pipe_flush = branch_taken && !pipe_stall;

endmodule
