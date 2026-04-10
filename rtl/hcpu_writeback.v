// ============================================================================
// HCPU Writeback Stage — hcpu_writeback.v
// Final stage: drives register file write ports and FLAGS update
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================

`include "hcpu_pkg.vh"

module hcpu_writeback (
    // ── Input from Memory stage ─────────────────────────────────
    input  wire [3:0]              mem_dst,
    input  wire [`XLEN-1:0]        mem_gpr_result,
    input  wire [`HREG_W-1:0]      mem_hreg_result,
    input  wire                    mem_gpr_we,
    input  wire                    mem_hreg_we,
    input  wire [7:0]              mem_flags_new,
    input  wire                    mem_flags_we,
    input  wire                    mem_is_halt,

    // ── Write to register file ──────────────────────────────────
    output wire                    wb_gpr_we,
    output wire [4:0]              wb_gpr_waddr,
    output wire [`XLEN-1:0]        wb_gpr_wdata,
    output wire                    wb_hreg_we,
    output wire [3:0]              wb_hreg_waddr,
    output wire [`HREG_W-1:0]      wb_hreg_wdata,
    output wire                    wb_flags_we,
    output wire [7:0]              wb_flags,
    output wire                    wb_halt
);

    // ── Simple forwarding — combinational from MEM register ─────
    assign wb_gpr_we    = mem_gpr_we;
    assign wb_gpr_waddr = {1'b0, mem_dst};
    assign wb_gpr_wdata = mem_gpr_result;

    assign wb_hreg_we    = mem_hreg_we;
    assign wb_hreg_waddr = mem_dst;
    assign wb_hreg_wdata = mem_hreg_result;

    assign wb_flags_we = mem_flags_we;
    assign wb_flags    = mem_flags_new;

    assign wb_halt = mem_is_halt;

endmodule
