# HCPU Microarchitecture — Detailed Design

## 1. Pipeline Overview

The HCPU implements a **5-stage in-order pipeline**:

```
  ┌───────┐    ┌───────┐    ┌─────────┐    ┌───────┐    ┌──────────┐
  │ FETCH │───►│DECODE │───►│ EXECUTE │───►│MEMORY │───►│WRITEBACK │
  │       │    │       │    │         │    │       │    │          │
  │ PC    │    │RegRead│    │ScalarALU│    │Stack  │    │RegWrite  │
  │ IMEM  │    │Decode │    │CodexALU │    │Load/  │    │FlagsUpd  │
  │       │    │       │    │Guard    │    │Store  │    │          │
  │       │    │       │    │Branch   │    │       │    │          │
  └───┬───┘    └───┬───┘    └────┬────┘    └───┬───┘    └──────────┘
      │            │             │              │
      ├────────────┴─────────────┘              │
      │         stall / flush                   │
      └─────────────────────────────────────────┘
```

## 2. Pipeline Registers

### IF/ID Register
| Signal | Width | Description |
|---|---|---|
| `if_instruction` | 32 | Raw instruction word |
| `if_pc` | 32 | PC of this instruction |

### ID/EX Register
| Signal | Width | Description |
|---|---|---|
| `id_opcode` | 8 | Decoded opcode |
| `id_dst` | 4 | Destination register index |
| `id_s1`, `id_s2` | 4 each | Source register indices |
| `id_imm` | 12 | Immediate value |
| `id_gpr_s1`, `id_gpr_s2` | 32 each | GPR read values |
| `id_hreg_s1`, `id_hreg_s2` | 144 each | H-Reg read values |
| `id_*_we`, `id_is_*` | 1 each | Control signals |

### EX/MEM Register
| Signal | Width | Description |
|---|---|---|
| `ex_gpr_result` | 32 | ALU / Codex scalar result |
| `ex_hreg_result` | 144 | Codex vector result |
| `ex_flags_new` | 8 | Updated FLAGS |
| `ex_push_data` | 32 | Data for PUSH |
| `ex_is_*` | 1 each | Pipeline control |

### MEM/WB Register
| Signal | Width | Description |
|---|---|---|
| `mem_gpr_result` | 32 | Final GPR write value |
| `mem_hreg_result` | 144 | Final H-Reg write value |
| `mem_flags_new` | 8 | Final FLAGS |

## 3. Hazard Handling

### Stall Conditions
1. **PRINT blocking**: When a PRINT instruction is executing and UART is busy,
   the entire pipeline freezes until transmission completes.
2. **Future multi-cycle ops**: Reserved for Tier 2 instructions.

### Flush Conditions
1. **Taken branch/jump**: Branch is resolved in the Execute stage.
   When taken, IF and ID pipeline registers are flushed (NOP inserted).
   This incurs a **1-cycle penalty** per taken branch.

### No Forwarding (Fase 1)
Data forwarding is not implemented in Fase 1. Programs must insert
NOP instructions between dependent operations or tolerate the
pipeline latency (3 cycles from write to read without forwarding).

## 4. Instruction Execution Timing

| Instruction | Cycles | Notes |
|---|---|---|
| NOP, HALT | 1 | Pipeline flow-through |
| MOV, MOVI | 1 | Simple register move |
| ADD, ADDI, SUB | 1 | Scalar ALU |
| MUL | 1 | Uses FPGA DSP block |
| CMP, CMPI | 1 | Sets FLAGS, no write |
| JMP | 1 + 1 flush | Absolute jump, 1 bubble |
| JEQ, JNE, JGD, JNGD | 1 + 0-1 flush | 0 if not taken, 1 if taken |
| PUSH, POP | 1 | Stack access |
| HLOAD | 1 | ROM lookup (combinational) |
| HCADD | 1 | 18 parallel adders |
| HGRD | 1 | Combinational guard check |
| HNRM2 | 1 | Adder tree (14 squares) |
| HDIST | 1 | Diff + square + sum tree |
| PRINT | N | Blocks until UART TX done |

## 5. Memory Architecture (Harvard)

```
┌─────────────────┐
│  Code ROM       │  Word-addressed, 4096 entries × 32-bit
│  (Read-only)    │  Loaded via $readmemh or written via MPW interface
└────────┬────────┘
         │ imem_addr[11:0]
         │
┌────────┴────────┐
│   HCPU Core     │
└────────┬────────┘
         │
┌────────┴────────┐
│  Master Table   │  Combinational ROM, 28 entries × 144-bit
│  ROM (hm28)     │  Indexed by letter number (1–28)
└─────────────────┘
         │
┌────────┴────────┐
│  Stack Memory   │  256 entries × 32-bit
│  (PUSH/POP)     │  Internal register array
└─────────────────┘
```

## 6. Register File Architecture

### GPR Bank
- **18 registers** × 32-bit (R0–R17)
- Dual read ports, single write port
- Asynchronous read, synchronous write
- R0 = return value / accumulator
- R17 = link register

### H-Reg Bank
- **16 registers** × 144-bit (H0–H15)
- Each stores one 18-dimensional codex vector
- Component access: `hreg[r][8*i +: 8]` for component `i`
- Dual read ports, single write port
- H0 = primary operand, H1 = secondary, H2 = result, H3 = temp

### FLAGS Register
| Bit | Name | Description |
|---|---|---|
| 0 | G | GUARD pass (set by HGRD) |
| 1 | Z | ZERO (set by CMP/CMPI) |
| 2 | O | OVERFLOW |
| 3 | LT | Less-than (signed comparison) |

## 7. Immediate Format

| Instruction | Extension | Range |
|---|---|---|
| MOVI | Zero-extend | 0 to 4095 |
| ADDI | Sign-extend | -2048 to +2047 |
| Branch offset | Sign-extend | -2048 to +2047 |
| JMP target | Zero-extend | 0 to 4095 |
| HLOAD index | Zero-extend | 1 to 28 |

## 8. Critical Paths

### Longest combinational path (estimated at 50 MHz)
1. **HNRM2/HDIST**: 14 multipliers + 13-input adder tree ≈ 8 LUT levels
2. **Guard checker**: 5-input adder + comparator ≈ 4 LUT levels
3. **Branch resolution**: CMP result → FLAGS → branch decision ≈ 3 LUT levels

All paths should meet 50 MHz timing (20 ns period) comfortably on
both Gowin GW1NR-9 and Xilinx XC7A35T.

---

*© 2026 HMCL — HCPU Microarchitecture v1.0*
