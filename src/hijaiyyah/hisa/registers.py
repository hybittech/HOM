"""Register file for the H-ISA machine."""

from dataclasses import dataclass, field
from typing import List


@dataclass
class StatusFlags:
    guard_pass: bool = False
    zero: bool = False
    overflow: bool = False


@dataclass
class RegisterFile:
    gpr: List[int] = field(default_factory=lambda: [0] * 18)
    hreg: List[List[int]] = field(default_factory=lambda: [[0] * 18 for _ in range(4)])
    sr: StatusFlags = field(default_factory=StatusFlags)
    pc: int = 0
