"""Energy-norm inequality: Φ(h) > ‖v₁₄‖² (Theorem 34.3.1)."""

from ..algebra.exometric import build, phi
from ..algebra.vektronometry import norm2
from ..core.master_table import MASTER_TABLE


def verify_all() -> bool:
    for e in MASTER_TABLE.all_entries():
        if phi(build(e)) <= norm2(e):
            return False
    return True
