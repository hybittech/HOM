// ============================================================================
// HCPU Guard Checker — hcpu_guard.v
// Hardware implementation of G1–G4 structural guards + T1–T2 topology
// Single-cycle, fully combinational — sets GUARD flag in O(1)
// (c) 2026 HMCL — HM-28-v1.2-HC18D
// ============================================================================
//
// Guard checks (from Bab I, Matematika Hijaiyyah):
//   G1: A_N = Na + Nb + Nd
//   G2: A_K = Kp + Kx + Ks + Ka + Kc
//   G3: A_Q = Qp + Qx + Qs + Qa + Qc
//   G4: ρ = Θ̂ − U ≥ 0  where U = Qx + Qs + Qa + 4×Qc
//   T1: Ks > 0  ⇒  Qc ≥ 1
//   T2: Kc > 0  ⇒  Qc ≥ 1
//
// All checks take one cycle. Result is a single PASS/FAIL bit.
//

`include "hcpu_pkg.vh"

module hcpu_guard (
    input  wire [`HREG_W-1:0]  vec,         // 144-bit codex vector
    output wire                guard_pass,  // 1 = all guards pass
    output wire                g1_pass,
    output wire                g2_pass,
    output wire                g3_pass,
    output wire                g4_pass,
    output wire                t1_pass,
    output wire                t2_pass
);

    // ── Extract components ──────────────────────────────────────
    wire [7:0] theta = vec[8*`C_THETA +: 8];  // Θ̂
    wire [7:0] na    = vec[8*`C_NA    +: 8];   // Na
    wire [7:0] nb    = vec[8*`C_NB    +: 8];   // Nb
    wire [7:0] nd    = vec[8*`C_ND    +: 8];   // Nd
    wire [7:0] kp    = vec[8*`C_KP    +: 8];   // Kp
    wire [7:0] kx    = vec[8*`C_KX    +: 8];   // Kx
    wire [7:0] ks    = vec[8*`C_KS    +: 8];   // Ks
    wire [7:0] ka    = vec[8*`C_KA    +: 8];   // Ka
    wire [7:0] kc    = vec[8*`C_KC    +: 8];   // Kc
    wire [7:0] qp    = vec[8*`C_QP    +: 8];   // Qp
    wire [7:0] qx    = vec[8*`C_QX    +: 8];   // Qx
    wire [7:0] qs    = vec[8*`C_QS    +: 8];   // Qs
    wire [7:0] qa    = vec[8*`C_QA    +: 8];   // Qa
    wire [7:0] qc    = vec[8*`C_QC    +: 8];   // Qc
    wire [7:0] a_n   = vec[8*`C_AN    +: 8];   // A_N
    wire [7:0] a_k   = vec[8*`C_AK    +: 8];   // A_K
    wire [7:0] a_q   = vec[8*`C_AQ    +: 8];   // A_Q

    // ── G1: A_N = Na + Nb + Nd ──────────────────────────────────
    wire [9:0] sum_n = na + nb + nd;
    assign g1_pass = (a_n == sum_n[7:0]) && (sum_n[9:8] == 2'b00 || a_n == sum_n[7:0]);

    // ── G2: A_K = Kp + Kx + Ks + Ka + Kc ───────────────────────
    wire [10:0] sum_k = kp + kx + ks + ka + kc;
    assign g2_pass = (a_k == sum_k[7:0]);

    // ── G3: A_Q = Qp + Qx + Qs + Qa + Qc ───────────────────────
    wire [10:0] sum_q = qp + qx + qs + qa + qc;
    assign g3_pass = (a_q == sum_q[7:0]);

    // ── G4: ρ = Θ̂ − U ≥ 0 ──────────────────────────────────────
    // U = Qx + Qs + Qa + 4 × Qc
    wire [10:0] u_val = qx + qs + qa + ({qc, 2'b00});  // qc << 2 = 4*qc
    // ρ = Θ̂ − U (signed: need to check if theta >= U)
    assign g4_pass = (theta >= u_val[7:0]);

    // ── T1: Ks > 0 ⇒ Qc ≥ 1 ────────────────────────────────────
    assign t1_pass = (ks == 8'd0) || (qc >= 8'd1);

    // ── T2: Kc > 0 ⇒ Qc ≥ 1 (Kaf is an exception) ──────────────
    wire is_kaf = (theta == 8'd2 && a_k == 8'd1 && a_q == 8'd0 && kc == 8'd1);
    assign t2_pass = (kc == 8'd0) || (qc >= 8'd1) || is_kaf;

    // ── Combined result ─────────────────────────────────────────
    assign guard_pass = g1_pass & g2_pass & g3_pass & g4_pass
                      & t1_pass & t2_pass;

endmodule
