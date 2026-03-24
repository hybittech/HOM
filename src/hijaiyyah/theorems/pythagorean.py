"""Vectronometric Pythagorean theorem (Theorem 20.2.1)."""

from ..algebra.vektronometry import pythagorean_check
from ..core.master_table import MASTER_TABLE


def verify_all() -> bool:
    return all(pythagorean_check(e)["pass"] for e in MASTER_TABLE.all_entries())
