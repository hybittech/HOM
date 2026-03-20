<div align="center">

# **H-ISA Specification**
## Hijaiyyah Instruction Set Architecture — Version 1.0

### Formal Instruction Set for Hijaiyyah Codex Computation

**HM-28-v1.0-HC18D · 2026**

</div>

---

## Daftar Isi

- [1. Pendahuluan](#1-pendahuluan)
- [2. Desain dan Prinsip](#2-desain-dan-prinsip)
- [3. Model Mesin](#3-model-mesin)
- [4. Register File](#4-register-file)
- [5. Format Instruction Word](#5-format-instruction-word)
- [6. Opcode Map](#6-opcode-map)
- [7. Operasi Codex Inti](#7-operasi-codex-inti)
- [8. Operasi Aritmetika dan Logika](#8-operasi-aritmetika-dan-logika)
- [9. Operasi Kontrol Alur](#9-operasi-kontrol-alur)
- [10. Operasi Guard dan Audit](#10-operasi-guard-dan-audit)
- [11. Operasi Memori](#11-operasi-memori)
- [12. Operasi Kriptografi](#12-operasi-kriptografi)
- [13. Operasi Sistem](#13-operasi-sistem)
- [14. Status Flags](#14-status-flags)
- [15. Model Memori](#15-model-memori)
- [16. Model Eksekusi](#16-model-eksekusi)
- [17. Encoding Biner](#17-encoding-biner)
- [18. Assembly Language](#18-assembly-language)
- [19. Contoh Program Assembly](#19-contoh-program-assembly)
- [20. Jalur Kompilasi HC → H-ISA](#20-jalur-kompilasi-hc--h-isa)
- [21. Hubungan dengan HCVM](#21-hubungan-dengan-hcvm)
- [22. Hubungan dengan HCPU](#22-hubungan-dengan-hcpu)
- [23. Batasan dan Rencana](#23-batasan-dan-rencana)
- [24. Referensi](#24-referensi)

---

## 1. Pendahuluan

### 1.1 Apa itu H-ISA?

**H-ISA** (*Hijaiyyah Instruction Set Architecture*) adalah arsitektur
instruksi formal yang dirancang untuk memproses operasi codex Hijaiyyah
pada level mesin. H-ISA menyediakan:

- model register,
- format instruction word,
- set opcode,
- model eksekusi,
- dan spesifikasi encoding biner.

H-ISA menempati posisi **L2** dalam Hijaiyyah Technology Stack
dan menjadi jembatan antara:
- **HC Language** (bahasa tingkat tinggi) di atasnya,
- dan **HCVM / HCPU** (mesin eksekusi) di bawahnya.

### 1.2 Mengapa H-ISA Diperlukan?

Matematika Hijaiyyah beroperasi pada vektor integer 18-dimensi
dengan operasi khusus (guard check, codex distance, turning
decomposition, dll.) yang tidak dimiliki oleh ISA konvensional
seperti x86, ARM, atau RISC-V.

H-ISA menyediakan instruksi native untuk operasi-operasi ini,
sehingga:
- operasi codex menjadi efisien,
- pipeline dari HC ke mesin menjadi jelas,
- dan target hardware (HCPU) memiliki spesifikasi yang tegas.

### 1.3 Posisi dalam Stack

```
HC Source Code (.hc)
      │
      ▼
HC Compiler
      │
      ▼
H-ISA Bytecode          ← spesifikasi ini
      │
      ├──► HCVM (software execution)
      └──► HCPU (hardware execution, masa depan)
```

### 1.4 Status

H-ISA v1.0 berstatus **OPERATIONAL** pada level emulator/VM.
Hardware-native execution masih berstatus **DESIGNED**.

---

## 2. Desain dan Prinsip

### 2.1 Prinsip Desain

| Prinsip | Penjelasan |
|---|---|
| **Fixed-width** | semua instruksi 32-bit |
| **Integer-only** | semua operasi pada $\mathbb{N}_0$ atau $\mathbb{Z}$ |
| **Codex-native** | instruksi khusus untuk vektor 18D |
| **Guard-aware** | instruksi verifikasi structural bawaan |
| **Deterministic** | hasil eksekusi selalu reprodusibel |
| **Simple decode** | field alignment tetap untuk decode cepat |

### 2.2 Perbandingan dengan ISA Konvensional

| Aspek | x86/ARM/RISC-V | H-ISA |
|---|---|---|
| Unit data utama | scalar integer/float | vektor integer 18D |
| Register utama | 16–32 GPR | 18 GPR + 4 Codex Reg |
| Operasi khusus | SIMD, FPU | CLOAD, VCHK, VDIST |
| Guard hardware | tidak ada | bawaan (VCHK) |
| Instruction width | 16/32/variable | 32-bit fixed |
| Domain target | komputasi umum | komputasi codex |

### 2.3 Filosofi

H-ISA tidak berusaha menggantikan ISA umum. H-ISA dirancang
sebagai **co-processor ISA** atau **domain-specific ISA** yang:
- dapat dijalankan oleh VM (HCVM),
- dapat diimplementasikan sebagai accelerator (HCPU),
- atau dapat menjadi target kompilasi dari HC.

---

## 3. Model Mesin

### 3.1 Diagram Abstrak

```
┌─────────────────────────────────────────────┐
│                 H-ISA Machine               │
│                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ GPR      │  │ H-Reg    │  │ FLAGS    │  │
│  │ R0–R17   │  │ H0–H3   │  │ G Z O    │  │
│  └──────────┘  └──────────┘  └──────────┘  │
│                                             │
│  ┌──────────┐  ┌──────────┐                │
│  │ PC       │  │ SP       │                │
│  └──────────┘  └──────────┘                │
│                                             │
│  ┌──────────────────────────────────────┐   │
│  │ ROM: 252 bytes (Master Table)       │   │
│  └──────────────────────────────────────┘   │
│                                             │
│  ┌──────────────────────────────────────┐   │
│  │ RAM: data + stack                    │   │
│  └──────────────────────────────────────┘   │
│                                             │
│  ┌──────────────────────────────────────┐   │
│  │ ALU: integer + vector operations     │   │
│  └──────────────────────────────────────┘   │
│                                             │
└─────────────────────────────────────────────┘
```

### 3.2 Spesifikasi Mesin

| Parameter | Nilai |
|---|---|
| Word size | 32 bit |
| Instruction width | 32 bit (fixed) |
| GPR count | 18 (R0–R17) |
| Codex register count | 4 (H0–H3) |
| GPR width | 32 bit |
| Codex register width | 18 × 32 bit = 576 bit |
| Program counter | 32 bit |
| Stack pointer | 32 bit |
| Status register | 8 bit |
| ROM | 252 bytes (Master Table) |
| RAM | configurable |
| Endianness | big-endian (network byte order) |

---

## 4. Register File

### 4.1 General Purpose Registers (GPR)

| Register | Nama | Fungsi |
|---|---|---|
| R0 | `r0` | general purpose / zero convention |
| R1 | `r1` | general purpose |
| R2 | `r2` | general purpose |
| R3 | `r3` | general purpose |
| R4 | `r4` | general purpose |
| R5 | `r5` | general purpose |
| R6 | `r6` | general purpose |
| R7 | `r7` | general purpose |
| R8 | `r8` | general purpose |
| R9 | `r9` | general purpose |
| R10 | `r10` | general purpose |
| R11 | `r11` | general purpose |
| R12 | `r12` | general purpose |
| R13 | `r13` | general purpose |
| R14 | `r14` | general purpose |
| R15 | `r15` | general purpose |
| R16 | `r16` | general purpose |
| R17 | `r17` | general purpose |

**Catatan:** 18 GPR dipilih agar setiap komponen codex 18D
dapat dimuat ke register individual jika diperlukan.

### 4.2 Codex Registers (H-Reg)

| Register | Nama | Lebar | Fungsi |
|---|---|---|---|
| H0 | `h0` | 18 × 32 bit | codex register 0 |
| H1 | `h1` | 18 × 32 bit | codex register 1 |
| H2 | `h2` | 18 × 32 bit | codex register 2 |
| H3 | `h3` | 18 × 32 bit | codex register 3 |

Setiap H-Reg menyimpan satu vektor codex 18D lengkap.
Akses ke komponen individual dilakukan melalui instruksi
`CGET` dan `CSET`.

### 4.3 Special Registers

| Register | Nama | Lebar | Fungsi |
|---|---|---|---|
| PC | `pc` | 32 bit | Program Counter |
| SP | `sp` | 32 bit | Stack Pointer |
| FLAGS | `flags` | 8 bit | Status flags |
| CY | `cy` | 32 bit | Cycle counter |

### 4.4 Konvensi Register

| Register | Konvensi |
|---|---|
| R0 | return value / accumulator |
| R1–R5 | argument passing |
| R6–R15 | caller-saved temporaries |
| R16 | frame pointer (opsional) |
| R17 | link register (return address) |
| H0 | primary codex operand |
| H1 | secondary codex operand |
| H2 | codex result |
| H3 | codex temporary |

---

## 5. Format Instruction Word

### 5.1 Layout

Semua instruksi H-ISA berukuran **32 bit** dengan layout
tetap berikut:

```
31        24 23    20 19    16 15    12 11              0
┌──────────┬────────┬────────┬────────┬─────────────────┐
│   OP     │  DST   │  S1    │  S2    │      IMM        │
│  8 bit   │ 4 bit  │ 4 bit  │ 4 bit  │    12 bit       │
└──────────┴────────┴────────┴────────┴─────────────────┘
```

### 5.2 Field Definitions

| Field | Bits | Range | Fungsi |
|---|---|---|---|
| **OP** | 31–24 | 0x00–0xFF | Opcode (256 kemungkinan) |
| **DST** | 23–20 | 0x0–0xF | Destination register |
| **S1** | 19–16 | 0x0–0xF | Source register 1 |
| **S2** | 15–12 | 0x0–0xF | Source register 2 |
| **IMM** | 11–0 | 0x000–0xFFF | Immediate value (12-bit unsigned) |

### 5.3 Encoding Modes

#### R-Type (Register-Register)

```
OP  DST  S1   S2   IMM(unused)
```

Contoh: `ADD R3, R1, R2`

#### I-Type (Register-Immediate)

```
OP  DST  S1   _(0)  IMM
```

Contoh: `ADDI R3, R1, #42`

#### C-Type (Codex Operation)

```
OP  DST(H-reg)  S1(H-reg)  S2(H-reg/GPR)  IMM
```

Contoh: `CADD H2, H0, H1`

#### J-Type (Jump)

```
OP  _(0)  _(0)  _(0)  IMM(target)
```

Contoh: `JMP #0x100`

#### B-Type (Branch)

```
OP  _(0)  S1   _(0)  IMM(offset)
```

Contoh: `BEQ R1, #offset`

### 5.4 Extraction dari Hex

Untuk instruction word `0x1234ABCD`:

```
Binary: 0001 0010 0011 0100 1010 1011 1100 1101
OP:     0x12  = 18
DST:    0x3   = 3
S1:     0x4   = 4
S2:     0xA   = 10
IMM:    0xBCD = 3021
```

---

## 6. Opcode Map

### 6.1 Opcode Ranges

| Range | Kategori | Jumlah |
|---|---|---|
| 0x00–0x0F | System & Control | 16 |
| 0x10–0x1F | Arithmetic & Logic | 16 |
| 0x20–0x2F | Comparison & Branch | 16 |
| 0x30–0x3F | Memory | 16 |
| 0x40–0x5F | Codex Operations | 32 |
| 0x60–0x6F | Guard & Audit | 16 |
| 0x70–0x7F | Crypto | 16 |
| 0x80–0x8F | Vector Math | 16 |
| 0x90–0x9F | String Operations | 16 |
| 0xA0–0xAF | I/O & Debug | 16 |
| 0xB0–0xFF | Reserved | 80 |

### 6.2 Complete Opcode Table

#### System & Control (0x00–0x0F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x00 | `NOP` | — | No operation |
| 0x01 | `HALT` | — | Stop execution |
| 0x02 | `RESET` | — | Reset machine state |
| 0x03 | `MOV` | R | `DST ← S1` |
| 0x04 | `MOVI` | I | `DST ← IMM` |
| 0x05 | `PUSH` | R | Push S1 to stack |
| 0x06 | `POP` | R | Pop to DST |
| 0x07 | `CALL` | J | Call subroutine at IMM |
| 0x08 | `RET` | — | Return from subroutine |
| 0x09 | `SYSCALL` | I | System call IMM |
| 0x0A–0x0F | — | — | Reserved |

#### Arithmetic & Logic (0x10–0x1F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x10 | `ADD` | R | `DST ← S1 + S2` |
| 0x11 | `ADDI` | I | `DST ← S1 + IMM` |
| 0x12 | `SUB` | R | `DST ← S1 - S2` |
| 0x13 | `SUBI` | I | `DST ← S1 - IMM` |
| 0x14 | `MUL` | R | `DST ← S1 × S2` |
| 0x15 | `DIV` | R | `DST ← S1 / S2` |
| 0x16 | `MOD` | R | `DST ← S1 % S2` |
| 0x17 | `AND` | R | `DST ← S1 & S2` |
| 0x18 | `OR` | R | `DST ← S1 \| S2` |
| 0x19 | `XOR` | R | `DST ← S1 ^ S2` |
| 0x1A | `NOT` | R | `DST ← ~S1` |
| 0x1B | `SHL` | R | `DST ← S1 << S2` |
| 0x1C | `SHR` | R | `DST ← S1 >> S2` |
| 0x1D | `NEG` | R | `DST ← -S1` |
| 0x1E | `ABS` | R | `DST ← \|S1\|` |
| 0x1F | `SQR` | R | `DST ← S1 × S1` |

#### Comparison & Branch (0x20–0x2F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x20 | `CMP` | R | Compare S1, S2 → set FLAGS |
| 0x21 | `CMPI` | I | Compare S1, IMM → set FLAGS |
| 0x22 | `JMP` | J | Jump to IMM |
| 0x23 | `JEQ` | B | Jump if equal (Z=1) |
| 0x24 | `JNE` | B | Jump if not equal (Z=0) |
| 0x25 | `JLT` | B | Jump if less than |
| 0x26 | `JGT` | B | Jump if greater than |
| 0x27 | `JLE` | B | Jump if less or equal |
| 0x28 | `JGE` | B | Jump if greater or equal |
| 0x29 | `JGD` | B | Jump if GUARD flag set |
| 0x2A | `JNGD` | B | Jump if GUARD flag not set |
| 0x2B–0x2F | — | — | Reserved |

#### Memory (0x30–0x3F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x30 | `LOAD` | I | `DST ← MEM[S1 + IMM]` |
| 0x31 | `STORE` | I | `MEM[S1 + IMM] ← S2` |
| 0x32 | `LOADR` | R | `DST ← ROM[S1]` |
| 0x33 | `LEA` | I | `DST ← address(S1 + IMM)` |
| 0x34–0x3F | — | — | Reserved |

#### Codex Operations (0x40–0x5F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x40 | `CLOAD` | C | Load codex dari ROM ke H-Reg: `H[DST] ← ROM[IMM]` |
| 0x41 | `CSTORE` | C | Store H-Reg ke memori |
| 0x42 | `CADD` | C | `H[DST] ← H[S1] + H[S2]` (vektor 18D) |
| 0x43 | `CSUB` | C | `H[DST] ← H[S1] - H[S2]` (delta 14D) |
| 0x44 | `CGET` | C | `GPR[DST] ← H[S1][IMM]` (ambil komponen) |
| 0x45 | `CSET` | C | `H[DST][IMM] ← GPR[S1]` (set komponen) |
| 0x46 | `CMOV` | C | `H[DST] ← H[S1]` (copy codex) |
| 0x47 | `CZERO` | C | `H[DST] ← 0` (zero codex) |
| 0x48 | `CEQ` | C | Compare H[S1] == H[S2] → FLAGS |
| 0x49 | `CDOT` | C | `GPR[DST] ← ⟨H[S1], H[S2]⟩₁₄` (inner product) |
| 0x4A | `CNORM` | C | `GPR[DST] ← ‖H[S1]‖²₁₄` (norm squared) |
| 0x4B | `CDIST` | C | `GPR[DST] ← ‖H[S1] - H[S2]‖²₁₄` (distance sq) |
| 0x4C | `CRHO` | C | `GPR[DST] ← ρ(H[S1])` (residu turning) |
| 0x4D | `CU` | C | `GPR[DST] ← U(H[S1])` (turning budget) |
| 0x4E | `CTHETA` | C | `GPR[DST] ← Θ̂(H[S1])` (extract theta) |
| 0x4F | `CMOD4` | C | `GPR[DST] ← Θ̂(H[S1]) mod 4` |
| 0x50 | `CAN` | C | `GPR[DST] ← A_N(H[S1])` |
| 0x51 | `CAK` | C | `GPR[DST] ← A_K(H[S1])` |
| 0x52 | `CAQ` | C | `GPR[DST] ← A_Q(H[S1])` |
| 0x53 | `CPHI` | C | `GPR[DST] ← Φ(H[S1])` (Frobenius energy) |
| 0x54 | `CIDENT` | C | `GPR[DST] ← identify(H[S1])` (huruf index) |
| 0x55–0x5F | — | — | Reserved for future codex ops |

#### Guard & Audit (0x60–0x6F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x60 | `VCHK` | C | Guard check H[S1] → set GUARD flag |
| 0x61 | `VCHK1` | C | Check G1 only: ρ ≥ 0 |
| 0x62 | `VCHK2` | C | Check G2 only: A_N = ΣN |
| 0x63 | `VCHK3` | C | Check G3 only: A_K = ΣK |
| 0x64 | `VCHK4` | C | Check G4 only: A_Q = ΣQ |
| 0x65 | `VAUDIT` | C | Full R1–R5 audit → GPR[DST] |
| 0x66 | `VINJ` | C | Check if H[S1] is in valid codex set |
| 0x67 | `VTOPO` | C | Check topology guards (Ks→Qc, Kc→Qc) |
| 0x68–0x6F | — | — | Reserved |

#### Crypto (0x70–0x7F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x70 | `CHASH` | C | `GPR[DST] ← hash(H[S1])` (truncated) |
| 0x71 | `CSEAL` | C | `GPR[DST] ← seal(ROM)` (dataset hash) |
| 0x72 | `CSIGN` | C | Sign H[S1] with key IMM |
| 0x73 | `CVRFY` | C | Verify signature on H[S1] |
| 0x74–0x7F | — | — | Reserved |

#### Vector Math (0x80–0x8F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x80 | `VPROJ` | C | Project H[S1] to layer IMM → H[DST] |
| 0x81 | `VSUM` | C | `GPR[DST] ← Σ H[S1][0..17]` |
| 0x82 | `VMAX` | C | `GPR[DST] ← max(H[S1])` |
| 0x83 | `VMIN` | C | `GPR[DST] ← min(H[S1])` |
| 0x84 | `VCOSINE` | C | `GPR[DST] ← cosine(H[S1], H[S2])` (fixed-point) |
| 0x85 | `VMAN` | C | `GPR[DST] ← manhattan(H[S1], H[S2])` |
| 0x86 | `VHAM` | C | `GPR[DST] ← hamming(H[S1], H[S2])` |
| 0x87–0x8F | — | — | Reserved |

#### String Operations (0x90–0x9F)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0x90 | `SAGG` | C | Aggregate string → H[DST] |
| 0x91 | `SLEN` | I | `GPR[DST] ← string length` |
| 0x92 | `SCHR` | I | `GPR[DST] ← char at position IMM` |
| 0x93–0x9F | — | — | Reserved |

#### I/O & Debug (0xA0–0xAF)

| Opcode | Mnemonic | Format | Deskripsi |
|---|---|---|---|
| 0xA0 | `EMIT` | R | Print GPR[S1] |
| 0xA1 | `EMITC` | C | Print codex H[S1] |
| 0xA2 | `EMITS` | I | Print string at address IMM |
| 0xA3 | `DUMP` | — | Dump machine state |
| 0xA4 | `TRACE` | I | Enable/disable trace (IMM=0/1) |
| 0xA5 | `BREAK` | — | Breakpoint |
| 0xA6–0xAF | — | — | Reserved |

---

## 7. Operasi Codex Inti

### 7.1 `CLOAD` — Load Codex dari ROM

```
CLOAD H0, #5      ; H0 ← codex huruf index 5 (Jim)
```

**Operasi:**
1. Baca index dari IMM (1–28).
2. Lookup Master Table ROM di offset yang sesuai.
3. Unpack 18 komponen integer dari ROM.
4. Simpan ke H-Reg tujuan.

**Kompleksitas:** O(1)

### 7.2 `CADD` — Codex Addition

```
CADD H2, H0, H1   ; H2 ← H0 + H1 (component-wise, 18D)
```

**Operasi:**

$$
H[\text{DST}][k] = H[\text{S1}][k] + H[\text{S2}][k], \quad k = 0, \ldots, 17
$$

**Catatan:** Ini adalah operasi fundamental untuk string integral:

$$
\mathrm{Cod}_{18}(w) = \sum_{i=1}^{n} v_{18}(x_i)
$$

**Kompleksitas:** O(18) = O(1) (18 parallel ADD)

### 7.3 `VCHK` — Guard Check

```
VCHK H0            ; check guard G1–G4 on H0 → set GUARD flag
```

**Operasi:**
1. Hitung $U = H[S1][10] + H[S1][11] + H[S1][12] + 4 \times H[S1][13]$.
2. Hitung $\rho = H[S1][0] - U$.
3. Periksa $\rho \geq 0$.
4. Periksa $H[S1][14] = H[S1][1] + H[S1][2] + H[S1][3]$.
5. Periksa $H[S1][15] = H[S1][4] + \ldots + H[S1][8]$.
6. Periksa $H[S1][16] = H[S1][9] + \ldots + H[S1][13]$.
7. Set GUARD flag = 1 jika semua lulus, 0 jika gagal.

**Kompleksitas:** O(1) (4 pemeriksaan, beberapa penjumlahan)

### 7.4 `CDIST` — Codex Distance Squared

```
CDIST R0, H0, H1   ; R0 ← Σ(H0[k] - H1[k])² untuk k=0..13
```

**Operasi:**

$$
\text{GPR}[\text{DST}] = \sum_{k=0}^{13} \big(H[\text{S1}][k] - H[\text{S2}][k]\big)^2
$$

**Catatan:** Hanya 14 komponen pertama (codex14) yang dipakai
untuk jarak Euclidean.

**Kompleksitas:** O(14) = O(1)

### 7.5 `CRHO` — Compute Residue

```
CRHO R0, H0        ; R0 ← Θ̂(H0) - U(H0)
```

**Operasi:**

$$
U = H[S1][10] + H[S1][11] + H[S1][12] + 4 \times H[S1][13]
$$

$$
\text{GPR}[\text{DST}] = H[S1][0] - U
$$

### 7.6 `CPHI` — Frobenius Energy

```
CPHI R0, H0        ; R0 ← Φ(H0)
```

**Operasi:** Bangun Exomatrix dari H[S1], lalu hitung
$\Phi = \sum_{r,c} E_{r,c}^2$.

**Kompleksitas:** O(25) = O(1)

---

## 8. Operasi Aritmetika dan Logika

### 8.1 Integer Arithmetic

```
ADD  R3, R1, R2    ; R3 ← R1 + R2
ADDI R3, R1, #10   ; R3 ← R1 + 10
SUB  R3, R1, R2    ; R3 ← R1 - R2
MUL  R3, R1, R2    ; R3 ← R1 × R2
DIV  R3, R1, R2    ; R3 ← R1 / R2
MOD  R3, R1, R2    ; R3 ← R1 % R2
```

### 8.2 Bitwise Operations

```
AND  R3, R1, R2    ; R3 ← R1 & R2
OR   R3, R1, R2    ; R3 ← R1 | R2
XOR  R3, R1, R2    ; R3 ← R1 ^ R2
NOT  R3, R1        ; R3 ← ~R1
SHL  R3, R1, R2    ; R3 ← R1 << R2
SHR  R3, R1, R2    ; R3 ← R1 >> R2
```

---

## 9. Operasi Kontrol Alur

### 9.1 Jump

```
JMP  #0x100        ; PC ← 0x100
```

### 9.2 Conditional Branch

```
CMP  R1, R2        ; set flags
JEQ  #offset       ; jump if R1 == R2
JNE  #offset       ; jump if R1 != R2
JLT  #offset       ; jump if R1 < R2
JGT  #offset       ; jump if R1 > R2
```

### 9.3 Guard-Conditional Branch

```
VCHK H0            ; check guard → set GUARD flag
JGD  #ok_label     ; jump if GUARD = 1 (valid)
JNGD #fail_label   ; jump if GUARD = 0 (invalid)
```

### 9.4 Subroutine

```
CALL #sub_addr     ; push PC+1, jump to sub_addr
RET                ; pop PC, return
```

---

## 10. Operasi Guard dan Audit

### 10.1 Guard Check Penuh

```
VCHK H0            ; G1–G4 check → GUARD flag
```

### 10.2 Guard Check Per Relasi

```
VCHK1 H0           ; G1 only: ρ ≥ 0
VCHK2 H0           ; G2 only: A_N check
VCHK3 H0           ; G3 only: A_K check
VCHK4 H0           ; G4 only: A_Q check
```

### 10.3 Full Audit

```
VAUDIT R0, H0      ; R1–R5 audit → R0 (bitmask)
```

R0 bitmask:
- bit 0: R1 (Θ̂ = U + ρ)
- bit 1: R2 (A_N = ΣN)
- bit 2: R3 (A_K = ΣK)
- bit 3: R4 (A_Q = ΣQ)
- bit 4: R5 (U = Qx+Qs+Qa+4Qc)

Jika R0 = 0x1F (semua bit set), audit lulus penuh.

### 10.4 Topology Guard

```
VTOPO R0, H0       ; topology guards → R0
```

R0:
- bit 0: Ks > 0 ⇒ Qc ≥ 1
- bit 1: Kc > 0 ⇒ Qc ≥ 1

---

## 11. Operasi Memori

### 11.1 Load dan Store

```
LOAD  R1, R2, #4   ; R1 ← MEM[R2 + 4]
STORE R2, R1, #4   ; MEM[R2 + 4] ← R1
```

### 11.2 ROM Access

```
LOADR R1, R2       ; R1 ← ROM[R2]
```

---

## 12. Operasi Kriptografi

### 12.1 Hash

```
CHASH R0, H0       ; R0 ← hash(H0) (32-bit truncated SHA-256)
```

### 12.2 Dataset Seal

```
CSEAL R0           ; R0 ← SHA-256(ROM) (32-bit truncated)
```

### 12.3 Sign dan Verify

```
CSIGN H0, #key_id  ; sign codex H0 with key_id
CVRFY H0, #key_id  ; verify signature → GUARD flag
```

---

## 13. Operasi Sistem

### 13.1 I/O

```
EMIT  R1           ; print integer R1
EMITC H0           ; print codex H0
EMITS #addr        ; print string at memory address
```

### 13.2 Debug

```
DUMP               ; dump full machine state
TRACE #1           ; enable trace
TRACE #0           ; disable trace
BREAK              ; breakpoint (untuk debugger)
```

### 13.3 System Call

```
SYSCALL #code      ; invoke system call
```

System call codes **[PLANNED]**:

| Code | Fungsi |
|---|---|
| 0 | exit |
| 1 | print string |
| 2 | read input |
| 3 | file open |
| 4 | file read |
| 5 | file write |

---

## 14. Status Flags

### 14.1 Flag Register Layout

```
7  6  5  4  3  2  1  0
┌──┬──┬──┬──┬──┬──┬──┬──┐
│  │  │  │  │  │ O│ Z│ G│
└──┴──┴──┴──┴──┴──┴──┴──┘
```

| Bit | Nama | Deskripsi |
|---|---|---|
| 0 | **G** (GUARD) | 1 jika guard check terakhir lulus |
| 1 | **Z** (ZERO) | 1 jika hasil operasi terakhir = 0 |
| 2 | **O** (OVERFLOW) | 1 jika overflow terdeteksi |
| 3–7 | — | Reserved |

### 14.2 Instruksi yang Mengubah Flags

| Flag | Diubah oleh |
|---|---|
| G | `VCHK`, `VCHK1–4`, `CVRFY` |
| Z | `CMP`, `CMPI`, `SUB`, `CEQ` |
| O | `ADD`, `MUL`, `ADDI` (jika overflow) |

### 14.3 Instruksi yang Membaca Flags

| Flag | Dibaca oleh |
|---|---|
| G | `JGD`, `JNGD` |
| Z | `JEQ`, `JNE` |
| O | (future overflow handler) |

---

## 15. Model Memori

### 15.1 Address Space

```
0x0000 ┌──────────────────┐
       │ ROM (252 bytes)  │  Master Table
0x00FC ├──────────────────┤
       │ Code segment     │  H-ISA bytecode
       ├──────────────────┤
       │ Data segment     │  Variables
       ├──────────────────┤
       │ Stack            │  Call stack (grows down)
       ├──────────────────┤
       │ Heap (optional)  │  Dynamic allocation
0xFFFF └──────────────────┘
```

### 15.2 ROM Layout

```
Offset  Size   Content
0x00    9      Codex huruf #1 (Alif): 9 nibble pairs
0x09    9      Codex huruf #2 (Ba)
...
0xF3    9      Codex huruf #28 (Ya)
Total: 252 bytes
```

### 15.3 Alignment

- GPR: 32-bit aligned
- H-Reg: 576-bit aligned (18 × 32)
- Memory access: 32-bit aligned
- Stack: 32-bit aligned

---

## 16. Model Eksekusi

### 16.1 Cycle

Setiap instruksi memerlukan minimal 1 cycle. Instruksi codex
yang melibatkan 18 komponen secara konseptual memerlukan
18 sub-operasi, tetapi pada hardware paralel ini dapat
dilakukan dalam 1 cycle.

### 16.2 Pipeline (Konseptual)

```
Fetch → Decode → Execute → Writeback
```

Untuk HCVM (software), pipeline disimulasikan secara sekuensial.
Untuk HCPU (hardware), pipeline dapat diimplementasikan
secara pipelined atau superscalar.

### 16.3 Execution Loop (HCVM)

```python
while not halted:
    instruction = fetch(PC)
    op, dst, s1, s2, imm = decode(instruction)
    execute(op, dst, s1, s2, imm)
    PC += 1
    cycle += 1
```

### 16.4 Interrupt Model **[PLANNED]**

H-ISA v1.0 tidak memiliki model interrupt. Eksekusi bersifat
run-to-completion atau halt.

---

## 17. Encoding Biner

### 17.1 Hex Representation

Setiap instruksi direpresentasikan sebagai 8 digit hex:

```
0x40000005   →   CLOAD H0, #5
0x42010000   →   CADD  H2, H0, H1
0x60000000   →   VCHK  H0
```

### 17.2 Binary File Format **[PLANNED]**

```
Header:
  4 bytes: magic number "HISA"
  4 bytes: version (0x00010000 = v1.0)
  4 bytes: code size (in words)
  4 bytes: data size (in bytes)

Code segment:
  N × 4 bytes: instruction words

Data segment:
  M bytes: initialized data
```

---

## 18. Assembly Language

### 18.1 Syntax

```asm
; comment
label:
    MNEMONIC  operand1, operand2, operand3
```

### 18.2 Operand Types

| Tipe | Syntax | Contoh |
|---|---|---|
| GPR | `R0`–`R17` | `R3` |
| H-Reg | `H0`–`H3` | `H0` |
| Immediate | `#value` | `#42`, `#0xFF` |
| Label | `name` | `loop:` |

### 18.3 Directives **[PLANNED]**

```asm
.org 0x100       ; set origin
.data            ; switch to data segment
.word 42         ; emit 32-bit word
.string "hello"  ; emit string
```

---

## 19. Contoh Program Assembly

### 19.1 Load dan Print Codex

```asm
; Load huruf Ba dan print codex-nya
start:
    CLOAD  H0, #2        ; H0 ← codex Ba
    EMITC  H0            ; print codex
    HALT
```

### 19.2 Guard Check

```asm
; Load huruf Jim, check guard, branch accordingly
start:
    CLOAD  H0, #5        ; H0 ← codex Jim
    VCHK   H0            ; check guard → GUARD flag
    JGD    #valid         ; jump if valid
    MOVI   R0, #0         ; R0 ← 0 (invalid)
    EMIT   R0
    HALT

valid:
    MOVI   R0, #1         ; R0 ← 1 (valid)
    EMIT   R0
    HALT
```

### 19.3 String Integral (Manual)

```asm
; Compute codex("بسم") = codex(Ba) + codex(Sin) + codex(Mim)
start:
    CZERO  H2            ; H2 ← zero
    CLOAD  H0, #2        ; H0 ← Ba
    CADD   H2, H2, H0    ; H2 += Ba
    CLOAD  H0, #12       ; H0 ← Sin
    CADD   H2, H2, H0    ; H2 += Sin
    CLOAD  H0, #24       ; H0 ← Mim
    CADD   H2, H2, H0    ; H2 += Mim
    EMITC  H2            ; print result
    VCHK   H2            ; guard check
    JGD    #ok
    MOVI   R0, #0
    EMIT   R0
    HALT
ok:
    MOVI   R0, #1
    EMIT   R0
    CRHO   R1, H2        ; R1 ← rho
    EMIT   R1
    HALT
```

### 19.4 Distance Computation

```asm
; Compute distance² antara Alif dan Haa
start:
    CLOAD  H0, #1        ; H0 ← Alif
    CLOAD  H1, #27       ; H1 ← Haa
    CDIST  R0, H0, H1    ; R0 ← ‖H0 - H1‖²₁₄
    EMIT   R0            ; print 70
    HALT
```

### 19.5 Full Audit

```asm
; Audit semua 28 huruf
start:
    MOVI   R1, #1         ; counter = 1
loop:
    CMPI   R1, #29
    JEQ    #done
    CLOAD  H0, R1         ; H0 ← codex[R1]
    VCHK   H0
    JNGD   #fail
    ADDI   R1, R1, #1
    JMP    #loop
fail:
    EMIT   R1             ; print failing index
    HALT
done:
    MOVI   R0, #28
    EMIT   R0             ; print 28 (all passed)
    HALT
```

---

## 20. Jalur Kompilasi HC → H-ISA

### 20.1 Pipeline

```
HC Source (.hc)
     │
     ▼
HC Lexer → Token Stream
     │
     ▼
HC Parser → AST
     │
     ▼
HC Compiler → H-ISA Assembly
     │
     ▼
H-ISA Assembler → Bytecode
     │
     ▼
HCVM / HCPU
```

### 20.2 Contoh Kompilasi

#### HC Source

```hc
let h = load('ب');
println(h.theta());
```

#### H-ISA Assembly Output

```asm
    CLOAD  H0, #2        ; load('ب')
    CTHETA R0, H0        ; h.theta()
    EMIT   R0            ; println(...)
    HALT
```

### 20.3 Status Compiler

HC → H-ISA compiler berstatus **awal**:
- subset operasi dasar sudah dapat dikompilasi,
- kontrol alur kompleks belum sepenuhnya didukung,
- optimasi belum diimplementasikan.

---

## 21. Hubungan dengan HCVM

HCVM (Hijaiyyah Codex Virtual Machine) adalah **implementasi
software** dari H-ISA.

| Aspek | H-ISA | HCVM |
|---|---|---|
| Tipe | Spesifikasi | Implementasi |
| Level | Arsitektur instruksi | Runtime software |
| Fungsi | Mendefinisikan instruksi | Mengeksekusi instruksi |
| Status | OPERATIONAL (spec) | OPERATIONAL (runtime) |

HCVM mengimplementasikan:
- fetch/decode/execute loop,
- register file (GPR + H-Reg),
- flag management,
- memory model,
- dan I/O primitives.

---

## 22. Hubungan dengan HCPU

HCPU (Hijaiyyah Core Processing Unit) adalah **target hardware**
dari H-ISA.

| Aspek | H-ISA | HCPU |
|---|---|---|
| Tipe | Spesifikasi | Hardware target |
| Level | Arsitektur instruksi | Prosesor fisik |
| Fungsi | Mendefinisikan ISA | Mengeksekusi ISA secara native |
| Status | OPERATIONAL (spec) | DESIGNED |

### 22.1 Jalur Realisasi

```
H-ISA Spec
     │
     ├──► HCVM (software, sekarang)
     │
     └──► HCPU
           ├── Fase 1: Softcore FPGA
           └── Fase 2: ASIC (jangka panjang)
```

### 22.2 Fitur HCPU Target

| Fitur | Deskripsi |
|---|---|
| 18-wide ALU | 18 integer operations per cycle |
| Onboard ROM | 252 bytes Master Table |
| Guard unit | Hardware guard checker |
| Codex register file | 4 × 576-bit H-Reg |
| Fixed 32-bit decode | Simple instruction decoder |

---

## 23. Batasan dan Rencana

### 23.1 Batasan v1.0

| Batasan | Penjelasan |
|---|---|
| Tidak ada interrupt | run-to-completion saja |
| Tidak ada MMU | flat address space |
| Tidak ada floating-point | integer only |
| Tidak ada virtual memory | direct mapping |
| Immediate hanya 12-bit | max value 4095 |
| Belum ada debug protocol | DUMP/TRACE saja |
| Compiler HC belum lengkap | subset operasi |

### 23.2 Rencana v1.1 **[PLANNED]**

```
□ Extended immediate (24-bit mode)
□ Interrupt model
□ Debug protocol
□ Memory-mapped I/O
□ Profiling counters
```

### 23.3 Rencana v2.0 **[PLANNED]**

```
□ SIMD-style codex operations (batch processing)
□ Multi-core codex pipeline
□ Virtual memory
□ Hardware guard acceleration
□ DMA for codex streaming
```

---

## 24. Referensi

| Referensi | Deskripsi |
|---|---|
| Bab I | Fondasi Formal Matematika Hijaiyyah |
| Bab II | Lima Bidang Matematika Hijaiyyah |
| Bab IV | Hijaiyyah Technology Stack v1.0 |
| `docs/architecture.md` | Arsitektur HOM |
| `docs/hc_language.md` | Spesifikasi HC Language |
| `docs/hcvm_spec.md` | Spesifikasi HCVM |
| `src/hijaiyyah/hisa/` | Implementasi H-ISA |

---

<div align="center">

**H-ISA — Hijaiyyah Instruction Set Architecture**

*Version 1.0 · HM-28-v1.0-HC18D · 2026*

© 2026 Hijaiyyah Mathematics Computational Laboratory (HMCL)

</div>
