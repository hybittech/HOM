// ============================================================================
// HCPU Register File — hcpu_regfile.v
// 18 GPR (32-bit) + 16 H-Reg (144-bit) + FLAGS + PC + SP
// Dual read ports, single write port per bank
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================

`include "hcpu_pkg.vh"

module hcpu_regfile (
    input  wire                    clk,
    input  wire                    rst_n,

    // ── GPR read ports (dual) ───────────────────────────────────
    input  wire [4:0]              gpr_raddr1,
    input  wire [4:0]              gpr_raddr2,
    output wire [`XLEN-1:0]        gpr_rdata1,
    output wire [`XLEN-1:0]        gpr_rdata2,

    // ── GPR write port ──────────────────────────────────────────
    input  wire                    gpr_we,
    input  wire [4:0]              gpr_waddr,
    input  wire [`XLEN-1:0]        gpr_wdata,

    // ── H-Reg read ports (dual) ─────────────────────────────────
    input  wire [3:0]              hreg_raddr1,
    input  wire [3:0]              hreg_raddr2,
    output wire [`HREG_W-1:0]      hreg_rdata1,
    output wire [`HREG_W-1:0]      hreg_rdata2,

    // ── H-Reg write port ────────────────────────────────────────
    input  wire                    hreg_we,
    input  wire [3:0]              hreg_waddr,
    input  wire [`HREG_W-1:0]      hreg_wdata,

    // ── FLAGS ───────────────────────────────────────────────────
    input  wire                    flags_we,
    input  wire [7:0]              flags_in,
    output wire [7:0]              flags_out,

    // ── PC ──────────────────────────────────────────────────────
    input  wire                    pc_we,
    input  wire [`XLEN-1:0]        pc_in,
    output wire [`XLEN-1:0]        pc_out
);

    // ── GPR storage ─────────────────────────────────────────────
    reg [`XLEN-1:0] gpr [0:`GPR_COUNT-1];

    // ── H-Reg storage (packed 144-bit per register) ─────────────
    reg [`HREG_W-1:0] hreg [0:`HREG_COUNT-1];

    // ── Special registers ───────────────────────────────────────
    reg [7:0]        flags;
    reg [`XLEN-1:0]  pc;

    // ── GPR read ────────────────────────────────────────────────
    assign gpr_rdata1 = gpr[gpr_raddr1];
    assign gpr_rdata2 = gpr[gpr_raddr2];

    // ── H-Reg read ──────────────────────────────────────────────
    assign hreg_rdata1 = hreg[hreg_raddr1];
    assign hreg_rdata2 = hreg[hreg_raddr2];

    // ── FLAGS / PC read ─────────────────────────────────────────
    assign flags_out = flags;
    assign pc_out    = pc;

    // ── Write logic (synchronous) ───────────────────────────────
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < `GPR_COUNT; i = i + 1)
                gpr[i] <= {`XLEN{1'b0}};
            for (i = 0; i < `HREG_COUNT; i = i + 1)
                hreg[i] <= {`HREG_W{1'b0}};
            flags <= 8'h00;
            pc    <= {`XLEN{1'b0}};
        end else begin
            if (gpr_we)
                gpr[gpr_waddr] <= gpr_wdata;
            if (hreg_we)
                hreg[hreg_waddr] <= hreg_wdata;
            if (flags_we)
                flags <= flags_in;
            if (pc_we)
                pc <= pc_in;
        end
    end

endmodule
