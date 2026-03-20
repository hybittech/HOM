"""SHA-256 dataset seal computation and verification."""

from ..core.master_table import MASTER_TABLE


def compute_seal() -> str:
    return MASTER_TABLE.compute_sha256()


def verify_seal(expected: str) -> bool:
    return compute_seal() == expected
