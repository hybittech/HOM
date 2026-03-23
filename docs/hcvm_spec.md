<div align="center">

# **HCVM Specification**
## Hijaiyyah Codex Virtual Machine — Version 1.0

### Runtime Execution Environment for H-ISA and HC Programs

**HM-28-v1.0-HC18D · 2026**

</div>

---

## Daftar Isi

- [1. Pendahuluan](#1-pendahuluan)
- [2. Desain dan Prinsip](#2-desain-dan-prinsip)
- [3. Arsitektur HCVM](#3-arsitektur-hcvm)
- [4. Machine State](#4-machine-state)
- [5. Execution Model](#5-execution-model)
- [6. Instruction Dispatch](#6-instruction-dispatch)
- [7. Built-in Commands](#7-built-in-commands)
- [8. Standard Library Bridge](#8-standard-library-bridge)
- [9. Memory Model](#9-memory-model)
- [10. I/O Model](#10-io-model)
- [11. Guard Engine](#11-guard-engine)
- [12. Script Engine](#12-script-engine)
- [13. Bytecode Mode](#13-bytecode-mode)
- [14. Sandbox dan Keamanan](#14-sandbox-dan-keamanan)
- [15. Integrasi dengan HOM](#15-integrasi-dengan-hom)
- [16. Integrasi dengan HC Compiler](#16-integrasi-dengan-hc-compiler)
- [17. Diagnostik dan Debug](#17-diagnostik-dan-debug)
- [18. Performa dan Benchmark](#18-performa-dan-benchmark)
- [19. API Referensi](#19-api-referensi)
- [20. Contoh Eksekusi](#20-contoh-eksekusi)
- [21. Batasan dan Rencana](#21-batasan-dan-rencana)
- [22. Referensi](#22-referensi)

---

## 1. Pendahuluan

### 1.1 Apa itu HCVM?

**HCVM** (*Hijaiyyah Codex Virtual Machine*) adalah mesin virtual
mandiri yang mengeksekusi program codex Hijaiyyah. HCVM mendukung
dua mode eksekusi:

1. **Script mode** — menjalankan program HC/HL-18E dari source text,
2. **Bytecode mode** — menjalankan H-ISA bytecode yang sudah dikompilasi.

HCVM menempati posisi **L5** dalam Hijaiyyah Technology Stack dan
berfungsi sebagai:
- runtime utama untuk bahasa HC,
- emulator referensi untuk H-ISA,
- dan lingkungan eksekusi mandiri yang dapat berjalan tanpa GUI.

### 1.2 Mengapa HCVM Diperlukan?

Tanpa mesin virtual, program HC hanya bisa dijalankan melalui
evaluator Python yang embedded di HOM. HCVM memisahkan
runtime dari GUI sehingga:
- program dapat dijalankan headless,
- pengujian dapat dilakukan tanpa antarmuka grafis,
- dan mesin menjadi portabel ke platform lain.

### 1.3 Posisi dalam Stack

```
HC Source Code (.hc)
      │
      ├─── [Script mode] ──► HCVM Script Engine
      │                           │
      │                           ▼
      │                      Lexer → Parser → Evaluator
      │
      └─── [Bytecode mode] ► HC Compiler
                                  │
                                  ▼
                             H-ISA Bytecode
                                  │
                                  ▼
                             HCVM Bytecode Engine
                                  │
                                  ▼
                              Execution
```

### 1.4 File Utama

| File | Lokasi | Fungsi |
|---|---|---|
| `hcvm.py` | root repo | standalone VM runner |
| `src/hijaiyyah/gui/tabs/hcvm.py` | GUI | HCVM tab integration |

### 1.5 Status

**OPERATIONAL** — HCVM dapat dijalankan secara mandiri
dan melalui GUI HOM.

---

## 2. Desain dan Prinsip

### 2.1 Prinsip Desain

| Prinsip | Penjelasan |
|---|---|
| **Standalone** | dapat berjalan tanpa GUI/HOM |
| **Deterministic** | hasil eksekusi selalu sama dari input sama |
| **Integer-only core** | codex operations pada $\mathbb{N}_0$ |
| **Guard-aware** | validasi struktural terintegrasi |
| **Dual-mode** | script mode + bytecode mode |
| **Auditable** | trace dan dump tersedia |
| **Portable** | pure Python, minimal dependency |

### 2.2 Perbandingan dengan VM Lain

| Aspek | JVM | CPython VM | WASM | HCVM |
|---|---|---|---|---|
| Unit data utama | object | object | i32/i64 | hybit (18D) |
| Tipe sistem | class-based | dynamic | static | codex-typed |
| Guard bawaan | tidak | tidak | tidak | ya |
| Domain | umum | umum | umum | codex |
| Instruction set | JVM bytecode | CPython bytecode | WASM opcodes | H-ISA |
| Stack model | operand stack | operand stack | operand stack | register |

### 2.3 Apa yang HCVM Bukan

HCVM **bukan**:
- general-purpose VM (tidak mendukung threading, networking native, dll.),
- pengganti CPython atau JVM,
- sandbox yang sudah hardened untuk production.

HCVM **adalah**:
- reference implementation dari H-ISA,
- runtime khusus untuk komputasi codex Hijaiyyah,
- platform pengujian dan eksperimen.

---

## 3. Arsitektur HCVM

### 3.1 Diagram Arsitektur

```
┌─────────────────────────────────────────────────────┐
│                      HCVM                            │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │              Input Layer                       │  │
│  │                                                │  │
│  │  ┌──────────────┐    ┌──────────────────────┐  │  │
│  │  │ Script Input │    │ Bytecode Input       │  │  │
│  │  │ (.hc / REPL) │    │ (.hisa / .hcb)       │  │  │
│  │  └──────┬───────┘    └──────────┬───────────┘  │  │
│  │         │                       │              │  │
│  └─────────┼───────────────────────┼──────────────┘  │
│            │                       │                 │
│  ┌─────────▼───────────────────────▼──────────────┐  │
│  │              Execution Core                    │  │
│  │                                                │  │
│  │  ┌──────────────┐    ┌──────────────────────┐  │  │
│  │  │ Script       │    │ Bytecode             │  │  │
│  │  │ Engine       │    │ Engine               │  │  │
│  │  │              │    │                      │  │  │
│  │  │ Lexer        │    │ Fetch                │  │  │
│  │  │ Parser       │    │ Decode               │  │  │
│  │  │ Evaluator    │    │ Execute              │  │  │
│  │  └──────────────┘    └──────────────────────┘  │  │
│  │                                                │  │
│  └────────────────────────┬───────────────────────┘  │
│                           │                          │
│  ┌────────────────────────▼───────────────────────┐  │
│  │              Machine State                     │  │
│  │                                                │  │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐  │  │
│  │  │ GPR    │ │ H-Reg  │ │ FLAGS  │ │ PC/SP  │  │  │
│  │  │ R0–R17 │ │ H0–H3  │ │ G Z O  │ │        │  │  │
│  │  └────────┘ └────────┘ └────────┘ └────────┘  │  │
│  │                                                │  │
│  │  ┌──────────────────┐  ┌────────────────────┐  │  │
│  │  │ ROM (252 bytes)  │  │ RAM (configurable) │  │  │
│  │  └──────────────────┘  └────────────────────┘  │  │
│  │                                                │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │              Support Systems                   │  │
│  │                                                │  │
│  │  ┌─────────┐ ┌──────────┐ ┌─────────────────┐ │  │
│  │  │ Guard   │ │ Built-in │ │ Standard Library│ │  │
│  │  │ Engine  │ │ Commands │ │ Bridge (hm::*)  │ │  │
│  │  └─────────┘ └──────────┘ └─────────────────┘ │  │
│  │                                                │  │
│  │  ┌─────────┐ ┌──────────┐ ┌─────────────────┐ │  │
│  │  │ I/O     │ │ Trace    │ │ Sandbox         │ │  │
│  │  │ Handler │ │ Logger   │ │ Policy          │ │  │
│  │  └─────────┘ └──────────┘ └─────────────────┘ │  │
│  │                                                │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### 3.2 Komponen Utama

| Komponen | Fungsi |
|---|---|
| **Script Engine** | Lexer + Parser + Evaluator untuk HC/HL-18E source |
| **Bytecode Engine** | Fetch + Decode + Execute untuk H-ISA bytecode |
| **Machine State** | Register file, ROM, RAM, flags |
| **Guard Engine** | Validasi structural G1–G4 |
| **Built-in Commands** | EMIT, AGGREGATE, COD18, VERIFY, SEAL, dll. |
| **Standard Library Bridge** | Akses ke hm::vectronometry, dll. |
| **I/O Handler** | Output ke console / GUI |
| **Trace Logger** | Logging eksekusi untuk debug |
| **Sandbox Policy** | Batasan keamanan eksekusi |

---

## 4. Machine State

### 4.1 Register State

Seluruh register state HCVM identik dengan spesifikasi H-ISA:

```python
class MachineState:
    gpr: List[int]          # R0–R17 (18 × 32-bit)
    hreg: List[List[int]]   # H0–H3 (4 × 18-int vector)
    pc: int                 # Program Counter
    sp: int                 # Stack Pointer
    flags: int              # Status flags (8-bit)
    cycle: int              # Cycle counter
    halted: bool            # Halt state
```

### 4.2 Inisialisasi

Saat HCVM diinisialisasi:

```
GPR[0..17]  ← 0
H-Reg[0..3] ← [0] × 18
PC          ← 0
SP          ← RAM_SIZE - 1
FLAGS       ← 0x00
cycle       ← 0
halted      ← false
ROM         ← load Master Table (252 bytes)
RAM         ← zeroed
```

### 4.3 State Dump

HCVM menyediakan method `dump_state()` yang mengembalikan
snapshot lengkap:

```python
{
    "pc": 0,
    "sp": 4095,
    "flags": {"GUARD": false, "ZERO": false, "OVERFLOW": false},
    "cycle": 0,
    "halted": false,
    "gpr": [0, 0, 0, ...],  # 18 values
    "hreg": [
        [0, 0, 0, ...],     # H0: 18 values
        [0, 0, 0, ...],     # H1: 18 values
        [0, 0, 0, ...],     # H2: 18 values
        [0, 0, 0, ...],     # H3: 18 values
    ],
    "rom_sha256": "f82d3859...",
}
```

---

## 5. Execution Model

### 5.1 Dual-Mode Execution

HCVM mendukung dua mode eksekusi yang terpisah namun
menggunakan machine state yang sama.

#### Mode 1 — Script Execution

```
Source text (HC/HL-18E)
    │
    ▼
HCVM Script Engine
    │
    ├── Lexer → token stream
    ├── Parser → AST
    └── Evaluator → result
```

Dalam mode ini, HCVM bertindak sebagai **interpreter**.

#### Mode 2 — Bytecode Execution

```
H-ISA bytecode
    │
    ▼
HCVM Bytecode Engine
    │
    ├── Fetch instruction word
    ├── Decode (OP, DST, S1, S2, IMM)
    └── Execute → update state
```

Dalam mode ini, HCVM bertindak sebagai **emulator H-ISA**.

### 5.2 Execution Loop (Bytecode Mode)

```python
def run(self):
    while not self.state.halted:
        # Fetch
        word = self.memory.fetch(self.state.pc)

        # Decode
        op  = (word >> 24) & 0xFF
        dst = (word >> 20) & 0x0F
        s1  = (word >> 16) & 0x0F
        s2  = (word >> 12) & 0x0F
        imm = word & 0x0FFF

        # Execute
        self.dispatch(op, dst, s1, s2, imm)

        # Advance
        if not self.state.halted:
            self.state.pc += 1
            self.state.cycle += 1
```

### 5.3 Execution Loop (Script Mode)

```python
def run_script(self, source: str):
    tokens = Lexer(source).tokenize()
    ast = Parser(tokens).parse()
    self.evaluator.evaluate(ast)
```

### 5.4 Termination Conditions

HCVM berhenti ketika:
1. instruksi `HALT` dieksekusi,
2. PC melampaui batas kode,
3. error runtime yang tidak tertangkap,
4. atau cycle limit tercapai (jika ditetapkan).

---

## 6. Instruction Dispatch

### 6.1 Dispatch Table

HCVM menggunakan dispatch table untuk memetakan opcode
ke handler:

```python
self.dispatch_table = {
    0x00: self._nop,
    0x01: self._halt,
    0x03: self._mov,
    0x04: self._movi,
    0x10: self._add,
    0x11: self._addi,
    0x12: self._sub,
    0x20: self._cmp,
    0x22: self._jmp,
    0x23: self._jeq,
    0x40: self._cload,
    0x42: self._cadd,
    0x44: self._cget,
    0x4B: self._cdist,
    0x4C: self._crho,
    0x4E: self._ctheta,
    0x53: self._cphi,
    0x60: self._vchk,
    0x65: self._vaudit,
    0x70: self._chash,
    0x71: self._cseal,
    0xA0: self._emit,
    0xA1: self._emitc,
    0xA3: self._dump,
    # ... dst
}
```

### 6.2 Handler Signature

Setiap handler menerima parameter hasil decode:

```python
def _cload(self, dst: int, s1: int, s2: int, imm: int):
    """CLOAD H[dst], #imm — load codex dari ROM."""
    index = imm
    if 1 <= index <= 28:
        entry = self.master_table.get_by_index(index)
        if entry:
            self.state.hreg[dst] = list(entry.vector)
```

### 6.3 Unknown Opcode Handling

```python
def dispatch(self, op, dst, s1, s2, imm):
    handler = self.dispatch_table.get(op)
    if handler is None:
        raise VMError(f"Unknown opcode: 0x{op:02X} at PC={self.state.pc}")
    handler(dst, s1, s2, imm)
```

---

## 7. Built-in Commands

### 7.1 Daftar Built-in (Script Mode)

Built-in commands tersedia saat HCVM berjalan dalam
script mode (HL-18E):

| Command | Syntax | Fungsi |
|---|---|---|
| `EMIT` | `EMIT(args...)` | Output ke console |
| `COD18` | `COD18("ب")` | Load codex huruf |
| `AGGREGATE` | `AGGREGATE("بسم")` | Hitung string integral |
| `VERIFY_CHECKSUM` | `VERIFY_CHECKSUM(cod)` | Verifikasi guard |
| `VERIFY_MOD4` | `VERIFY_MOD4(cod)` | Verifikasi Mod-4 |
| `DECOMPOSE` | `DECOMPOSE(cod)` | Tampilkan U, ρ |
| `SEAL` | `SEAL()` | Hitung dataset SHA-256 |
| `TABLE` | `TABLE()` | Tampilkan master table |
| `COMPARE` | `COMPARE(c1, c2)` | Bandingkan dua codex |

### 7.2 Codex Object

Dalam script mode, codex direpresentasikan sebagai objek
dengan method:

```python
class Codex:
    def __init__(self, vector: List[int], char: str, name: str):
        self.vector = vector
        self.char = char
        self.name = name

    def pretty(self) -> str:
        return f"{self.char} ({self.name}): {self.vector}"

    def theta(self) -> int:
        return self.vector[0]

    def guard(self) -> bool:
        return guard_check(self.vector)
```

### 7.3 Contoh Script

```
(-- HCVM Script Example --)

LET text = "بسم"
LET agg = AGGREGATE(text)
EMIT("Aggregate:", agg)

LET ba = COD18("ب")
VERIFY_CHECKSUM(ba)
VERIFY_MOD4(ba)
DECOMPOSE(ba)

LET s = SEAL()
EMIT("SHA-256:", s)
```

---

## 8. Standard Library Bridge

### 8.1 Konsep

Saat HCVM menjalankan program HC melalui script engine,
ia memiliki akses ke **standard library modules** yang sama
dengan evaluator HC:

```
hm::vectronometry
hm::differential
hm::integral
hm::geometry
hm::exomatrix
```

### 8.2 Akses dari Script

```
LET h = COD18("ج")
LET n = hm::vectronometry::norm2(h)
EMIT("Norm2:", n)
```

### 8.3 Implementasi Bridge

```python
class VM:
    def __init__(self):
        self.builtins = {
            'emit': self._builtin_emit,
            'cod18': self._builtin_cod18,
            'aggregate': self._builtin_aggregate,
            'verify_checksum': self._builtin_verify_checksum,
            'verify_mod4': self._builtin_verify_mod4,
            'decompose': self._builtin_decompose,
            'seal': self._builtin_seal,
        }
        self.modules = {
            'hm': {
                'vectronometry': vectronometry_module(),
                'differential': differential_module(),
                'integral': integral_module(),
                'geometry': geometry_module(),
                'exomatrix': exomatrix_module(),
            }
        }
```

---

## 9. Memory Model

### 9.1 Layout

```
Address Space (default 64KB):

0x0000 ┌──────────────────────┐
       │ ROM (252 bytes)      │  Master Table (read-only)
0x00FC ├──────────────────────┤
       │ Code segment         │  Program bytecode
       ├──────────────────────┤
       │ Data segment         │  Static data
       ├──────────────────────┤
       │ Heap                 │  Dynamic allocation
       ├──────────────────────┤
       │ ↓ (grows down)       │
       │ Stack                │  Call stack
0xFFFF └──────────────────────┘
```

### 9.2 ROM

ROM berisi Master Table dalam format nibble-packed:
- 28 huruf × 9 bytes = 252 bytes
- read-only
- dimuat saat inisialisasi
- SHA-256 diverifikasi saat boot

### 9.3 RAM

RAM bersifat read-write dan digunakan untuk:
- variabel lokal,
- stack frame,
- data sementara,
- dan buffer.

### 9.4 Memory Operations

```python
def mem_read(self, addr: int) -> int:
    if addr < ROM_SIZE:
        return self.rom[addr]
    return self.ram[addr - ROM_SIZE]

def mem_write(self, addr: int, value: int):
    if addr < ROM_SIZE:
        raise VMError("Cannot write to ROM")
    self.ram[addr - ROM_SIZE] = value
```

---

## 10. I/O Model

### 10.1 Output Channels

HCVM mendukung output ke dua channel:

| Channel | Fungsi | Target |
|---|---|---|
| **stdout** | output utama | console / GUI console |
| **stderr** | error output | console / GUI diagnostics |

### 10.2 Output Handler

Output handler dapat di-override untuk integrasi GUI:

```python
class VM:
    def __init__(self):
        self.output_handler = self._default_output

    def _default_output(self, text: str):
        print(text)

    def set_output_handler(self, handler):
        """Override untuk GUI integration."""
        self.output_handler = handler
```

### 10.3 Integrasi GUI

Saat HCVM berjalan di dalam HOM GUI, output handler
diarahkan ke widget Text:

```python
def gui_emit(args):
    parts = []
    for a in args:
        if isinstance(a, Codex):
            parts.append(a.pretty())
        else:
            parts.append(str(a))
    line = " ".join(parts)
    text_widget.insert(tk.END, f"{line}\n")
```

### 10.4 Input **[PLANNED]**

HCVM v1.0 belum mendukung input interaktif.
Rencana v1.1 akan menambahkan:
- `READ()` untuk input string,
- `READINT()` untuk input integer.

---

## 11. Guard Engine

### 11.1 Fungsi

Guard Engine adalah subsistem HCVM yang memvalidasi
codex secara struktural sebelum atau sesudah operasi.

### 11.2 Guard Checks

```python
def guard_check(vector: List[int]) -> bool:
    theta = vector[0]
    U = vector[10] + vector[11] + vector[12] + 4 * vector[13]
    rho = theta - U

    g1 = rho >= 0
    g2 = vector[14] == vector[1] + vector[2] + vector[3]
    g3 = vector[15] == vector[4] + vector[5] + vector[6] + vector[7] + vector[8]
    g4 = vector[16] == vector[9] + vector[10] + vector[11] + vector[12] + vector[13]

    return g1 and g2 and g3 and g4
```

### 11.3 Guard dalam Bytecode Mode

Instruksi `VCHK` memanggil guard engine dan mengatur
flag GUARD:

```python
def _vchk(self, dst, s1, s2, imm):
    vector = self.state.hreg[s1]
    result = guard_check(vector)
    if result:
        self.state.flags |= FLAG_GUARD
    else:
        self.state.flags &= ~FLAG_GUARD
```

### 11.4 Guard dalam Script Mode

Built-in `VERIFY_CHECKSUM` memanggil guard engine
dan menampilkan hasil:

```python
def _builtin_verify_checksum(self, codex):
    vector = codex.vector
    result = guard_check(vector)
    self.emit(f"Guard check: {'PASS' if result else 'FAIL'}")
    if result:
        self.emit("  G1 (ρ ≥ 0):    PASS")
        self.emit("  G2 (A_N):      PASS")
        self.emit("  G3 (A_K):      PASS")
        self.emit("  G4 (A_Q):      PASS")
```

---

## 12. Script Engine

### 12.1 Arsitektur

```
Source Text
    │
    ▼
HL-18E Lexer → Token Stream
    │
    ▼
HL-18E Parser → AST
    │
    ▼
Evaluator → Result
```

### 12.2 Script Language (HL-18E)

Script mode menggunakan bahasa HL-18E yang merupakan
subset dari HC dengan tambahan command-style syntax:

```
(-- comment --)

LET variable = expression
EMIT(args...)
COD18("char")
AGGREGATE("text")
VERIFY_CHECKSUM(codex)
VERIFY_MOD4(codex)
DECOMPOSE(codex)
SEAL()
```

### 12.3 Perbedaan HL-18E dan HC

| Aspek | HC | HL-18E (HCVM script) |
|---|---|---|
| Deklarasi | `let x = 10;` | `LET x = 10` |
| Fungsi | `fn name() {}` | tidak didukung |
| Kontrol alur | if/while/for/match | tidak didukung |
| Komentar | `// ...` | `(-- ... --)` |
| Semicolon | opsional | tidak ada |
| Built-in | load, println | EMIT, COD18, AGGREGATE |
| Tujuan | programming | scripting / command |

### 12.4 Token Types (HL-18E)

| Token | Contoh |
|---|---|
| KEYWORD | `LET`, `EMIT`, `AGGREGATE` |
| STRING | `"بسم"` |
| INTEGER | `42` |
| IDENTIFIER | `text`, `agg` |
| OPERATOR | `=` |
| LPAREN/RPAREN | `(`, `)` |
| COMMA | `,` |
| COMMENT | `(-- ... --)` |

---

## 13. Bytecode Mode

### 13.1 Loading Bytecode

```python
def load_bytecode(self, bytecode: List[int]):
    """Load H-ISA bytecode ke memory."""
    for i, word in enumerate(bytecode):
        self.memory.store_word(CODE_BASE + i * 4, word)
    self.state.pc = CODE_BASE // 4
```

### 13.2 Execution

```python
def run_bytecode(self):
    """Execute loaded bytecode."""
    while not self.state.halted:
        addr = self.state.pc * 4
        word = self.memory.fetch_word(addr)
        self.execute_word(word)
        if not self.state.halted:
            self.state.pc += 1
            self.state.cycle += 1
```

### 13.3 Contoh Bytecode

```python
# Load Ba, check guard, emit result
bytecode = [
    0x40000002,  # CLOAD H0, #2 (Ba)
    0x60000000,  # VCHK H0
    0xA1000000,  # EMITC H0
    0x01000000,  # HALT
]

vm = HCVM()
vm.load_bytecode(bytecode)
vm.run_bytecode()
```

---

## 14. Sandbox dan Keamanan

### 14.1 Prinsip Sandbox

HCVM menerapkan prinsip **least privilege**:
- script/bytecode **tidak boleh** mengakses filesystem,
- script/bytecode **tidak boleh** mengakses network,
- script/bytecode **tidak boleh** memodifikasi ROM,
- eksekusi dibatasi oleh cycle limit (opsional).

### 14.2 Batasan Saat Ini

| Fitur | Status |
|---|---|
| File I/O | **dilarang** |
| Network I/O | **dilarang** |
| System calls | **terbatas** (hanya EMIT) |
| ROM write | **dilarang** (hardware-enforced) |
| RAM limit | **configurable** |
| Cycle limit | **configurable** |
| Recursion limit | **configurable** |

### 14.3 Cycle Limit

```python
MAX_CYCLES = 1_000_000  # default

def run(self):
    while not self.state.halted:
        if self.state.cycle >= MAX_CYCLES:
            raise VMError("Cycle limit exceeded")
        # ... execute ...
```

### 14.4 Rekomendasi Keamanan

```
⚠️ JANGAN jalankan kode dari sumber yang tidak dipercaya
   tanpa review terlebih dahulu.

⚠️ HCVM v1.0 belum memiliki sandbox yang sudah diaudit
   untuk penggunaan production.

⚠️ Gunakan HCVM hanya untuk:
   - pengembangan dan pengujian,
   - eksplorasi ilmiah,
   - dan demonstrasi.
```

---

## 15. Integrasi dengan HOM

### 15.1 Tab HCVM di HOM

HOM menyediakan tab **HCVM Console** yang mengintegrasikan
HCVM ke dalam GUI:

```
┌────────────────────────────────────────────┐
│ HCVM Console                               │
│                                            │
│ ┌──────────────────┐ ┌──────────────────┐  │
│ │ Script Editor    │ │ VM Console       │  │
│ │                  │ │                  │  │
│ │ (-- script --)   │ │ --- OUTPUT ---   │  │
│ │ LET x = ...      │ │ ...              │  │
│ │                  │ │                  │  │
│ └──────────────────┘ └──────────────────┘  │
│                                            │
│ [▶ Run] [Hello] [Financial] [Table] [Seal] │
└────────────────────────────────────────────┘
```

### 15.2 Output Redirection

Saat berjalan di HOM, output HCVM diarahkan ke widget
GUI alih-alih stdout:

```python
vm = HCVM()
vm.set_output_handler(gui_emit_function)
vm.run_script(source)
```

### 15.3 Demo Scripts

HOM menyediakan demo scripts bawaan:

| Demo | Fungsi |
|---|---|
| **Hello** | output sederhana |
| **Financial** | contoh validasi integritas |
| **Protocol** | pipeline lengkap AGGREGATE + VERIFY + SEAL |

---

## 16. Integrasi dengan HC Compiler

### 16.1 Pipeline

```
HC Source (.hc)
    │
    ▼
HC Compiler
    │
    ▼
H-ISA Assembly (.hisa)
    │
    ▼
H-ISA Assembler
    │
    ▼
Bytecode (List[int])
    │
    ▼
HCVM.load_bytecode()
    │
    ▼
HCVM.run_bytecode()
```

### 16.2 Contoh Pipeline

```python
from hijaiyyah.language import Lexer, Parser
from hijaiyyah.hisa.compiler import HISACompiler
from hijaiyyah.hisa.assembler import HISAAssembler

# Compile HC → assembly
source = "let h = load('ب'); println(h.theta());"
tokens = Lexer(source).tokenize()
ast = Parser(tokens).parse()
assembly = HISACompiler().compile(ast)

# Assemble → bytecode
bytecode = HISAAssembler().assemble(assembly)

# Execute pada HCVM
vm = HCVM()
vm.load_bytecode(bytecode)
vm.run_bytecode()
```

### 16.3 Status Compiler

HC → H-ISA compiler berstatus **awal**.
Subset operasi yang didukung:
- load codex,
- akses komponen,
- guard check,
- output.

Operasi yang belum didukung:
- kontrol alur kompleks,
- fungsi user-defined,
- full standard library bridge.

---

## 17. Diagnostik dan Debug

### 17.1 Trace Mode

```python
vm = HCVM()
vm.set_trace(True)
vm.run_bytecode(code)
```

Output trace:

```
[0001] CLOAD H0, #2        ; H0 ← Ba
[0002] VCHK  H0            ; GUARD ← 1
[0003] EMITC H0            ; output codex
[0004] HALT                 ; stopped
```

### 17.2 State Dump

```python
state = vm.dump_state()
print(json.dumps(state, indent=2))
```

### 17.3 Breakpoint **[PLANNED]**

```python
vm.set_breakpoint(address=0x10)
vm.run_bytecode(code)
# pauses at address 0x10
```

### 17.4 Step Execution

```python
vm.load_bytecode(code)
while not vm.state.halted:
    entry = vm.step()
    print(entry)
```

### 17.5 Register Inspector

```python
print(vm.state.gpr)      # [0, 0, 0, ...]
print(vm.state.hreg[0])  # [2, 0, 0, 1, ...]
print(vm.state.flags)    # {"GUARD": true, "ZERO": false, "OVR": false}
```

---

## 18. Performa dan Benchmark

### 18.1 Metrik Target

| Operasi | Target | Status |
|---|---|---|
| CLOAD | < 1 μs | belum diukur |
| CADD | < 1 μs | belum diukur |
| VCHK | < 1 μs | belum diukur |
| CDIST | < 5 μs | belum diukur |
| CPHI | < 10 μs | belum diukur |
| Script parse + eval | < 100 ms (1000 LOC) | belum diukur |

### 18.2 Benchmark Suite **[PLANNED]**

```python
# tools/benchmark.py

def benchmark_cload(n=10000):
    """Benchmark CLOAD operation."""
    ...

def benchmark_cadd(n=10000):
    """Benchmark CADD operation."""
    ...

def benchmark_vchk(n=10000):
    """Benchmark VCHK operation."""
    ...
```

### 18.3 Catatan

```
⚠️ Benchmark formal belum tersedia pada v1.0.
   Angka-angka target di atas adalah estimasi berdasarkan
   kompleksitas operasi, bukan hasil pengukuran.
```

---

## 19. API Referensi

### 19.1 Class `VM`

```python
class VM:
    """Hijaiyyah Codex Virtual Machine."""

    def __init__(self, ram_size: int = 65536):
        """Initialize VM with specified RAM size."""

    def run_script(self, source: str) -> None:
        """Execute HL-18E script from source text."""

    def load_bytecode(self, bytecode: List[int]) -> None:
        """Load H-ISA bytecode into code segment."""

    def run_bytecode(self) -> None:
        """Execute loaded bytecode until HALT or error."""

    def step(self) -> Optional[TraceEntry]:
        """Execute one instruction and return trace entry."""

    def reset(self) -> None:
        """Reset machine state to initial values."""

    def dump_state(self) -> Dict[str, Any]:
        """Return complete machine state snapshot."""

    def set_output_handler(self, handler: Callable) -> None:
        """Override output handler for GUI integration."""

    def set_trace(self, enabled: bool) -> None:
        """Enable or disable execution trace."""

    def set_cycle_limit(self, limit: int) -> None:
        """Set maximum cycle count before forced halt."""
```

### 19.2 Class `Codex`

```python
class Codex:
    """Codex object for HCVM script mode."""

    vector: List[int]   # 18-component integer vector
    char: str           # canonical Hijaiyyah character
    name: str           # letter name

    def pretty(self) -> str:
        """Human-readable representation."""

    def theta(self) -> int:
        """Return Θ̂ value."""

    def guard(self) -> bool:
        """Return guard check result."""

    def rho(self) -> int:
        """Return ρ = Θ̂ - U."""

    def U(self) -> int:
        """Return turning budget U."""
```

### 19.3 Class `TraceEntry`

```python
@dataclass
class TraceEntry:
    """Single execution trace entry."""
    cycle: int
    pc: int
    opcode: int
    mnemonic: str
    description: str
    flags_before: int
    flags_after: int
```

### 19.4 Exceptions

```python
class VMError(Exception):
    """Base HCVM error."""

class VMHaltError(VMError):
    """Normal HALT execution."""

class VMCycleLimitError(VMError):
    """Cycle limit exceeded."""

class VMMemoryError(VMError):
    """Invalid memory access."""

class VMOpcodeError(VMError):
    """Unknown or invalid opcode."""
```

---

## 20. Contoh Eksekusi

### 20.1 Standalone Script Execution

```python
from hcvm import VM

source = """
(-- Compute codex for "بسم" --)
LET text = "بسم"
LET agg = AGGREGATE(text)
EMIT("Result:", agg)
LET s = SEAL()
EMIT("Seal:", s)
"""

vm = VM()
vm.run_script(source)
```

**Output:**

```
Result: [10, 0, 0, 1, 0, 1, 0, 0, 1, 2, 2, 0, 0, 1, 1, 2, 5, 0]
Seal: f82d385917ffe32ae2b5711409b1341e90934c52172ae9d0fa68888e3b9c51c8
```

### 20.2 Bytecode Execution

```python
from hcvm import VM

bytecode = [
    0x40000002,  # CLOAD H0, #2    (Ba)
    0x40010018,  # CLOAD H1, #24   (Mim)
    0x42020001,  # CADD  H2, H0, H1
    0xA1020000,  # EMITC H2
    0x60020000,  # VCHK  H2
    0x01000000,  # HALT
]

vm = VM()
vm.set_trace(True)
vm.load_bytecode(bytecode)
vm.run_bytecode()
```

**Output:**

```
[0001] CLOAD H0, #2     ; H0 ← Ba
[0002] CLOAD H1, #24    ; H1 ← Mim
[0003] CADD  H2, H0, H1 ; H2 ← Ba + Mim
[0004] EMITC H2         ; output codex
[0005] VCHK  H2         ; GUARD ← 1
[0006] HALT             ; stopped

Codex: [6, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 2, 2, 0]
```

### 20.3 Financial Integrity Demo

```python
source = """
(-- Financial record integrity demo --)

LET record = "بسم الله"
LET cod = AGGREGATE(record)
EMIT("Record codex:", cod)
VERIFY_CHECKSUM(cod)

(-- Simulate tampering --)
EMIT("Simulating tampered data...")
LET tampered = AGGREGATE("بسن")
VERIFY_CHECKSUM(tampered)

EMIT("Original seal:")
LET s = SEAL()
EMIT(s)
"""

vm = VM()
vm.run_script(source)
```

### 20.4 Step-by-Step Execution

```python
vm = VM()
vm.load_bytecode([0x40000005, 0x60000000, 0x01000000])

while not vm.state.halted:
    entry = vm.step()
    print(f"Cycle {entry.cycle}: {entry.mnemonic} — {entry.description}")
    print(f"  Flags: G={vm.state.flags & 1}")
    print(f"  H0: {vm.state.hreg[0][:5]}...")
    print()
```

---

## 21. Batasan dan Rencana

### 21.1 Batasan v1.0

| Batasan | Penjelasan |
|---|---|
| Tidak ada input interaktif | EMIT only, no READ |
| Tidak ada file I/O | sandbox restriction |
| Tidak ada networking | sandbox restriction |
| Script mode terbatas | HL-18E subset, bukan HC penuh |
| Bytecode compiler belum lengkap | subset instruksi |
| Tidak ada debugger interaktif | hanya trace/dump |
| Tidak ada profiler | hanya cycle counter |
| Tidak ada multi-threading | single-threaded |
| Benchmark belum tersedia | estimasi saja |

### 21.2 Rencana v1.1 **[PLANNED]**

```
□ READ() dan READINT() untuk input
□ Interactive REPL mode
□ Breakpoint support
□ Profiling counters per opcode
□ Memory usage tracking
□ Improved error messages
□ Script mode control flow (IF/WHILE)
```

### 21.3 Rencana v2.0 **[PLANNED]**

```
□ Full HC execution (bukan hanya HL-18E subset)
□ JIT compilation for hot paths
□ Sandboxed file I/O
□ Network capability (opt-in)
□ WebAssembly compilation target
□ Remote debugging protocol
□ Concurrent execution model
□ Plugin system
```

---

## 22. Referensi

| Referensi | Deskripsi |
|---|---|
| `docs/architecture.md` | Arsitektur HOM |
| `docs/hc_language.md` | Spesifikasi HC Language |
| `docs/hisa_spec.md` | Spesifikasi H-ISA |
| `hcvm.py` | Standalone VM implementation |
| `src/hijaiyyah/gui/tabs/hcvm.py` | GUI integration |
| `src/hijaiyyah/hisa/machine.py` | H-ISA machine core |
| Bab I–II | Fondasi dan operasi Matematika Hijaiyyah |
| Bab IV | Hijaiyyah Technology Stack |

---

<div align="center">

**HCVM — Hijaiyyah Codex Virtual Machine**

*Version 1.0 · HM-28-v1.0-HC18D · 2026*

© 2026 Hijaiyyah Mathematics Computational Laboratory (HMCL)

</div>
