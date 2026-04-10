// ============================================================================
// HCPU Execute Stage — hcpu_execute.v
// Scalar ALU, codex ALU, guard checker, branch resolution
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================

`include "hcpu_pkg.vh"

module hcpu_execute (
    input  wire                    clk,
    input  wire                    rst_n,

    // ── Pipeline control ────────────────────────────────────────
    input  wire                    stall,
    input  wire                    flush,

    // ── Input from Decode ───────────────────────────────────────
    input  wire [7:0]              id_opcode,
    input  wire [3:0]              id_dst,
    input  wire [3:0]              id_s1,
    input  wire [3:0]              id_s2,
    input  wire [11:0]             id_imm,
    input  wire [`XLEN-1:0]        id_gpr_s1,
    input  wire [`XLEN-1:0]        id_gpr_s2,
    input  wire [`HREG_W-1:0]      id_hreg_s1,
    input  wire [`HREG_W-1:0]      id_hreg_s2,
    input  wire [`XLEN-1:0]        id_pc,
    input  wire                    id_gpr_we,
    input  wire                    id_hreg_we,
    input  wire                    id_is_branch,
    input  wire                    id_is_jump,
    input  wire                    id_is_codex,
    input  wire                    id_is_halt,
    input  wire                    id_is_print,
    input  wire                    id_is_push,
    input  wire                    id_is_pop,
    input  wire [7:0]              current_flags,

    // ── Master Table ROM ────────────────────────────────────────
    output wire [`ROM_ADDR_W-1:0]  rom_addr,
    input  wire [`HREG_W-1:0]      rom_data,
    input  wire                    rom_valid,

    // ── Guard checker interface ─────────────────────────────────
    output wire [`HREG_W-1:0]      guard_vec,
    input  wire                    guard_pass,

    // ── Codex ALU interface ─────────────────────────────────────
    output wire [2:0]              calu_op,
    output wire [`HREG_W-1:0]      calu_src1,
    output wire [`HREG_W-1:0]      calu_src2,
    input  wire [`HREG_W-1:0]      calu_result_vec,
    input  wire [`XLEN-1:0]        calu_result_scl,

    // ── Output to Memory/Writeback ──────────────────────────────
    output reg  [7:0]              ex_opcode,
    output reg  [3:0]              ex_dst,
    output reg  [`XLEN-1:0]        ex_gpr_result,
    output reg  [`HREG_W-1:0]      ex_hreg_result,
    output reg                     ex_gpr_we,
    output reg                     ex_hreg_we,
    output reg  [7:0]              ex_flags_new,
    output reg                     ex_flags_we,
    output reg                     ex_is_halt,
    output reg                     ex_is_print,
    output reg  [`XLEN-1:0]        ex_print_data,
    output reg                     ex_is_push,
    output reg                     ex_is_pop,
    output reg  [`XLEN-1:0]        ex_push_data,

    // ── Branch output to Fetch ──────────────────────────────────
    output reg                     branch_taken,
    output reg  [`XLEN-1:0]        branch_target
);

    // ── Sign-extend immediate (for branches, ADDI) ──────────────
    wire [`XLEN-1:0] imm_sext = {{20{id_imm[11]}}, id_imm};
    wire [`XLEN-1:0] imm_zext = {{20{1'b0}}, id_imm};

    // ── Scalar ALU ──────────────────────────────────────────────
    reg [`XLEN-1:0] alu_result;
    reg [7:0]       alu_flags;
    reg             alu_flags_we;

    always @(*) begin
        alu_result   = {`XLEN{1'b0}};
        alu_flags    = current_flags;
        alu_flags_we = 1'b0;

        case (id_opcode)
            `OP_MOV:  alu_result = id_gpr_s1;
            `OP_MOVI: alu_result = imm_zext;
            `OP_ADD:  alu_result = id_gpr_s1 + id_gpr_s2;
            `OP_ADDI: alu_result = id_gpr_s1 + imm_sext;
            `OP_SUB:  alu_result = id_gpr_s1 - id_gpr_s2;
            `OP_MUL:  alu_result = id_gpr_s1 * id_gpr_s2;
            `OP_CMP, `OP_CMPI: begin
                alu_flags_we = 1'b1;
                // Compute S1 - S2/IMM for flag setting
                if (id_opcode == `OP_CMPI)
                    alu_result = id_gpr_s1 - imm_sext;
                else
                    alu_result = id_gpr_s1 - id_gpr_s2;
                // Set flags
                alu_flags[`FLAG_Z]  = (alu_result == 0);
                alu_flags[`FLAG_LT] = alu_result[`XLEN-1];  // Sign bit
            end
            default: alu_result = {`XLEN{1'b0}};
        endcase
    end

    // ── Codex operation routing ─────────────────────────────────
    assign rom_addr  = id_imm[`ROM_ADDR_W-1:0];
    assign guard_vec = id_hreg_s1;

    // Codex ALU operation select
    assign calu_op   = (id_opcode == `OP_HCADD) ? 3'd0 :
                       (id_opcode == `OP_HNRM2) ? 3'd1 :
                       (id_opcode == `OP_HDIST) ? 3'd2 : 3'd0;
    assign calu_src1 = id_hreg_s1;
    assign calu_src2 = id_hreg_s2;

    // Codex result mux
    reg [`HREG_W-1:0] codex_hvec;
    reg [`XLEN-1:0]   codex_gpr;

    always @(*) begin
        codex_hvec = {`HREG_W{1'b0}};
        codex_gpr  = {`XLEN{1'b0}};
        case (id_opcode)
            `OP_HLOAD: codex_hvec = rom_data;
            `OP_HCADD: codex_hvec = calu_result_vec;
            `OP_HNRM2: codex_gpr  = calu_result_scl;
            `OP_HDIST: codex_gpr  = calu_result_scl;
            default: ;
        endcase
    end

    // ── Branch resolution ───────────────────────────────────────
    always @(*) begin
        branch_taken  = 1'b0;
        branch_target = {`XLEN{1'b0}};

        if (id_is_jump) begin
            branch_taken  = 1'b1;
            branch_target = imm_zext;  // Absolute jump
        end else if (id_is_branch) begin
            case (id_opcode)
                `OP_JEQ:  branch_taken = current_flags[`FLAG_Z];
                `OP_JNE:  branch_taken = ~current_flags[`FLAG_Z];
                `OP_JGD:  branch_taken = current_flags[`FLAG_G];
                `OP_JNGD: branch_taken = ~current_flags[`FLAG_G];
                default:  branch_taken = 1'b0;
            endcase
            branch_target = id_pc + imm_sext;  // Relative branch
        end
    end

    // ── Pipeline register to Memory/Writeback ───────────────────
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            ex_opcode      <= `OP_NOP;
            ex_dst         <= 4'd0;
            ex_gpr_result  <= {`XLEN{1'b0}};
            ex_hreg_result <= {`HREG_W{1'b0}};
            ex_gpr_we      <= 1'b0;
            ex_hreg_we     <= 1'b0;
            ex_flags_new   <= 8'h00;
            ex_flags_we    <= 1'b0;
            ex_is_halt     <= 1'b0;
            ex_is_print    <= 1'b0;
            ex_print_data  <= {`XLEN{1'b0}};
            ex_is_push     <= 1'b0;
            ex_is_pop      <= 1'b0;
            ex_push_data   <= {`XLEN{1'b0}};
        end else if (!stall) begin
            ex_opcode   <= id_opcode;
            ex_dst      <= id_dst;
            ex_is_halt  <= id_is_halt;
            ex_is_print <= id_is_print;
            ex_is_push  <= id_is_push;
            ex_is_pop   <= id_is_pop;

            // GPR result selection
            if (id_is_codex && (id_opcode == `OP_HNRM2 || id_opcode == `OP_HDIST))
                ex_gpr_result <= codex_gpr;
            else if (id_is_pop)
                ex_gpr_result <= {`XLEN{1'b0}};  // Filled by memory stage
            else
                ex_gpr_result <= alu_result;

            // H-Reg result
            ex_hreg_result <= codex_hvec;

            // Write enables
            ex_gpr_we  <= id_gpr_we;
            ex_hreg_we <= id_hreg_we;

            // Flags
            if (id_opcode == `OP_HGRD) begin
                // Guard check — update GUARD flag
                ex_flags_new <= {current_flags[7:1], guard_pass};
                ex_flags_we  <= 1'b1;
            end else if (alu_flags_we) begin
                ex_flags_new <= alu_flags;
                ex_flags_we  <= 1'b1;
            end else begin
                ex_flags_new <= current_flags;
                ex_flags_we  <= 1'b0;
            end

            // Print data (GPR[S1] value)
            ex_print_data <= id_gpr_s1;

            // Push data (GPR[S1] value)
            ex_push_data <= id_gpr_s1;
        end
    end

endmodule
