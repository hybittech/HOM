"""
Guard check and audit detail for hybit/codex vectors.

Guards (on raw v18):
  G1: ρ = Θ̂ − U ≥ 0           (Axiom 11.3.2)
  G2: A_N = Na + Nb + Nd       (Definition 12.2.1)
  G3: A_K = Kp + Kx + Ks + Ka + Kc  (Definition 12.2.1)
  G4: A_Q = Qp + Qx + Qs + Qa + Qc  (Definition 12.2.1)

Audit relations R1–R5 (Identity 33.1.1):
  R1: Θ̂ = U + ρ               (Proposition 11.3.1)
  R2: A_N = Na + Nb + Nd       (Definition 12.2.1)
  R3: A_K = ΣK_j               (Definition 12.2.1)
  R4: A_Q = ΣQ_j               (Definition 12.2.1)
  R5: U = Qx + Qs + Qa + 4Qc  (Definition 11.1.1)
"""

from __future__ import annotations

from typing import Any, Dict, List


def _to_vec(v: Any) -> List[int]:
    """
    Normalize input to a list of 18 integers.
    Accepts: CodexEntry (has .vector), list, or tuple.
    """
    if hasattr(v, "vector"):
        return list(v.vector)
    if isinstance(v, (list, tuple)):
        return list(v)
    raise TypeError(f"Expected vector-like, got {type(v).__name__}")


def compute_U(v: Any) -> int:
    """U(h) = Qx + Qs + Qa + 4·Qc  (Definition 11.1.1)."""
    vec = _to_vec(v)
    return vec[10] + vec[11] + vec[12] + 4 * vec[13]


def compute_rho(v: Any) -> int:
    """ρ(h) = Θ̂ − U  (Definition 11.2.1)."""
    vec = _to_vec(v)
    return vec[0] - compute_U(vec)


def guard_check(v: Any) -> bool:
    """
    Check all 4 structural guards. Returns True if all pass.
    Complexity: O(1) — 15 additions + 4 comparisons.

    G1: ρ ≥ 0
    G2: A_N = Na + Nb + Nd
    G3: A_K = Kp + Kx + Ks + Ka + Kc
    G4: A_Q = Qp + Qx + Qs + Qa + Qc
    """
    vec = _to_vec(v)

    U = vec[10] + vec[11] + vec[12] + 4 * vec[13]
    rho = vec[0] - U

    g1 = rho >= 0
    g2 = vec[14] == vec[1] + vec[2] + vec[3]
    g3 = vec[15] == vec[4] + vec[5] + vec[6] + vec[7] + vec[8]
    g4 = vec[16] == vec[9] + vec[10] + vec[11] + vec[12] + vec[13]

    return g1 and g2 and g3 and g4


def guard_detail(v: Any) -> Dict[str, Any]:
    """
    Check all 5 audit relations (R1–R5) with detailed output.
    """
    vec = _to_vec(v)

    U = vec[10] + vec[11] + vec[12] + 4 * vec[13]
    rho = vec[0] - U

    R1 = (vec[0] == U + rho) and (rho >= 0)
    R2 = vec[14] == vec[1] + vec[2] + vec[3]
    R3 = vec[15] == vec[4] + vec[5] + vec[6] + vec[7] + vec[8]
    R4 = vec[16] == vec[9] + vec[10] + vec[11] + vec[12] + vec[13]
    R5 = U == vec[10] + vec[11] + vec[12] + 4 * vec[13]

    return {
        "R1": R1,
        "R2": R2,
        "R3": R3,
        "R4": R4,
        "R5": R5,
        "U": U,
        "rho": rho,
        "all_pass": R1 and R2 and R3 and R4 and R5,
    }
