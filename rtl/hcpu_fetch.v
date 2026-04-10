// ============================================================================
// HCPU Fetch Stage — hcpu_fetch.v
// Instruction fetch from code ROM, PC management
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================

`include "hcpu_pkg.vh"

module hcpu_fetch (
    input  wire                        clk,
    input  wire                        rst_n,

    // ── Pipeline control ────────────────────────────────────────
    input  wire                        stall,      // Hold PC + instruction
    input  wire                        flush,      // Insert NOP

    // ── Branch/Jump from Execute ────────────────────────────────
    input  wire                        branch_taken,
    input  wire [`XLEN-1:0]            branch_target,

    // ── Code memory interface ───────────────────────────────────
    output wire [`CODE_ADDR_W-1:0]     imem_addr,
    input  wire [`ILEN-1:0]            imem_data,

    // ── Output to Decode ────────────────────────────────────────
    output reg  [`ILEN-1:0]            if_instruction,
    output reg  [`XLEN-1:0]            if_pc         // PC of this instruction
);

    // ── PC register ─────────────────────────────────────────────
    reg [`XLEN-1:0] pc;

    // Drive instruction memory address from PC
    assign imem_addr = pc[`CODE_ADDR_W-1:0];

    // ── PC update + pipeline register ───────────────────────────
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc             <= {`XLEN{1'b0}};
            if_instruction <= {`OP_NOP, 24'h000000};  // NOP
            if_pc          <= {`XLEN{1'b0}};
        end else if (flush || branch_taken) begin
            // Flush: insert NOP into pipeline, redirect PC
            if_instruction <= {`OP_NOP, 24'h000000};
            if_pc          <= {`XLEN{1'b0}};
            if (branch_taken)
                pc <= branch_target;
            else
                pc <= pc;  // Flush without redirect — hold
        end else if (!stall) begin
            if_instruction <= imem_data;
            if_pc          <= pc;
            pc             <= pc + 1;
        end
        // If stall: hold pc, if_instruction, if_pc unchanged
    end

endmodule
