// ============================================================================
// HCPU Memory Stage — hcpu_memory.v
// Stack operations (PUSH/POP) for Fase 1
// Data RAM load/store reserved for future expansion
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================

`include "hcpu_pkg.vh"

module hcpu_memory (
    input  wire                    clk,
    input  wire                    rst_n,

    // ── Pipeline control ────────────────────────────────────────
    input  wire                    stall,

    // ── Input from Execute ──────────────────────────────────────
    input  wire [7:0]              ex_opcode,
    input  wire [3:0]              ex_dst,
    input  wire [`XLEN-1:0]        ex_gpr_result,
    input  wire [`HREG_W-1:0]      ex_hreg_result,
    input  wire                    ex_gpr_we,
    input  wire                    ex_hreg_we,
    input  wire [7:0]              ex_flags_new,
    input  wire                    ex_flags_we,
    input  wire                    ex_is_halt,
    input  wire                    ex_is_push,
    input  wire                    ex_is_pop,
    input  wire [`XLEN-1:0]        ex_push_data,

    // ── Output to Writeback ─────────────────────────────────────
    output reg  [3:0]              mem_dst,
    output reg  [`XLEN-1:0]        mem_gpr_result,
    output reg  [`HREG_W-1:0]      mem_hreg_result,
    output reg                     mem_gpr_we,
    output reg                     mem_hreg_we,
    output reg  [7:0]              mem_flags_new,
    output reg                     mem_flags_we,
    output reg                     mem_is_halt
);

    // ── Stack storage ───────────────────────────────────────────
    reg [`XLEN-1:0] stack [0:`STACK_DEPTH-1];
    reg [7:0]       sp;  // Stack pointer (0 = empty)

    // ── Stack operation result ──────────────────────────────────
    reg [`XLEN-1:0] pop_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sp <= 8'd0;
        end else if (!stall) begin
            if (ex_is_push && sp < `STACK_DEPTH) begin
                stack[sp] <= ex_push_data;
                sp        <= sp + 1;
            end
            if (ex_is_pop && sp > 0) begin
                sp <= sp - 1;
            end
        end
    end

    // Pop data: read from stack[sp-1] (combinational for same-cycle)
    wire [`XLEN-1:0] stack_top = (sp > 0) ? stack[sp - 1] : {`XLEN{1'b0}};

    // ── Pipeline register to Writeback ──────────────────────────
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_dst         <= 4'd0;
            mem_gpr_result  <= {`XLEN{1'b0}};
            mem_hreg_result <= {`HREG_W{1'b0}};
            mem_gpr_we      <= 1'b0;
            mem_hreg_we     <= 1'b0;
            mem_flags_new   <= 8'h00;
            mem_flags_we    <= 1'b0;
            mem_is_halt     <= 1'b0;
        end else if (!stall) begin
            mem_dst         <= ex_dst;
            mem_hreg_result <= ex_hreg_result;
            mem_gpr_we      <= ex_gpr_we;
            mem_hreg_we     <= ex_hreg_we;
            mem_flags_new   <= ex_flags_new;
            mem_flags_we    <= ex_flags_we;
            mem_is_halt     <= ex_is_halt;

            // GPR result: override with stack data for POP
            if (ex_is_pop)
                mem_gpr_result <= stack_top;
            else
                mem_gpr_result <= ex_gpr_result;
        end
    end

endmodule
