// ============================================================================
// HCPU Top-Level — hcpu_top.v
// Hijaiyyah Core Processing Unit — 5-stage pipeline
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================
//
// Architecture: Fetch → Decode → Execute → Memory → Writeback
// Stall: PRINT blocking, future multi-cycle ops
// Flush: Taken branch (1-cycle penalty)
//
// External interfaces:
//   - imem_*: Instruction memory (synchronous ROM)
//   - uart_tx: UART transmit pin
//   - halted: Processor halted indicator
//   - guard_led: GUARD flag indicator
//

`include "hcpu_pkg.vh"

module hcpu_top #(
    parameter CLK_HZ = `SYS_CLK_HZ,
    parameter BAUD   = `UART_BAUD
)(
    input  wire        clk,
    input  wire        rst_n,

    // ── Instruction memory interface ────────────────────────────
    output wire [`CODE_ADDR_W-1:0] imem_addr,
    input  wire [`ILEN-1:0]        imem_data,

    // ── External I/O ────────────────────────────────────────────
    output wire        uart_tx,
    output wire        halted,
    output wire        guard_led      // Current GUARD flag state
);

    // ════════════════════════════════════════════════════════════
    //  Internal wires
    // ════════════════════════════════════════════════════════════

    // Pipeline control
    wire pipe_stall, pipe_flush;
    wire branch_taken_w;
    wire [`XLEN-1:0] branch_target_w;

    // Fetch → Decode
    wire [`ILEN-1:0] if_instruction;
    wire [`XLEN-1:0] if_pc;

    // Decode → Execute
    wire [7:0]  id_opcode;
    wire [3:0]  id_dst, id_s1, id_s2;
    wire [11:0] id_imm;
    wire [`XLEN-1:0]  id_gpr_s1, id_gpr_s2;
    wire [`HREG_W-1:0] id_hreg_s1, id_hreg_s2;
    wire [`XLEN-1:0]  id_pc;
    wire id_gpr_we, id_hreg_we, id_mem_read, id_mem_write;
    wire id_is_branch, id_is_jump, id_is_codex;
    wire id_is_halt, id_is_print, id_is_push, id_is_pop;

    // Execute → Memory
    wire [7:0]  ex_opcode;
    wire [3:0]  ex_dst;
    wire [`XLEN-1:0]   ex_gpr_result;
    wire [`HREG_W-1:0] ex_hreg_result;
    wire ex_gpr_we, ex_hreg_we;
    wire [7:0] ex_flags_new;
    wire ex_flags_we, ex_is_halt, ex_is_print;
    wire [`XLEN-1:0] ex_print_data;
    wire ex_is_push, ex_is_pop;
    wire [`XLEN-1:0] ex_push_data;

    // Memory → Writeback
    wire [3:0]  mem_dst;
    wire [`XLEN-1:0]   mem_gpr_result;
    wire [`HREG_W-1:0] mem_hreg_result;
    wire mem_gpr_we, mem_hreg_we;
    wire [7:0] mem_flags_new;
    wire mem_flags_we, mem_is_halt;

    // Writeback → Register file
    wire wb_gpr_we, wb_hreg_we, wb_flags_we, wb_halt;
    wire [4:0]  wb_gpr_waddr;
    wire [`XLEN-1:0]  wb_gpr_wdata;
    wire [3:0]  wb_hreg_waddr;
    wire [`HREG_W-1:0] wb_hreg_wdata;
    wire [7:0]  wb_flags;

    // Register file read wires
    wire [4:0]  gpr_raddr1, gpr_raddr2;
    wire [`XLEN-1:0]  gpr_rdata1, gpr_rdata2;
    wire [3:0]  hreg_raddr1, hreg_raddr2;
    wire [`HREG_W-1:0] hreg_rdata1, hreg_rdata2;
    wire [7:0]  flags_out;
    wire [`XLEN-1:0] pc_out;

    // ROM
    wire [`ROM_ADDR_W-1:0] rom_addr;
    wire [`HREG_W-1:0]     rom_data;
    wire                   rom_valid;

    // Guard
    wire [`HREG_W-1:0] guard_vec;
    wire guard_pass, g1, g2, g3, g4, t1, t2;

    // Codex ALU
    wire [2:0]  calu_op;
    wire [`HREG_W-1:0] calu_src1, calu_src2;
    wire [`HREG_W-1:0] calu_result_vec;
    wire [`XLEN-1:0]   calu_result_scl;
    wire               calu_done;

    // UART
    wire uart_busy;
    reg  uart_start;
    reg  [7:0] uart_data;

    // ════════════════════════════════════════════════════════════
    //  UART TX — print handling
    // ════════════════════════════════════════════════════════════

    // Simple byte-by-byte decimal print FSM
    // Converts GPR value to ASCII digits and sends via UART
    reg [2:0] print_state;
    reg [`XLEN-1:0] print_val;
    reg [3:0] digit_cnt;
    reg [7:0] digits [0:9];
    reg [3:0] digit_idx;
    reg       print_active;

    localparam P_IDLE   = 3'd0;
    localparam P_CONV   = 3'd1;
    localparam P_SEND   = 3'd2;
    localparam P_WAIT   = 3'd3;
    localparam P_NEWLN  = 3'd4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            print_state <= P_IDLE;
            uart_start  <= 1'b0;
            uart_data   <= 8'h00;
            print_active <= 1'b0;
            digit_cnt   <= 4'd0;
            digit_idx   <= 4'd0;
            print_val   <= 0;
        end else begin
            uart_start <= 1'b0;

            case (print_state)
                P_IDLE: begin
                    print_active <= 1'b0;
                    if (ex_is_print && !pipe_stall) begin
                        print_val    <= ex_print_data;
                        print_active <= 1'b1;
                        digit_cnt    <= 4'd0;
                        print_state  <= P_CONV;
                    end
                end

                P_CONV: begin
                    // Convert value to ASCII digits (reverse order)
                    if (print_val == 0 && digit_cnt == 0) begin
                        digits[0]   <= 8'h30;  // '0'
                        digit_cnt   <= 4'd1;
                        print_state <= P_SEND;
                        digit_idx   <= 4'd0;
                    end else if (print_val > 0) begin
                        digits[digit_cnt] <= 8'h30 + print_val % 10;
                        print_val         <= print_val / 10;
                        digit_cnt         <= digit_cnt + 1;
                    end else begin
                        // All digits extracted, start sending (MSB first)
                        digit_idx   <= digit_cnt - 1;
                        print_state <= P_SEND;
                    end
                end

                P_SEND: begin
                    if (!uart_busy) begin
                        uart_data  <= digits[digit_idx];
                        uart_start <= 1'b1;
                        print_state <= P_WAIT;
                    end
                end

                P_WAIT: begin
                    if (!uart_busy && !uart_start) begin
                        if (digit_idx == 0) begin
                            print_state <= P_NEWLN;
                        end else begin
                            digit_idx   <= digit_idx - 1;
                            print_state <= P_SEND;
                        end
                    end
                end

                P_NEWLN: begin
                    // Send newline
                    if (!uart_busy) begin
                        uart_data   <= 8'h0A;  // '\n'
                        uart_start  <= 1'b1;
                        print_state <= P_IDLE;
                    end
                end

                default: print_state <= P_IDLE;
            endcase
        end
    end

    // ════════════════════════════════════════════════════════════
    //  Module instantiations
    // ════════════════════════════════════════════════════════════

    // ── Fetch ───────────────────────────────────────────────────
    hcpu_fetch u_fetch (
        .clk            (clk),
        .rst_n          (rst_n),
        .stall          (pipe_stall),
        .flush          (pipe_flush),
        .branch_taken   (branch_taken_w),
        .branch_target  (branch_target_w),
        .imem_addr      (imem_addr),
        .imem_data      (imem_data),
        .if_instruction (if_instruction),
        .if_pc          (if_pc)
    );

    // ── Decode ──────────────────────────────────────────────────
    hcpu_decode u_decode (
        .clk            (clk),
        .rst_n          (rst_n),
        .stall          (pipe_stall),
        .flush          (pipe_flush),
        .if_instruction (if_instruction),
        .if_pc          (if_pc),
        .gpr_raddr1     (gpr_raddr1),
        .gpr_raddr2     (gpr_raddr2),
        .gpr_rdata1     (gpr_rdata1),
        .gpr_rdata2     (gpr_rdata2),
        .hreg_raddr1    (hreg_raddr1),
        .hreg_raddr2    (hreg_raddr2),
        .hreg_rdata1    (hreg_rdata1),
        .hreg_rdata2    (hreg_rdata2),
        .id_opcode      (id_opcode),
        .id_dst         (id_dst),
        .id_s1          (id_s1),
        .id_s2          (id_s2),
        .id_imm         (id_imm),
        .id_gpr_s1      (id_gpr_s1),
        .id_gpr_s2      (id_gpr_s2),
        .id_hreg_s1     (id_hreg_s1),
        .id_hreg_s2     (id_hreg_s2),
        .id_pc          (id_pc),
        .id_gpr_we      (id_gpr_we),
        .id_hreg_we     (id_hreg_we),
        .id_mem_read    (id_mem_read),
        .id_mem_write   (id_mem_write),
        .id_is_branch   (id_is_branch),
        .id_is_jump     (id_is_jump),
        .id_is_codex    (id_is_codex),
        .id_is_halt     (id_is_halt),
        .id_is_print    (id_is_print),
        .id_is_push     (id_is_push),
        .id_is_pop      (id_is_pop)
    );

    // ── Execute ─────────────────────────────────────────────────
    hcpu_execute u_execute (
        .clk            (clk),
        .rst_n          (rst_n),
        .stall          (pipe_stall),
        .flush          (pipe_flush),
        .id_opcode      (id_opcode),
        .id_dst         (id_dst),
        .id_s1          (id_s1),
        .id_s2          (id_s2),
        .id_imm         (id_imm),
        .id_gpr_s1      (id_gpr_s1),
        .id_gpr_s2      (id_gpr_s2),
        .id_hreg_s1     (id_hreg_s1),
        .id_hreg_s2     (id_hreg_s2),
        .id_pc          (id_pc),
        .id_gpr_we      (id_gpr_we),
        .id_hreg_we     (id_hreg_we),
        .id_is_branch   (id_is_branch),
        .id_is_jump     (id_is_jump),
        .id_is_codex    (id_is_codex),
        .id_is_halt     (id_is_halt),
        .id_is_print    (id_is_print),
        .id_is_push     (id_is_push),
        .id_is_pop      (id_is_pop),
        .current_flags  (flags_out),
        .rom_addr       (rom_addr),
        .rom_data       (rom_data),
        .rom_valid      (rom_valid),
        .guard_vec      (guard_vec),
        .guard_pass     (guard_pass),
        .calu_op        (calu_op),
        .calu_src1      (calu_src1),
        .calu_src2      (calu_src2),
        .calu_result_vec(calu_result_vec),
        .calu_result_scl(calu_result_scl),
        .ex_opcode      (ex_opcode),
        .ex_dst         (ex_dst),
        .ex_gpr_result  (ex_gpr_result),
        .ex_hreg_result (ex_hreg_result),
        .ex_gpr_we      (ex_gpr_we),
        .ex_hreg_we     (ex_hreg_we),
        .ex_flags_new   (ex_flags_new),
        .ex_flags_we    (ex_flags_we),
        .ex_is_halt     (ex_is_halt),
        .ex_is_print    (ex_is_print),
        .ex_print_data  (ex_print_data),
        .ex_is_push     (ex_is_push),
        .ex_is_pop      (ex_is_pop),
        .ex_push_data   (ex_push_data),
        .branch_taken   (branch_taken_w),
        .branch_target  (branch_target_w)
    );

    // ── Memory ──────────────────────────────────────────────────
    hcpu_memory u_memory (
        .clk            (clk),
        .rst_n          (rst_n),
        .stall          (pipe_stall),
        .ex_opcode      (ex_opcode),
        .ex_dst         (ex_dst),
        .ex_gpr_result  (ex_gpr_result),
        .ex_hreg_result (ex_hreg_result),
        .ex_gpr_we      (ex_gpr_we),
        .ex_hreg_we     (ex_hreg_we),
        .ex_flags_new   (ex_flags_new),
        .ex_flags_we    (ex_flags_we),
        .ex_is_halt     (ex_is_halt),
        .ex_is_push     (ex_is_push),
        .ex_is_pop      (ex_is_pop),
        .ex_push_data   (ex_push_data),
        .mem_dst        (mem_dst),
        .mem_gpr_result (mem_gpr_result),
        .mem_hreg_result(mem_hreg_result),
        .mem_gpr_we     (mem_gpr_we),
        .mem_hreg_we    (mem_hreg_we),
        .mem_flags_new  (mem_flags_new),
        .mem_flags_we   (mem_flags_we),
        .mem_is_halt    (mem_is_halt)
    );

    // ── Writeback ───────────────────────────────────────────────
    hcpu_writeback u_writeback (
        .mem_dst        (mem_dst),
        .mem_gpr_result (mem_gpr_result),
        .mem_hreg_result(mem_hreg_result),
        .mem_gpr_we     (mem_gpr_we),
        .mem_hreg_we    (mem_hreg_we),
        .mem_flags_new  (mem_flags_new),
        .mem_flags_we   (mem_flags_we),
        .mem_is_halt    (mem_is_halt),
        .wb_gpr_we      (wb_gpr_we),
        .wb_gpr_waddr   (wb_gpr_waddr),
        .wb_gpr_wdata   (wb_gpr_wdata),
        .wb_hreg_we     (wb_hreg_we),
        .wb_hreg_waddr  (wb_hreg_waddr),
        .wb_hreg_wdata  (wb_hreg_wdata),
        .wb_flags_we    (wb_flags_we),
        .wb_flags       (wb_flags),
        .wb_halt        (wb_halt)
    );

    // ── Register file ───────────────────────────────────────────
    hcpu_regfile u_regfile (
        .clk         (clk),
        .rst_n       (rst_n),
        .gpr_raddr1  (gpr_raddr1),
        .gpr_raddr2  (gpr_raddr2),
        .gpr_rdata1  (gpr_rdata1),
        .gpr_rdata2  (gpr_rdata2),
        .gpr_we      (wb_gpr_we),
        .gpr_waddr   (wb_gpr_waddr),
        .gpr_wdata   (wb_gpr_wdata),
        .hreg_raddr1 (hreg_raddr1),
        .hreg_raddr2 (hreg_raddr2),
        .hreg_rdata1 (hreg_rdata1),
        .hreg_rdata2 (hreg_rdata2),
        .hreg_we     (wb_hreg_we),
        .hreg_waddr  (wb_hreg_waddr),
        .hreg_wdata  (wb_hreg_wdata),
        .flags_we    (wb_flags_we),
        .flags_in    (wb_flags),
        .flags_out   (flags_out),
        .pc_we       (1'b0),
        .pc_in       ({`XLEN{1'b0}}),
        .pc_out      (pc_out)
    );

    // ── Master Table ROM ────────────────────────────────────────
    hcpu_rom u_rom (
        .addr     (rom_addr),
        .data_out (rom_data),
        .valid    (rom_valid)
    );

    // ── Guard checker ───────────────────────────────────────────
    hcpu_guard u_guard (
        .vec        (guard_vec),
        .guard_pass (guard_pass),
        .g1_pass    (g1),
        .g2_pass    (g2),
        .g3_pass    (g3),
        .g4_pass    (g4),
        .t1_pass    (t1),
        .t2_pass    (t2)
    );

    // ── Codex ALU ───────────────────────────────────────────────
    hcpu_codex_alu u_codex_alu (
        .op         (calu_op),
        .src1       (calu_src1),
        .src2       (calu_src2),
        .result_vec (calu_result_vec),
        .result_scl (calu_result_scl),
        .done       (calu_done)
    );

    // ── UART TX ─────────────────────────────────────────────────
    hcpu_uart_tx #(
        .CLK_HZ (CLK_HZ),
        .BAUD   (BAUD)
    ) u_uart (
        .clk      (clk),
        .rst_n    (rst_n),
        .tx_data  (uart_data),
        .tx_start (uart_start),
        .tx_out   (uart_tx),
        .tx_busy  (uart_busy)
    );

    // ── Controller ──────────────────────────────────────────────
    hcpu_controller u_controller (
        .clk          (clk),
        .rst_n        (rst_n),
        .ex_is_print  (print_active),
        .branch_taken (branch_taken_w),
        .wb_halt      (wb_halt),
        .uart_busy    (uart_busy),
        .pipe_stall   (pipe_stall),
        .pipe_flush   (pipe_flush),
        .halted       (halted)
    );

    // ── Guard LED output ────────────────────────────────────────
    assign guard_led = flags_out[`FLAG_G];

endmodule
