# HCPU RTL — Hijaiyyah Core Processing Unit

Hardware implementation of the HCPU processor for the HyBIT paradigm.

## Architecture

```
                    ┌─────────────────────────────────────────────────┐
                    │               HCPU Top-Level                    │
  ┌──────────┐     │  ┌───────┐  ┌───────┐  ┌─────────┐  ┌───────┐  │
  │   Code   │◄────┤  │ FETCH │─►│DECODE │─►│ EXECUTE │─►│MEMORY │──┤──► WB
  │   ROM    │     │  └───────┘  └───┬───┘  └────┬────┘  └───────┘  │
  └──────────┘     │                 │           │                    │
                    │            ┌────┴────┐  ┌──┴───┐  ┌──────────┐ │
                    │            │ RegFile │  │Codex │  │  Guard   │ │
                    │            │18 GPR   │  │ ALU  │  │ G1-G4   │ │
                    │            │16 H-Reg │  │18-wide│  │ T1-T2   │ │
                    │            └─────────┘  └──────┘  └──────────┘ │
                    │                              │                  │
                    │            ┌──────────┐  ┌───┴──┐  ┌────────┐  │
                    │            │Master ROM│  │ UART │  │ Ctrl   │  │
                    │            │28×144-bit│  │  TX  │  │Pipeline│  │
                    │            └──────────┘  └──────┘  └────────┘  │
                    └─────────────────────────────────────────────────┘
```

## Quick Start (Simulation)

### Requirements
- [Icarus Verilog](http://iverilog.icarus.com/) (`iverilog`)
- [GTKWave](http://gtkwave.sourceforge.net/) (optional, for waveforms)

### Run Tests
```bash
cd rtl/tb

# Run all testbenches
make all

# Run individual tests
make sim_rom          # Verify 28 ROM entries
make sim_guard        # Verify guard checker
make sim_codex_alu    # Verify vector ALU
make sim_top          # Run integration programs

# View waveforms
make wave_top
```

## FPGA Targets

### Gowin Tang Nano 9K (~$15)
- Device: GW1NR-LV9QN88PC6/I5
- Clock: 27 MHz → PLL → 50 MHz
- Files: `fpga/gowin/hcpu_gowin_top.v`, `fpga/gowin/hcpu_gowin.cst`
- Load program: `$readmemh("program.hex")`

### Xilinx Arty A7-35T (~$129)
- Device: XC7A35T-1CPG236C
- Clock: 100 MHz → MMCM → 50 MHz
- Files: `fpga/xilinx/hcpu_xilinx_top.v`, `fpga/xilinx/hcpu_xilinx.xdc`

### Programming
1. Assemble your H-ISA program:
   ```bash
   python scripts/asm2hex.py your_program.hasm > program.hex
   ```
2. Place `program.hex` in the FPGA project directory
3. Synthesize and program the board

## Resource Utilization (Estimated)

| Resource | Gowin GW1NR-9 | Xilinx XC7A35T |
|---|---|---|
| LUTs available | 8,640 | 20,800 |
| LUTs used (est.) | ~3,000 | ~3,000 |
| Registers | ~1,500 | ~1,500 |
| BRAM used | 2–4 blocks | 2–4 blocks |
| Fmax target | 50 MHz | 100 MHz |

## Supported Instructions (Tier 1)

| Category | Instructions |
|---|---|
| System | NOP, HALT, MOV, MOVI |
| Arithmetic | ADD, ADDI, SUB, MUL |
| Compare/Branch | CMP, CMPI, JMP, JEQ, JNE, JGD, JNGD |
| Stack | PUSH, POP |
| Codex | HLOAD, HCADD, HGRD, HNRM2, HDIST |
| I/O | PRINT (UART, blocking) |

## File Structure

```
rtl/
├── hcpu_pkg.vh          # Parameter header (opcodes, defines)
├── hcpu_top.v           # Top-level integration
├── hcpu_fetch.v         # Fetch stage
├── hcpu_decode.v        # Decode stage
├── hcpu_execute.v       # Execute stage
├── hcpu_memory.v        # Memory stage (stack)
├── hcpu_writeback.v     # Writeback stage
├── hcpu_regfile.v       # Register file
├── hcpu_codex_alu.v     # 18-wide vector ALU
├── hcpu_guard.v         # Hardware guard checker
├── hcpu_rom.v           # Master Table ROM
├── hcpu_uart_tx.v       # UART transmitter
├── hcpu_controller.v    # Pipeline controller
├── tb/                  # Testbenches
├── fpga/gowin/          # Gowin Tang Nano 9K
├── fpga/xilinx/         # Xilinx Arty A7
├── mpw/                 # MPW Shuttle plan
├── scripts/             # Support scripts
└── docs/                # Microarchitecture docs
```

## MPW Shuttle

See `mpw/MPW_SHUTTLE_PLAN.md` for the silicon tapeout strategy.
Priority: Efabless Open MPW (SKY130) → TinyTapeout → Europractice.

---

*© 2026 HMCL — HM-28-v1.2-HC18D*
