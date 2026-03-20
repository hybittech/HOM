"""Opcode definitions and instruction word encoding."""

from __future__ import annotations
from dataclasses import dataclass
from enum import IntEnum


class OpCode(IntEnum):
    CLOAD = 0x01
    CADD = 0x02
    CSUB = 0x03
    VCHK = 0x04
    VDIST = 0x05
    VRHO = 0x06
    VNORM = 0x07
    VDOT = 0x08
    CHASH = 0x09
    CSIGN = 0x0A
    VMOV = 0x0B
    VSCL = 0x0C
    VCMP = 0x0D
    PRINT = 0x0E
    HALT = 0x0F
    VPROJ_T = 0x10
    VPROJ_N = 0x11
    VPROJ_K = 0x12
    VPROJ_Q = 0x13
    JMP = 0x20
    JGP = 0x21
    JGF = 0x22


@dataclass
class InstructionWord:
    raw: int

    @property
    def opcode(self) -> int:
        return (self.raw >> 24) & 0xFF

    @property
    def dst(self) -> int:
        return (self.raw >> 20) & 0xF

    @property
    def src1(self) -> int:
        return (self.raw >> 16) & 0xF

    @property
    def src2(self) -> int:
        return (self.raw >> 12) & 0xF

    @property
    def imm(self) -> int:
        return self.raw & 0xFFF

    def disassemble(self) -> str:
        try:
            op = OpCode(self.opcode)
            return f"{op.name} dst=H{self.dst} src1=H{self.src1} src2=H{self.src2} imm={self.imm}"
        except ValueError:
            return f"UNKNOWN(0x{self.opcode:02X})"
