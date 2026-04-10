// ============================================================================
// HCPU Decode Stage — hcpu_decode.v
// Instruction field extraction, register read, control signal generation
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================

`include "hcpu_pkg.vh"

module hcpu_decode (
    input  wire                    clk,
    input  wire                    rst_n,

    // ── Pipeline control ────────────────────────────────────────
    input  wire                    stall,
    input  wire                    flush,

    // ── Input from Fetch ────────────────────────────────────────
    input  wire [`ILEN-1:0]        if_instruction,
    input  wire [`XLEN-1:0]        if_pc,

    // ── Register file read (combinational) ──────────────────────
    output wire [4:0]              gpr_raddr1,     // → regfile
    output wire [4:0]              gpr_raddr2,
    input  wire [`XLEN-1:0]        gpr_rdata1,     // ← regfile
    input  wire [`XLEN-1:0]        gpr_rdata2,
    output wire [3:0]              hreg_raddr1,    // → regfile
    output wire [3:0]              hreg_raddr2,
    input  wire [`HREG_W-1:0]      hreg_rdata1,    // ← regfile
    input  wire [`HREG_W-1:0]      hreg_rdata2,

    // ── Output to Execute (pipeline register) ───────────────────
    output reg  [7:0]              id_opcode,
    output reg  [3:0]              id_dst,
    output reg  [3:0]              id_s1,
    output reg  [3:0]              id_s2,
    output reg  [11:0]             id_imm,
    output reg  [`XLEN-1:0]        id_gpr_s1,     // GPR[S1] value
    output reg  [`XLEN-1:0]        id_gpr_s2,     // GPR[S2] value
    output reg  [`HREG_W-1:0]      id_hreg_s1,    // H-Reg[S1] value
    output reg  [`HREG_W-1:0]      id_hreg_s2,    // H-Reg[S2] value
    output reg  [`XLEN-1:0]        id_pc,         // PC of this instruction

    // ── Decoded control signals ─────────────────────────────────
    output reg                     id_gpr_we,     // Write to GPR
    output reg                     id_hreg_we,    // Write to H-Reg
    output reg                     id_mem_read,   // Load from data RAM
    output reg                     id_mem_write,  // Store to data RAM
    output reg                     id_is_branch,  // Branch instruction
    output reg                     id_is_jump,    // Unconditional jump
    output reg                     id_is_codex,   // Codex H-Reg operation
    output reg                     id_is_halt,    // HALT instruction
    output reg                     id_is_print,   // PRINT instruction
    output reg                     id_is_push,    // Stack push
    output reg                     id_is_pop      // Stack pop
);

    // ── Instruction field extraction (combinational) ────────────
    wire [7:0]  opcode = if_instruction[`OP_MSB:`OP_LSB];
    wire [3:0]  dst    = if_instruction[`DST_MSB:`DST_LSB];
    wire [3:0]  s1     = if_instruction[`S1_MSB:`S1_LSB];
    wire [3:0]  s2     = if_instruction[`S2_MSB:`S2_LSB];
    wire [11:0] imm    = if_instruction[`IMM_MSB:`IMM_LSB];

    // Drive register file addresses (combinational, before clock)
    assign gpr_raddr1  = {1'b0, s1};
    assign gpr_raddr2  = {1'b0, s2};
    assign hreg_raddr1 = s1;
    assign hreg_raddr2 = s2;

    // ── Pipeline register + control decode ──────────────────────
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            id_opcode    <= `OP_NOP;
            id_dst       <= 4'd0;
            id_s1        <= 4'd0;
            id_s2        <= 4'd0;
            id_imm       <= 12'd0;
            id_gpr_s1    <= {`XLEN{1'b0}};
            id_gpr_s2    <= {`XLEN{1'b0}};
            id_hreg_s1   <= {`HREG_W{1'b0}};
            id_hreg_s2   <= {`HREG_W{1'b0}};
            id_pc        <= {`XLEN{1'b0}};
            id_gpr_we    <= 1'b0;
            id_hreg_we   <= 1'b0;
            id_mem_read  <= 1'b0;
            id_mem_write <= 1'b0;
            id_is_branch <= 1'b0;
            id_is_jump   <= 1'b0;
            id_is_codex  <= 1'b0;
            id_is_halt   <= 1'b0;
            id_is_print  <= 1'b0;
            id_is_push   <= 1'b0;
            id_is_pop    <= 1'b0;
        end else if (!stall) begin
            // Latch fields
            id_opcode  <= opcode;
            id_dst     <= dst;
            id_s1      <= s1;
            id_s2      <= s2;
            id_imm     <= imm;
            id_gpr_s1  <= gpr_rdata1;
            id_gpr_s2  <= gpr_rdata2;
            id_hreg_s1 <= hreg_rdata1;
            id_hreg_s2 <= hreg_rdata2;
            id_pc      <= if_pc;

            // ── Control signal decode ───────────────────────────
            // Defaults
            id_gpr_we    <= 1'b0;
            id_hreg_we   <= 1'b0;
            id_mem_read  <= 1'b0;
            id_mem_write <= 1'b0;
            id_is_branch <= 1'b0;
            id_is_jump   <= 1'b0;
            id_is_codex  <= 1'b0;
            id_is_halt   <= 1'b0;
            id_is_print  <= 1'b0;
            id_is_push   <= 1'b0;
            id_is_pop    <= 1'b0;

            case (opcode)
                `OP_NOP:    ;  // no-op

                `OP_HALT:   id_is_halt <= 1'b1;

                `OP_MOV:    id_gpr_we <= 1'b1;
                `OP_MOVI:   id_gpr_we <= 1'b1;

                `OP_ADD:    id_gpr_we <= 1'b1;
                `OP_ADDI:   id_gpr_we <= 1'b1;
                `OP_SUB:    id_gpr_we <= 1'b1;
                `OP_MUL:    id_gpr_we <= 1'b1;

                `OP_CMP:    ;  // Only sets flags, no reg write
                `OP_CMPI:   ;

                `OP_JMP:    id_is_jump <= 1'b1;
                `OP_JEQ:    id_is_branch <= 1'b1;
                `OP_JNE:    id_is_branch <= 1'b1;
                `OP_JGD:    id_is_branch <= 1'b1;
                `OP_JNGD:   id_is_branch <= 1'b1;

                `OP_PUSH:   id_is_push <= 1'b1;
                `OP_POP:    begin id_is_pop <= 1'b1; id_gpr_we <= 1'b1; end

                `OP_HLOAD:  begin id_is_codex <= 1'b1; id_hreg_we <= 1'b1; end
                `OP_HCADD:  begin id_is_codex <= 1'b1; id_hreg_we <= 1'b1; end
                `OP_HGRD:   begin id_is_codex <= 1'b1; end  // Sets GUARD flag only
                `OP_HNRM2:  begin id_is_codex <= 1'b1; id_gpr_we <= 1'b1; end
                `OP_HDIST:  begin id_is_codex <= 1'b1; id_gpr_we <= 1'b1; end

                `OP_PRINT:  id_is_print <= 1'b1;

                default:    id_is_halt <= 1'b1;  // Unimplemented → HALT_ERR
            endcase
        end
        // If stall: hold all outputs unchanged
    end

endmodule
