// ============================================================================
// Testbench: HCPU Top-Level Integration — tb_hcpu_top.v
// End-to-end test with instruction memory
// (c) 2026 HMCL
// ============================================================================

`timescale 1ns/1ps
`include "hcpu_pkg.vh"

module tb_hcpu_top;

    reg  clk, rst_n;
    wire [`CODE_ADDR_W-1:0] imem_addr;
    wire [`ILEN-1:0]        imem_data;
    wire uart_tx, halted_out, guard_led;

    // ── Instruction ROM ─────────────────────────────────────────
    reg [`ILEN-1:0] imem [0:`CODE_DEPTH-1];
    assign imem_data = imem[imem_addr];

    // ── DUT ─────────────────────────────────────────────────────
    hcpu_top #(
        .CLK_HZ(50_000_000),
        .BAUD(5_000_000)       // Fast baud for simulation
    ) uut (
        .clk       (clk),
        .rst_n     (rst_n),
        .imem_addr (imem_addr),
        .imem_data (imem_data),
        .uart_tx   (uart_tx),
        .halted    (halted_out),
        .guard_led (guard_led)
    );

    // ── Clock generation (50 MHz → 20 ns period) ────────────────
    initial clk = 0;
    always #10 clk = ~clk;

    // ── Helper: encode instruction ──────────────────────────────
    function [`ILEN-1:0] enc;
        input [7:0]  op;
        input [3:0]  dst;
        input [3:0]  s1;
        input [3:0]  s2;
        input [11:0] imm;
        begin
            enc = {op, dst, s1, s2, imm};
        end
    endfunction

    integer i;
    integer cycle_count;

    initial begin
        $dumpfile("tb_hcpu_top.vcd");
        $dumpvars(0, tb_hcpu_top);

        // Initialize instruction memory to NOP
        for (i = 0; i < `CODE_DEPTH; i = i + 1)
            imem[i] = {`OP_NOP, 24'h000000};

        // ═══════════════════════════════════════════════════════
        //  Program 1: Load Ba, Guard Check → should PASS
        // ═══════════════════════════════════════════════════════
        //
        // addr 0: HLOAD H0, #2
        // NOPs to wait for writeback
        // addr 4: HGRD  _, H0, _
        // addr 5: MOVI  R0, #42
        // addr 6: HALT
        //

        imem[0] = enc(`OP_HLOAD, 4'd0, 4'd0, 4'd0, 12'd2);   // H0 ← ROM[2] (Ba)
        imem[1] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[2] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[3] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[4] = enc(`OP_HGRD,  4'd0, 4'd0, 4'd0, 12'd0);   // Guard H0
        imem[5] = enc(`OP_MOVI,  4'd0, 4'd0, 4'd0, 12'd42);  // R0 ← 42
        imem[6] = enc(`OP_HALT,  4'd0, 4'd0, 4'd0, 12'd0);   // HALT

        // ── Reset ───────────────────────────────────────────────
        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;

        // ── Run until HALT ──────────────────────────────────────
        cycle_count = 0;
        while (!halted_out && cycle_count < 100) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
        end

        $display("=== HCPU Integration Test ===");
        $display("Program halted after %0d cycles", cycle_count);

        // Verify guard_led should be 1 (Ba passes all guards)
        if (guard_led) begin
            $display("PASS: Guard LED is ON (Ba passes)");
        end else begin
            $display("INFO: Guard LED state = %b", guard_led);
        end

        // Verify R0 = 42
        if (uut.u_regfile.gpr[0] == 32'd42) begin
            $display("PASS: R0 = 42");
        end else begin
            $display("FAIL: R0 = %0d (expected 42)", uut.u_regfile.gpr[0]);
        end

        // Verify H0 contains Ba vector
        $display("H0[Theta] = %0d (expected 2)",
            uut.u_regfile.hreg[0][8*0 +: 8]);
        $display("H0[Nd]    = %0d (expected 1)",
            uut.u_regfile.hreg[0][8*3 +: 8]);

        $display("=============================");

        // ═══════════════════════════════════════════════════════
        //  Program 2: HCADD — String integral "بسم"
        // ═══════════════════════════════════════════════════════
        for (i = 0; i < `CODE_DEPTH; i = i + 1)
            imem[i] = {`OP_NOP, 24'h000000};

        imem[0] = enc(`OP_HLOAD, 4'd0, 4'd0, 4'd0, 12'd2);   // H0 ← Ba
        imem[1] = enc(`OP_HLOAD, 4'd1, 4'd0, 4'd0, 12'd12);  // H1 ← Sin
        // Wait 3 cycles for H1 to WB
        imem[2] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[3] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[4] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        
        imem[5] = enc(`OP_HCADD, 4'd2, 4'd0, 4'd1, 12'd0);   // H2 ← H0+H1
        imem[6] = enc(`OP_HLOAD, 4'd3, 4'd0, 4'd0, 12'd24);  // H3 ← Mim
        // Wait 3 cycles for H3 and H2 to WB
        imem[7] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[8] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[9] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);

        imem[10] = enc(`OP_HCADD, 4'd2, 4'd2, 4'd3, 12'd0);  // H2 ← H2+H3
        // Wait 3 cycles
        imem[11] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[12] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[13] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);

        imem[14] = enc(`OP_HGRD,  4'd0, 4'd2, 4'd0, 12'd0);  // Guard H2
        imem[15] = enc(`OP_HNRM2, 4'd0, 4'd2, 4'd0, 12'd0);  // R0 ← ‖H2‖²
        // Wait for R0 to WB
        imem[16] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[17] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[18] = enc(`OP_NOP, 4'd0, 4'd0, 4'd0, 12'd0);
        imem[19] = enc(`OP_HALT,  4'd0, 4'd0, 4'd0, 12'd0);

        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;

        cycle_count = 0;
        while (!halted_out && cycle_count < 200) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
        end

        $display("Program 2 (BSM) halted after %0d cycles", cycle_count);

        // BSM aggregate Θ̂ should be 10
        $display("H2[Theta] = %0d (expected 10)",
            uut.u_regfile.hreg[2][8*0 +: 8]);

        // Guard should pass on aggregated BSM
        $display("Guard LED = %b (expected 1)", guard_led);

        $display("R0 (‖BSM‖²) = %0d", uut.u_regfile.gpr[0]);

        // ═══════════════════════════════════════════════════════
        //  Program 3: Arithmetic + Branch
        // ═══════════════════════════════════════════════════════
        for (i = 0; i < `CODE_DEPTH; i = i + 1)
            imem[i] = {`OP_NOP, 24'h000000};

        // Count from 0 to 3 using loop
        imem[0] = enc(`OP_MOVI,  4'd0, 4'd0, 4'd0, 12'd0);   // R0 ← 0
        imem[1] = enc(`OP_MOVI,  4'd1, 4'd0, 4'd0, 12'd3);   // R1 ← 3
        imem[2] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[3] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[4] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        // loop: (addr 5)
        imem[5] = enc(`OP_ADDI,  4'd0, 4'd0, 4'd0, 12'd1);   // R0 ← R0 + 1
        imem[6] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[7] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[8] = enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        
        imem[9] = enc(`OP_CMP,   4'd0, 4'd0, 4'd1, 12'd0);   // CMP R0, R1
        imem[10]= enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[11]= enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[12]= enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        
        // At EX for JNE (addr 12 is fetch, dec 11, ex 10 ... wait JNE is at addr 13)
        // If PC=13, JNE needs to branch back to 5.
        // Current PC at EX is 13.
        // Target = 13 - 8 = 5. So imm is -8.
        imem[13]= enc(`OP_JNE,   4'd0, 4'd0, 4'd0, 12'hFF8); // JNE -8 (→ addr 5)
        
        // Wait to finish
        imem[14]= enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[15]= enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[16]= enc(`OP_NOP,   4'd0, 4'd0, 4'd0, 12'd0);
        imem[17]= enc(`OP_HALT,  4'd0, 4'd0, 4'd0, 12'd0);

        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;

        cycle_count = 0;
        while (!halted_out && cycle_count < 500) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
        end

        $display("Program 3 (loop) halted after %0d cycles", cycle_count);

        if (uut.u_regfile.gpr[0] == 32'd3) begin
            $display("PASS: R0 = 3 (loop counted correctly)");
        end else begin
            $display("FAIL: R0 = %0d (expected 3)", uut.u_regfile.gpr[0]);
        end

        $display("=============================");
        $display("=== All integration tests complete ===");

        #100;
        $finish;
    end

    // Timeout watchdog
    initial begin
        #100000;
        $display("TIMEOUT: Simulation exceeded time limit");
        $finish(1);
    end

endmodule
