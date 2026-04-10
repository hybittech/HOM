#!/usr/bin/env python3
"""
asm2hex.py — H-ISA Assembly to Hex Converter

Reads .hasm assembly files and generates instruction hex for
$readmemh loading into testbench or FPGA instruction memory.

Each instruction is output as 8 hex digits (32 bits).

Usage:
    python asm2hex.py input.hasm > program.hex

(c) 2026 HMCL
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

# ── Opcode table (matching hcpu_pkg.vh) ──────────────────────────
OPCODES = {
    "NOP":    0x00,
    "HALT":   0x01,
    "MOV":    0x03,
    "MOVI":   0x04,
    "ADD":    0x10,
    "ADDI":   0x11,
    "SUB":    0x12,
    "MUL":    0x14,
    "CMP":    0x20,
    "CMPI":   0x21,
    "JMP":    0x22,
    "JEQ":    0x23,
    "JNE":    0x24,
    "JGD":    0x29,
    "JNGD":   0x2A,
    "PUSH":   0x32,
    "POP":    0x33,
    "HLOAD":  0x40,
    "HCADD":  0x42,
    "HGRD":   0x60,
    "HNRM2":  0x06,
    "HDIST":  0x07,
    "PRINT":  0xA0,
}

# ── Register name mapping ────────────────────────────────────────
def parse_reg(s: str) -> int:
    """Parse register name to 4-bit index."""
    s = s.strip().upper()
    if s.startswith("R"):
        return int(s[1:]) & 0xF
    elif s.startswith("H"):
        return int(s[1:]) & 0xF
    elif s == "_" or s == "":
        return 0
    else:
        return int(s) & 0xF


def parse_imm(s: str) -> int:
    """Parse immediate value (decimal, hex, or label)."""
    s = s.strip()
    if s.startswith("0x") or s.startswith("0X"):
        val = int(s, 16)
    elif s.startswith("#"):
        val = int(s[1:])
    else:
        val = int(s)
    return val & 0xFFF


def encode(op: int, dst: int = 0, s1: int = 0, s2: int = 0, imm: int = 0) -> int:
    """Encode instruction word: [OP:8][DST:4][S1:4][S2:4][IMM:12]."""
    return ((op & 0xFF) << 24) | ((dst & 0xF) << 20) | \
           ((s1 & 0xF) << 16) | ((s2 & 0xF) << 12) | (imm & 0xFFF)


def assemble_line(line: str, labels: dict, addr: int) -> int | None:
    """Assemble one line of H-ISA assembly into 32-bit instruction."""
    # Strip comments
    line = line.split(";")[0].strip()
    if not line or line.endswith(":"):
        return None

    parts = re.split(r"[,\s]+", line)
    mnemonic = parts[0].upper()

    if mnemonic not in OPCODES:
        raise ValueError(f"Unknown mnemonic: {mnemonic}")

    op = OPCODES[mnemonic]

    if mnemonic in ("NOP", "HALT"):
        return encode(op)

    elif mnemonic in ("MOV", "ADD", "SUB", "MUL", "CMP"):
        dst = parse_reg(parts[1])
        s1  = parse_reg(parts[2]) if len(parts) > 2 else 0
        s2  = parse_reg(parts[3]) if len(parts) > 3 else 0
        return encode(op, dst, s1, s2)

    elif mnemonic in ("MOVI", "ADDI", "CMPI"):
        dst = parse_reg(parts[1])
        s1  = parse_reg(parts[2]) if len(parts) > 2 else dst
        imm = parse_imm(parts[-1])
        return encode(op, dst, s1, 0, imm)

    elif mnemonic in ("JMP",):
        imm = parse_imm(parts[1]) if len(parts) > 1 else 0
        return encode(op, 0, 0, 0, imm)

    elif mnemonic in ("JEQ", "JNE", "JGD", "JNGD"):
        imm = parse_imm(parts[1]) if len(parts) > 1 else 0
        return encode(op, 0, 0, 0, imm)

    elif mnemonic in ("PUSH",):
        s1 = parse_reg(parts[1])
        return encode(op, 0, s1)

    elif mnemonic in ("POP",):
        dst = parse_reg(parts[1])
        return encode(op, dst)

    elif mnemonic in ("HLOAD",):
        dst = parse_reg(parts[1])
        imm = parse_imm(parts[2]) if len(parts) > 2 else 0
        return encode(op, dst, 0, 0, imm)

    elif mnemonic in ("HCADD",):
        dst = parse_reg(parts[1])
        s1  = parse_reg(parts[2]) if len(parts) > 2 else 0
        s2  = parse_reg(parts[3]) if len(parts) > 3 else 0
        return encode(op, dst, s1, s2)

    elif mnemonic in ("HGRD",):
        s1 = parse_reg(parts[1]) if len(parts) > 1 else 0
        return encode(op, 0, s1)

    elif mnemonic in ("HNRM2", "HDIST"):
        dst = parse_reg(parts[1])
        s1  = parse_reg(parts[2]) if len(parts) > 2 else 0
        s2  = parse_reg(parts[3]) if len(parts) > 3 else 0
        return encode(op, dst, s1, s2)

    elif mnemonic in ("PRINT",):
        s1 = parse_reg(parts[1]) if len(parts) > 1 else 0
        return encode(op, 0, s1)

    return encode(op)


def main():
    if len(sys.argv) < 2:
        print("Usage: asm2hex.py input.hasm > program.hex", file=sys.stderr)
        sys.exit(1)

    src = Path(sys.argv[1])
    lines = src.read_text().splitlines()

    # Pass 1: collect labels
    labels = {}
    addr = 0
    for line in lines:
        stripped = line.split(";")[0].strip()
        if stripped.endswith(":"):
            labels[stripped[:-1]] = addr
        elif stripped and not stripped.startswith(";"):
            addr += 1

    # Pass 2: assemble
    addr = 0
    instructions = []
    for line in lines:
        stripped = line.split(";")[0].strip()
        if not stripped or stripped.endswith(":"):
            continue
        word = assemble_line(line, labels, addr)
        if word is not None:
            instructions.append(word)
            addr += 1

    # Output hex
    for i, word in enumerate(instructions):
        print(f"{word:08X}  // addr {i:4d}: {lines[i] if i < len(lines) else ''}")


if __name__ == "__main__":
    main()
