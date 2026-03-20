"""H-ISA Machine: fetch-decode-execute cycle."""

from __future__ import annotations

from dataclasses import dataclass
from typing import List, Optional

from .registers import RegisterFile
from .opcodes import OpCode, InstructionWord
from ..core.master_table import MasterTable
from ..core.guards import guard_check, compute_U


@dataclass
class TraceEntry:
    """One line in the execution trace."""

    cycle: int
    description: str


class HISAMachine:
    """
    H-ISA Virtual Machine.

    Supports:
      CLOAD — load letter from Master Table into H-register
      CADD  — component-wise add two H-registers
      CSUB  — component-wise subtract (14D Delta)
      VCHK  — guard check on H-register
      VDIST — squared Euclidean distance between two H-registers
      VRHO  — compute turning residue
      VNORM — squared norm of H-register
      VDOT  — inner product of two H-registers
      VMOV  — copy H-register
      PRINT — output H-register contents
      HALT  — stop execution
    """

    def __init__(self, table: MasterTable) -> None:
        self.table = table
        self.regs = RegisterFile()
        self.code: List[int] = []
        self.trace: List[TraceEntry] = []
        self.cycle: int = 0
        self._halted: bool = False

    def load_program(self, code: List[int]) -> None:
        """Load bytecode into code memory."""
        self.code = list(code)
        self.regs.pc = 0
        self._halted = False

    def step(self) -> Optional[TraceEntry]:
        """Execute one instruction. Returns trace entry or None if done."""
        if self._halted or self.regs.pc >= len(self.code):
            return None

        raw = self.code[self.regs.pc]
        iw = InstructionWord(raw)
        self.regs.pc += 1
        self.cycle += 1

        desc = self._execute(iw)
        entry = TraceEntry(self.cycle, desc)
        self.trace.append(entry)
        return entry

    def _execute(self, iw: InstructionWord) -> str:
        """Execute a decoded instruction. Returns description string."""
        op = iw.opcode
        dst = iw.dst % 4
        s1 = iw.src1 % 4
        s2 = iw.src2 % 4
        imm = iw.imm

        entries = self.table.all_entries()

        # ── CLOAD: load letter into H-register
        if op == OpCode.CLOAD:
            if imm < len(entries):
                entry = entries[imm]
                self.regs.hreg[dst] = list(entry.vector)
                return f"CLOAD H{dst} ← {entry.char} ({entry.name}) [idx={imm}]"
            return f"CLOAD H{dst} ← INVALID INDEX {imm}"

        # ── CADD: H[dst] = H[s1] + H[s2]
        if op == OpCode.CADD:
            a = self.regs.hreg[s1]
            b = self.regs.hreg[s2]
            self.regs.hreg[dst] = [a[i] + b[i] for i in range(18)]
            return f"CADD H{dst} = H{s1} + H{s2}"

        # ── CSUB: H[dst] = H[s1] - H[s2] (14D)
        if op == OpCode.CSUB:
            a = self.regs.hreg[s1]
            b = self.regs.hreg[s2]
            self.regs.hreg[dst] = [a[i] - b[i] for i in range(14)] + [0] * 4
            return f"CSUB H{dst} = H{s1} - H{s2} (14D)"

        # ── VCHK: guard check
        if op == OpCode.VCHK:
            h = self.regs.hreg[s1]
            ok = guard_check(h)
            self.regs.sr.guard_pass = ok
            return f"VCHK H{s1} → {'PASS ✓' if ok else 'FAIL ✗'}"

        # ── VDIST: squared Euclidean distance
        if op == OpCode.VDIST:
            a = self.regs.hreg[s1]
            b = self.regs.hreg[s2]
            d2 = sum((a[i] - b[i]) ** 2 for i in range(14))
            self.regs.gpr[0] = d2
            return f"VDIST R0 = ‖H{s1} - H{s2}‖² = {d2}"

        # ── VRHO: compute residue
        if op == OpCode.VRHO:
            h = self.regs.hreg[s1]
            U = compute_U(h)
            rho = h[0] - U
            self.regs.gpr[0] = rho
            return f"VRHO R0 = ρ(H{s1}) = Θ̂({h[0]}) - U({U}) = {rho}"

        # ── VNORM: squared norm
        if op == OpCode.VNORM:
            h = self.regs.hreg[s1]
            n2 = sum(x * x for x in h[:14])
            self.regs.gpr[0] = n2
            return f"VNORM R0 = ‖H{s1}‖² = {n2}"

        # ── VDOT: inner product
        if op == OpCode.VDOT:
            a = self.regs.hreg[s1]
            b = self.regs.hreg[s2]
            ip = sum(a[i] * b[i] for i in range(14))
            self.regs.gpr[0] = ip
            return f"VDOT R0 = ⟨H{s1}, H{s2}⟩ = {ip}"

        # ── VMOV: copy register
        if op == OpCode.VMOV:
            self.regs.hreg[dst] = list(self.regs.hreg[s1])
            return f"VMOV H{dst} = H{s1}"

        # ── PRINT: output register
        if op == OpCode.PRINT:
            h = self.regs.hreg[dst]
            return f"PRINT H{dst} = ({', '.join(str(x) for x in h)})"

        # ── HALT: stop execution
        if op == OpCode.HALT:
            self._halted = True
            return "HALT — execution stopped"

        # ── VPROJ_T: project to theta
        if op == OpCode.VPROJ_T:
            h = self.regs.hreg[s1]
            self.regs.hreg[dst] = [h[0]] + [0] * 17
            return f"VPROJ_T H{dst} = Π_Θ(H{s1})"

        # ── VPROJ_N: project to N
        if op == OpCode.VPROJ_N:
            h = self.regs.hreg[s1]
            r = [0] * 18
            r[1], r[2], r[3] = h[1], h[2], h[3]
            self.regs.hreg[dst] = r
            return f"VPROJ_N H{dst} = Π_N(H{s1})"

        # ── VPROJ_K: project to K
        if op == OpCode.VPROJ_K:
            h = self.regs.hreg[s1]
            r = [0] * 18
            for k in range(4, 9):
                r[k] = h[k]
            self.regs.hreg[dst] = r
            return f"VPROJ_K H{dst} = Π_K(H{s1})"

        # ── VPROJ_Q: project to Q
        if op == OpCode.VPROJ_Q:
            h = self.regs.hreg[s1]
            r = [0] * 18
            for k in range(9, 14):
                r[k] = h[k]
            self.regs.hreg[dst] = r
            return f"VPROJ_Q H{dst} = Π_Q(H{s1})"

        return f"UNKNOWN opcode 0x{op:02X}"

    def dump_state(self) -> dict:
        """Return full machine state as dict."""
        return {
            "pc": self.regs.pc,
            "gpr": list(self.regs.gpr),
            "hreg": [list(h) for h in self.regs.hreg],
            "sr": {
                "guard": self.regs.sr.guard_pass,
                "zero": self.regs.sr.zero,
                "overflow": self.regs.sr.overflow,
            },
        }

    def reset(self) -> None:
        """Reset machine to initial state."""
        self.regs = RegisterFile()
        self.code = []
        self.trace = []
        self.cycle = 0
        self._halted = False
